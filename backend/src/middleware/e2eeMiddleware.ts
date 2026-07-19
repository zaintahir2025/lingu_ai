import { Request, Response, NextFunction } from 'express';
import crypto from 'crypto';

const SHARED_KEY = process.env.E2EE_KEY || 'LinguAI-SuperSecretKey-32Bytes!!';
const IV = 'LinguAI_IV_16byt';

export const e2eeMiddleware = (req: Request, res: Response, next: NextFunction) => {
  // Decrypt incoming payload
  if (['POST', 'PUT', 'PATCH'].includes(req.method)) {
    if (req.body && req.body.encryptedPayload) {
      try {
        const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(SHARED_KEY), Buffer.from(IV));
        let decrypted = decipher.update(req.body.encryptedPayload, 'base64', 'utf8');
        decrypted += decipher.final('utf8');
        req.body = JSON.parse(decrypted);
      } catch (err) {
        console.error('E2EE Decryption Error:', err);
        res.status(400).json({ error: 'Failed to decrypt payload' });
        return;
      }
    }
  }

  // Intercept res.json to encrypt outgoing payload
  const originalJson = res.json;
  res.json = function (body: any) {
    // Only encrypt success/error objects if they are raw JSON
    if (body && typeof body === 'object' && !body.encryptedPayload) {
      try {
        const cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(SHARED_KEY), Buffer.from(IV));
        let encrypted = cipher.update(JSON.stringify(body), 'utf8', 'base64');
        encrypted += cipher.final('base64');
        
        return originalJson.call(this, { encryptedPayload: encrypted });
      } catch (err) {
        console.error('E2EE Encryption Error:', err);
        return originalJson.call(this, { error: 'Failed to encrypt response payload' });
      }
    }
    return originalJson.call(this, body);
  };

  next();
};
