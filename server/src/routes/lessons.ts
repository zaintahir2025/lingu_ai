import { Router } from 'express';
import { prisma } from '../db.js';

export const lessonsRouter = Router();

// GET /api/v1/lessons?language=es
lessonsRouter.get('/', async (req, res) => {
  try {
    const language = (req.query.language as string) || 'es';
    const lessons = await prisma.lesson.findMany({
      where: { languageCode: language },
      include: { vocabWords: true },
      orderBy: [{ unitNumber: 'asc' }, { orderIndex: 'asc' }],
    });

    res.json(lessons);
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Failed to fetch lessons' });
  }
});

// POST /api/v1/lessons/seed - Initial curriculum seeding
lessonsRouter.post('/seed', async (req, res) => {
  try {
    const existing = await prisma.lesson.count();
    if (existing > 0) {
      return res.json({ message: 'Curriculum already seeded', count: existing });
    }

    // Seed Spanish Basics
    const lesson1 = await prisma.lesson.create({
      data: {
        title: 'Basic Greetings',
        languageCode: 'es',
        unitNumber: 1,
        orderIndex: 1,
        vocabWords: {
          create: [
            { word: 'Hola', translation: 'Hello', exampleSentence: 'Hola, ¿cómo estás?' },
            { word: 'Buenos días', translation: 'Good morning', exampleSentence: 'Buenos días a todos.' },
            { word: 'Gracias', translation: 'Thank you', exampleSentence: 'Muchas gracias por todo.' },
          ],
        },
      },
    });

    const lesson2 = await prisma.lesson.create({
      data: {
        title: 'Essential Phrases',
        languageCode: 'es',
        unitNumber: 1,
        orderIndex: 2,
        vocabWords: {
          create: [
            { word: 'Por favor', translation: 'Please', exampleSentence: 'Un café, por favor.' },
            { word: 'De nada', translation: 'You are welcome', exampleSentence: 'De nada, un placer.' },
            { word: 'Hasta luego', translation: 'See you later', exampleSentence: 'Adiós, hasta luego.' },
          ],
        },
      },
    });

    res.status(201).json({ message: 'Curriculum successfully seeded', lessons: [lesson1, lesson2] });
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Seeding failed' });
  }
});
