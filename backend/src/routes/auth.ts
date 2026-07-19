import { Router } from 'express';
import { register, login, logout, refreshToken, deleteAccount, forgotPassword, resetPassword, verifyEmail } from '../controllers/authController';
import { rateLimiter } from '../middlewares/rateLimiter';
import { requireAuth as verifyToken } from '../middlewares/auth';

const router = Router();

router.post('/register', rateLimiter, register);
router.post('/login', rateLimiter, login);
router.post('/logout', logout);
router.post('/refresh-token', refreshToken);
router.delete('/me', verifyToken, deleteAccount);
router.get('/verify-email', verifyEmail);

router.post('/forgot-password', rateLimiter, forgotPassword);
router.post('/reset-password', rateLimiter, resetPassword);

export default router;
