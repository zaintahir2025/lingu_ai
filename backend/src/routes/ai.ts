import { Router } from 'express';
import { tutorChat } from '../controllers/aiController';
import { requireAuth } from '../middlewares/auth';
import { rateLimiter } from '../middlewares/rateLimiter';

const router = Router();

router.post('/tutor', requireAuth, rateLimiter, tutorChat);

export default router;
