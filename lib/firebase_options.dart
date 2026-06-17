import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA7M5zXEC3svAI2NKMlKLBBfTvrJRWeS94',
    appId: '1:368001840237:web:0d7e215479573066f8bb64',
    messagingSenderId: '368001840237',
    projectId: 'insta-clone-68dbd',
    authDomain: 'insta-clone-68dbd.firebaseapp.com',
    storageBucket: 'insta-clone-68dbd.firebasestorage.app',
    measurementId: 'G-8JGRHD7SH1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqc1-U1Zds96HR7RHV-MwrMcI7BzuD16c',
    appId: '1:368001840237:android:7e61b2988b12f8b3f8bb64',
    messagingSenderId: '368001840237',
    projectId: 'insta-clone-68dbd',
    storageBucket: 'insta-clone-68dbd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsJkwAy9aQTW9IYjKuYbC0nE59DR0NgBA',
    appId: '1:368001840237:ios:ae871d31653c4627f8bb64',
    messagingSenderId: '368001840237',
    projectId: 'insta-clone-68dbd',
    storageBucket: 'insta-clone-68dbd.firebasestorage.app',
    iosBundleId: 'app.prod.instaclone',
  );
}
