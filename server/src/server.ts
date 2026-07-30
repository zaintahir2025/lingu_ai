import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';

import { authRouter } from './routes/auth.js';
import { userRouter } from './routes/user.js';
import { lessonsRouter } from './routes/lessons.js';
import { progressRouter } from './routes/progress.js';
import { leaderboardRouter } from './routes/leaderboard.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security & Logging Middlewares
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// API Routes
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/user', userRouter);
app.use('/api/v1/lessons', lessonsRouter);
app.use('/api/v1/progress', progressRouter);
app.use('/api/v1/leaderboard', leaderboardRouter);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'Lingu AI PostgreSQL Backend', timestamp: new Date() });
});

app.listen(PORT, () => {
  console.log(`🚀 Lingu AI Server running on http://localhost:${PORT}`);
});
