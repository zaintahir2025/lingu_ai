import { Router } from 'express';
import { prisma } from '../db.js';
import { authenticateToken, AuthRequest } from '../middleware/auth.js';

export const progressRouter = Router();

// GET /api/v1/progress - Fetch user completed lessons & word SRS state
progressRouter.get('/', authenticateToken, async (req: AuthRequest, res) => {
  try {
    const userId = req.userId!;
    const progressList = await prisma.userProgress.findMany({
      where: { userId },
      include: { lesson: true },
    });

    const wordMastery = await prisma.userWordMastery.findMany({
      where: { userId },
      include: { vocabWord: true },
    });

    res.json({ progress: progressList, wordMastery });
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Failed to fetch progress' });
  }
});

// POST /api/v1/progress/sync - Record completed lesson and update SRS
progressRouter.post('/sync', authenticateToken, async (req: AuthRequest, res) => {
  try {
    const userId = req.userId!;
    const { lessonId, score, wordUpdates } = req.body;

    // Record lesson progress
    if (lessonId) {
      await prisma.userProgress.upsert({
        where: {
          userId_lessonId: { userId, lessonId: Number(lessonId) },
        },
        update: {
          isCompleted: true,
          score: Number(score) || 100,
          completedAt: new Date(),
        },
        create: {
          userId,
          lessonId: Number(lessonId),
          isCompleted: true,
          score: Number(score) || 100,
        },
      });
    }

    // Process SRS Word Mastery updates
    if (Array.isArray(wordUpdates)) {
      for (const item of wordUpdates) {
        const { wordId, isCorrect } = item;
        const existing = await prisma.userWordMastery.findUnique({
          where: { userId_wordId: { userId, wordId: Number(wordId) } },
        });

        let newLevel = isCorrect ? (existing?.masteryLevel || 0) + 1 : Math.max(0, (existing?.masteryLevel || 0) - 1);
        if (newLevel > 5) newLevel = 5;

        // SRS interval: Level 0=1d, Level 1=2d, Level 2=4d, Level 3=7d, Level 4=14d, Level 5=30d
        const intervals = [1, 2, 4, 7, 14, 30];
        const daysToAdd = intervals[newLevel] || 1;
        const nextReviewAt = new Date(Date.now() + daysToAdd * 24 * 60 * 60 * 1000);

        await prisma.userWordMastery.upsert({
          where: { userId_wordId: { userId, wordId: Number(wordId) } },
          update: { masteryLevel: newLevel, nextReviewAt },
          create: { userId, wordId: Number(wordId), masteryLevel: newLevel, nextReviewAt },
        });
      }
    }

    res.json({ success: true });
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Progress sync failed' });
  }
});
