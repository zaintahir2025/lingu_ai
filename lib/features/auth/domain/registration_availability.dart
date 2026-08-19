String? registrationConfigurationMessage({
  required bool backendConfigured,
  required bool captchaConfigured,
}) {
  if (!backendConfigured && !captchaConfigured) {
    return 'Registration needs a connected backend and CAPTCHA configuration.';
  }
  if (!backendConfigured) {
    return 'Registration is unavailable because the backend is not configured.';
  }
  if (!captchaConfigured) {
    return 'Registration is unavailable because CAPTCHA is not configured.';
  }
  return null;
}
