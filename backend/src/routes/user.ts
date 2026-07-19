import { Router } from 'express';
import { updateProfile, submitSurvey } from '../controllers/userController';
import { requireAuth } from '../middlewares/auth';
import { rateLimiter } from '../middlewares/rateLimiter';

const router = Router();

router.put('/profile', requireAuth, rateLimiter, updateProfile);
router.post('/survey', requireAuth, rateLimiter, submitSurvey);

export default router;
