import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const updateProfile = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = (req as any).user.userId;
    const { username, avatarId, dob, targetLanguage } = req.body;

    const user = await prisma.user.update({
      where: { id: userId },
      data: {
        ...(username && { username }),
        ...(avatarId && { avatarId }),
        ...(dob && { dob: new Date(dob) }),
        ...(targetLanguage && { targetLanguage }),
      },
    });

    res.status(200).json({ message: 'Profile updated successfully', user: {
      id: user.id.toString(),
      email: user.email,
      username: user.username,
      targetLanguage: user.targetLanguage,
      knowledgeLevel: user.knowledgeLevel,
    }});
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error while updating profile' });
  }
};

export const submitSurvey = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = (req as any).user.userId;
    const { knowledgeLevel, fluencyScore, targetLanguage } = req.body;

    const user = await prisma.user.update({
      where: { id: userId },
      data: {
        ...(knowledgeLevel && { knowledgeLevel }),
        ...(fluencyScore !== undefined && { fluencyScore }),
        ...(targetLanguage && { targetLanguage }),
      },
    });

    // Dynamically assign lessons based on knowledgeLevel
    const allLessons = await prisma.lesson.findMany({
      orderBy: { orderIndex: 'asc' },
    });

    let unlockCount = 1;
    if (knowledgeLevel === 'intermediate') unlockCount = 3;
    if (knowledgeLevel === 'advanced') unlockCount = 5;

    for (let i = 0; i < Math.min(unlockCount, allLessons.length); i++) {
      await prisma.userLesson.upsert({
        where: {
          userId_lessonId: { userId, lessonId: allLessons[i].id },
        },
        update: { isLocked: false },
        create: {
          userId,
          lessonId: allLessons[i].id,
          isLocked: false,
        },
      });
    }

    res.status(200).json({ message: 'Survey submitted and lessons assigned', user: {
      id: user.id.toString(),
      email: user.email,
      username: user.username,
      targetLanguage: user.targetLanguage,
      knowledgeLevel: user.knowledgeLevel,
    }});
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error while submitting survey' });
  }
};
