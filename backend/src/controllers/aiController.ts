import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { GoogleGenerativeAI } from '@google/generative-ai';

const prisma = new PrismaClient();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '');

export const tutorChat = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = (req as any).user.userId;
    const { prompt, contextWords } = req.body;

    // Premium Check: AI Tutor is a paid feature
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: { subscriptions: true }
    });

    if (!user) {
      res.status(404).json({ error: 'User not found' });
      return;
    }

    // Check if user has an active subscription or is an admin
    const hasActiveSub = user.role === 'admin' || user.subscriptions.some(s => s.status === 'active' && s.expiresAt > new Date());
    
    if (!hasActiveSub) {
      res.status(403).json({ 
        error: 'AI Tutor is a premium feature. Please upgrade to unlock.',
        premiumRequired: true 
      });
      return;
    }

    if (!prompt || typeof prompt !== 'string' || prompt.trim() === '') {
      res.status(400).json({ error: 'Prompt is required.' });
      return;
    }

    // Call Gemini API
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

    const systemPrompt = `You are a friendly, encouraging language tutor (like a Duolingo mascot). 
    The user is learning ${user.targetLanguage}. Their current knowledge level is ${user.knowledgeLevel || 'unknown'} and fluency score is ${user.fluencyScore || 'unknown'}/100.
    ${contextWords ? `The user recently struggled with these words: ${contextWords.join(', ')}.` : ''}
    Keep your responses short, highly engaging, and playful. Use emojis. Correct any mistakes they make gently.`;

    const result = await model.generateContent({
      contents: [
        { role: 'user', parts: [{ text: systemPrompt + '\n\nUser message: ' + prompt }] }
      ]
    });

    const aiResponse = result.response.text();

    res.status(200).json({ response: aiResponse });
  } catch (error) {
    console.error('AI Tutor Error:', error);
    res.status(500).json({ error: 'Internal server error during AI call.' });
  }
};
