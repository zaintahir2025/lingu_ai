import { Router } from 'express';
import { prisma } from '../db.js';

export const leaderboardRouter = Router();

// GET /api/v1/leaderboard
leaderboardRouter.get('/', async (req, res) => {
  try {
    const topUsers = await prisma.user.findMany({
      take: 50,
      orderBy: { xpTotal: 'desc' },
      select: {
        id: true,
        name: true,
        xpTotal: true,
        streakCount: true,
        targetLanguage: true,
      },
    });

    const ranked = topUsers.map((user, index) => ({
      rank: index + 1,
      ...user,
    }));

    res.json(ranked);
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Failed to fetch leaderboard' });
  }
});
