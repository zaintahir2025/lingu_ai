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
        return windows;
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
    apiKey: 'AIzaSyD6dIlZN2rRJTJ-CNHbyMg-IXsJ5N2jTVI',
    appId: '1:1064127857792:web:3a7bc52f70c48cb692d265',
    messagingSenderId: '1064127857792',
    projectId: 'linguai-app-2026',
    authDomain: 'linguai-app-2026.firebaseapp.com',
    storageBucket: 'linguai-app-2026.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtxpT1uQ0P5Qb_ujWLZBEXzpt_jpAMq74',
    appId: '1:1064127857792:android:3b83a0918b5f31f392d265',
    messagingSenderId: '1064127857792',
    projectId: 'linguai-app-2026',
    storageBucket: 'linguai-app-2026.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD8WTrPSCRYfnxENG6N_VXrCsFCKE8rUwo',
    appId: '1:1064127857792:ios:6747ae0bb62424c192d265',
    messagingSenderId: '1064127857792',
    projectId: 'linguai-app-2026',
    storageBucket: 'linguai-app-2026.firebasestorage.app',
    iosBundleId: 'com.example.linguAi',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD8WTrPSCRYfnxENG6N_VXrCsFCKE8rUwo',
    appId: '1:1064127857792:ios:6747ae0bb62424c192d265',
    messagingSenderId: '1064127857792',
    projectId: 'linguai-app-2026',
    storageBucket: 'linguai-app-2026.firebasestorage.app',
    iosBundleId: 'com.example.linguAi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD6dIlZN2rRJTJ-CNHbyMg-IXsJ5N2jTVI',
    appId: '1:1064127857792:web:102691e74a9b490a92d265',
    messagingSenderId: '1064127857792',
    projectId: 'linguai-app-2026',
    authDomain: 'linguai-app-2026.firebaseapp.com',
    storageBucket: 'linguai-app-2026.firebasestorage.app',
  );
}
