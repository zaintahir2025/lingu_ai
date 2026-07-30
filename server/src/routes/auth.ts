import { Router } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../db.js';

export const authRouter = Router();

// POST /api/v1/auth/register
authRouter.post('/register', async (req, res) => {
  try {
    const { email, password, name, targetLanguage } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ error: 'User already exists with this email' });
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: {
        email,
        passwordHash,
        name: name || email.split('@')[0],
        targetLanguage: targetLanguage || 'es',
      },
    });

    const secret = process.env.JWT_SECRET || 'lingu_ai_super_secret_jwt_key_2026';
    const token = jwt.sign({ userId: user.id, email: user.email }, secret, { expiresIn: '30d' });

    res.status(201).json({
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        targetLanguage: user.targetLanguage,
        streakCount: user.streakCount,
        xpTotal: user.xpTotal,
        gemsCount: user.gemsCount,
        isPremium: user.isPremium,
      },
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Registration failed' });
  }
});

// POST /api/v1/auth/login
authRouter.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const secret = process.env.JWT_SECRET || 'lingu_ai_super_secret_jwt_key_2026';
    const token = jwt.sign({ userId: user.id, email: user.email }, secret, { expiresIn: '30d' });

    res.json({
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        targetLanguage: user.targetLanguage,
        streakCount: user.streakCount,
        xpTotal: user.xpTotal,
        gemsCount: user.gemsCount,
        isPremium: user.isPremium,
      },
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Login failed' });
  }
});
