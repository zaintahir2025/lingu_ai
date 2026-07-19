import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';
import { sendVerificationEmail } from '../utils/mailer';
import crypto from 'crypto';

const prisma = new PrismaClient();
const JWT_SECRET = process.env.JWT_SECRET;
const REFRESH_SECRET = process.env.REFRESH_SECRET;

if (!JWT_SECRET || !REFRESH_SECRET) {
  console.error('FATAL ERROR: JWT_SECRET or REFRESH_SECRET is not defined in environment variables.');
  process.exit(1);
}

export const register = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, password } = req.body;

    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      res.status(400).json({ error: 'Email already exists' });
      return;
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: {
        email,
        passwordHash,
        targetLanguage: 'es', // Default, updated later
        isEmailVerified: false, 
      } as any,
    });

    const verifyToken = crypto.randomBytes(32).toString('hex');
    await prisma.verificationToken.create({
      data: {
        email,
        token: verifyToken,
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 hours
      }
    });

    // Send Verification Email
    await sendVerificationEmail(email, verifyToken);

    res.status(201).json({ 
      message: 'User registered successfully. Please verify your email.',
    });
  } catch (error) {
    console.error('[Register API Error] Failed to register user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, password, device } = req.body;
    
    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) {
      res.status(401).json({ error: 'Invalid credentials' });
      return;
    }

    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) {
      res.status(401).json({ error: 'Invalid credentials' });
      return;
    }

    if (!user.isEmailVerified) {
      res.status(403).json({ error: 'Please verify your email first.' });
      return;
    }

    const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '1h' });
    const refreshToken = jwt.sign({ userId: user.id }, REFRESH_SECRET, { expiresIn: '7d' });

    await prisma.refreshToken.create({
      data: {
        token: refreshToken,
        userId: user.id,
        device: device || 'unknown',
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
      }
    });

    res.status(200).json({ 
      token, 
      refreshToken, 
      user: {
        id: user.id.toString(),
        email: user.email,
        username: user.username,
        targetLanguage: (user as any).targetLanguage,
        knowledgeLevel: (user as any).knowledgeLevel,
      }
    });
  } catch (error) {
    console.error('[Login API Error] Failed to log in user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const logout = async (req: Request, res: Response): Promise<void> => {
  try {
    const { refreshToken, allDevices } = req.body;

    if (allDevices) {
      // Decode to get userId and delete all tokens
      const decoded = jwt.verify(refreshToken, REFRESH_SECRET) as any;
      await prisma.refreshToken.deleteMany({ where: { userId: decoded.userId } });
    } else {
      await prisma.refreshToken.delete({ where: { token: refreshToken } });
    }
    
    res.status(200).json({ message: 'Logged out successfully' });
  } catch (error) {
    res.status(400).json({ error: 'Invalid token' });
  }
};

export const refreshToken = async (req: Request, res: Response): Promise<void> => {
  try {
    const { token } = req.body;
    
    const storedToken = await prisma.refreshToken.findUnique({ where: { token } });
    if (!storedToken) {
      res.status(401).json({ error: 'Invalid refresh token' });
      return;
    }

    const decoded: any = jwt.verify(token, REFRESH_SECRET);
    const newToken = jwt.sign({ userId: decoded.userId }, JWT_SECRET, { expiresIn: '1h' });
    
    res.status(200).json({ token: newToken });
  } catch (error) {
    res.status(401).json({ error: 'Invalid refresh token' });
  }
};

export const verifyEmail = async (req: Request, res: Response): Promise<void> => {
  try {
    const { token } = req.query;
    if (!token || typeof token !== 'string') {
      res.status(400).json({ error: 'Invalid or missing token.' });
      return;
    }

    const verificationToken = await prisma.verificationToken.findUnique({
      where: { token },
    });

    if (!verificationToken) {
      res.status(400).json({ error: 'Invalid or expired token.' });
      return;
    }

    if (new Date() > verificationToken.expiresAt) {
      res.status(400).json({ error: 'Token has expired.' });
      return;
    }

    // Verify User
    await prisma.user.update({
      where: { email: verificationToken.email },
      data: { isEmailVerified: true },
    });

    // Delete token
    await prisma.verificationToken.delete({
      where: { id: verificationToken.id },
    });

    res.status(200).send(`
      <html>
        <head><title>Email Verified</title></head>
        <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
          <h1 style="color: #4CAF50;">Email Verified Successfully! 🎉</h1>
          <p>You can now return to the LinguAI app and log in.</p>
        </body>
      </html>
    `);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to verify email.' });
  }
};

export const deleteAccount = async (req: any, res: Response): Promise<void> => {
  try {
    const userId = req.user.userId;

    // Delete all user related data
    // Because of onDelete: Cascade in Prisma schema, deleting the user
    // will automatically delete their UserVocab, DailyXp, RefreshTokens, etc.
    await prisma.user.delete({ where: { id: userId } });

    res.status(200).json({ message: 'Account deleted successfully' });
  } catch (error) {
    console.error('Delete account error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const forgotPassword = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email } = req.body;
    const user = await prisma.user.findUnique({ where: { email } });

    if (!user) {
      // Don't leak whether the email exists, always return success
      res.status(200).json({ message: 'If that email exists, we sent a password reset link.' });
      return;
    }

    // Generate a simple 6-digit code or crypto token
    const token = Math.floor(100000 + Math.random() * 900000).toString();
    
    await prisma.passwordResetToken.create({
      data: {
        email,
        token,
        expiresAt: new Date(Date.now() + 15 * 60 * 1000), // 15 minutes
      }
    });

    // In a real app, send the token via email here.
    console.log(`Password reset token for ${email}: ${token}`);
    
    res.status(200).json({ message: 'If that email exists, we sent a password reset link.' });
  } catch (error) {
    console.error('Forgot password error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const resetPassword = async (req: Request, res: Response): Promise<void> => {
  try {
    const { token, newPassword } = req.body;

    if (!token || !newPassword || newPassword.length < 6) {
      res.status(400).json({ error: 'Invalid token or password too short' });
      return;
    }

    const resetRecord = await prisma.passwordResetToken.findUnique({ where: { token } });

    if (!resetRecord || resetRecord.expiresAt < new Date()) {
      res.status(400).json({ error: 'Invalid or expired reset token' });
      return;
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);

    await prisma.user.update({
      where: { email: resetRecord.email },
      data: { passwordHash: hashedPassword }
    });

    // Clean up all reset tokens for this email
    await prisma.passwordResetToken.deleteMany({ where: { email: resetRecord.email } });

    res.status(200).json({ message: 'Password has been reset successfully' });
  } catch (error) {
    console.error('Reset password error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
