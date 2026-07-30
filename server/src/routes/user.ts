import { Router } from 'express';
import { prisma } from '../db.js';
import { authenticateToken, AuthRequest } from '../middleware/auth.js';

export const userRouter = Router();

// GET /api/v1/user/profile
userRouter.get('/profile', authenticateToken, async (req: AuthRequest, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.userId },
      select: {
        id: true,
        email: true,
        name: true,
        targetLanguage: true,
        streakCount: true,
        xpTotal: true,
        gemsCount: true,
        isPremium: true,
        createdAt: true,
      },
    });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(user);
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Failed to fetch profile' });
  }
});

// PATCH /api/v1/user/profile
userRouter.patch('/profile', authenticateToken, async (req: AuthRequest, res) => {
  try {
    const { name, targetLanguage, streakCount, xpTotal, gemsCount, isPremium } = req.body;

    const user = await prisma.user.update({
      where: { id: req.userId },
      data: {
        ...(name !== undefined && { name }),
        ...(targetLanguage !== undefined && { targetLanguage }),
        ...(streakCount !== undefined && { streakCount }),
        ...(xpTotal !== undefined && { xpTotal }),
        ...(gemsCount !== undefined && { gemsCount }),
        ...(isPremium !== undefined && { isPremium }),
      },
    });

    res.json({
      id: user.id,
      email: user.email,
      name: user.name,
      targetLanguage: user.targetLanguage,
      streakCount: user.streakCount,
      xpTotal: user.xpTotal,
      gemsCount: user.gemsCount,
      isPremium: user.isPremium,
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Failed to update profile' });
  }
});

// DELETE /api/v1/user/profile - Account Deletion per Google Play & PDPA Privacy Policy
userRouter.delete('/profile', authenticateToken, async (req: AuthRequest, res) => {
  try {
    const userId = req.userId!;
    await prisma.user.delete({
      where: { id: userId },
    });
    res.json({ success: true, message: 'Account and associated user data permanently deleted.' });
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Failed to delete account' });
  }
});
