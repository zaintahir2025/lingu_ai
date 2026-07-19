import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import rateLimit from 'express-rate-limit';
import authRoutes from './routes/auth';
import aiProxyRoutes from './routes/ai';
import userRoutes from './routes/user';
import { webhookRoutes } from './routes/webhooks';
import { e2eeMiddleware } from './middleware/e2eeMiddleware';

dotenv.config();

const app = express();

// Trust reverse proxy (e.g. AWS ALB, Nginx, Cloudflare) so rate limiting uses correct IP
app.set('trust proxy', 1);

app.use(helmet());
app.use(cors({
  origin: process.env.ALLOWED_ORIGIN || '*', // Lock down in production
}));
app.use(express.json());
app.use(e2eeMiddleware);

// Apply rate limiting to auth routes to prevent brute force
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 50, // Limit each IP to 50 requests per windowMs
  message: { error: 'Too many requests from this IP, please try again after 15 minutes' },
  standardHeaders: true,
  legacyHeaders: false,
});

// Routes
app.use('/api/auth', authLimiter, authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/ai', aiProxyRoutes);
app.use('/api/webhooks', webhookRoutes);

// Health check endpoint for uptime monitoring
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', timestamp: new Date() });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
