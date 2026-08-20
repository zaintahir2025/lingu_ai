String? registrationConfigurationMessage({required bool backendConfigured}) {
  if (!backendConfigured) {
    return 'Registration is unavailable because the backend is not configured.';
  }
  return null;
}
