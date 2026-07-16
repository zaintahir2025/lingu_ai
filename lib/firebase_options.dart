import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'mock-api-key-for-web',
    appId: '1:1234567890:web:mock-app-id',
    messagingSenderId: '1234567890',
    projectId: 'lingu-ai-mock',
    authDomain: 'lingu-ai-mock.firebaseapp.com',
    storageBucket: 'lingu-ai-mock.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'mock-api-key-for-android',
    appId: '1:1234567890:android:mock-app-id',
    messagingSenderId: '1234567890',
    projectId: 'lingu-ai-mock',
    storageBucket: 'lingu-ai-mock.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'mock-api-key-for-ios',
    appId: '1:1234567890:ios:mock-app-id',
    messagingSenderId: '1234567890',
    projectId: 'lingu-ai-mock',
    storageBucket: 'lingu-ai-mock.appspot.com',
    iosBundleId: 'com.example.linguai',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'mock-api-key-for-macos',
    appId: '1:1234567890:ios:mock-app-id',
    messagingSenderId: '1234567890',
    projectId: 'lingu-ai-mock',
    storageBucket: 'lingu-ai-mock.appspot.com',
    iosBundleId: 'com.example.linguai',
  );
}
