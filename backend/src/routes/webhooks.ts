import { Router } from 'express';
import { PrismaClient } from '@prisma/client';

const router = Router();
const prisma = new PrismaClient();

// Google Play Store Webhook
router.post('/google', async (req, res) => {
  try {
    // In production, verify Google Cloud Pub/Sub message signature
    const message = req.body.message;
    if (!message || !message.data) {
      return res.status(400).send('Invalid payload');
    }

    const decodedData = Buffer.from(message.data, 'base64').toString('utf8');
    const data = JSON.parse(decodedData);

    const subscriptionNotification = data.subscriptionNotification;
    if (subscriptionNotification) {
      const purchaseToken = subscriptionNotification.purchaseToken;
      const subscriptionId = subscriptionNotification.subscriptionId;

      // Update the user's subscription status in DB
      // Note: In real app, you need to call Google Play Developer API to map purchaseToken to userId
      console.log('Google Play Sub:', subscriptionId, purchaseToken);
    }

    res.status(200).send('OK');
  } catch (error) {
    console.error('Google Webhook Error:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Apple App Store Webhook
router.post('/apple', async (req, res) => {
  try {
    // In production, verify Apple's JWT signature
    const payload = req.body;
    
    // Apple sends notificationType like INITIAL_BUY, DID_RENEW, CANCEL
    console.log('Apple Sub Notification:', payload.notificationType);

    res.status(200).send('OK');
  } catch (error) {
    console.error('Apple Webhook Error:', error);
    res.status(500).send('Internal Server Error');
  }
});

export const webhookRoutes = router;
