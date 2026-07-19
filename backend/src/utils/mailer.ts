import nodemailer from 'nodemailer';

// Ethereal is a fake SMTP service, perfect for development and testing.
export const createTestMailer = async () => {
  // Generate test SMTP service account from ethereal.email
  let testAccount = await nodemailer.createTestAccount();

  // create reusable transporter object using the default SMTP transport
  let transporter = nodemailer.createTransport({
    host: "smtp.ethereal.email",
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
      user: testAccount.user, // generated ethereal user
      pass: testAccount.pass, // generated ethereal password
    },
  });

  return transporter;
};

export const sendVerificationEmail = async (email: string, token: string) => {
  try {
    const transporter = await createTestMailer();
    
    // In a real app, this would point to a frontend route (e.g. https://linguai.com/verify?token=XYZ)
    // For now, we point it to the backend endpoint for direct verification.
    const verifyUrl = `http://localhost:3000/api/auth/verify-email?token=${token}`;

    const info = await transporter.sendMail({
      from: '"LinguAI Team" <noreply@linguai.com>', 
      to: email, 
      subject: "Verify your LinguAI Account \u2728", 
      text: `Welcome to LinguAI! Please verify your email by clicking the following link: ${verifyUrl}`, 
      html: `
        <div style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
          <h2 style="color: #4CAF50;">Welcome to LinguAI! \uD83C\uDF89</h2>
          <p>We're excited to have you on board. To get started and unlock all features, please verify your email address.</p>
          <a href="${verifyUrl}" style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 10px;">Verify My Email</a>
          <p style="margin-top: 20px; font-size: 12px; color: #777;">If the button doesn't work, copy and paste this link into your browser: <br/>${verifyUrl}</p>
        </div>
      `, 
    });

    console.log("Message sent: %s", info.messageId);
    // Preview only available when sending through an Ethereal account
    console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));
  } catch (err) {
    console.error("Failed to send verification email: ", err);
  }
};
