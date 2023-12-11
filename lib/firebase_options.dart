// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyA4g4Y9WqqthDoBF6ikhcUAw1XFuPdUESo',
    appId: '1:317171059661:web:369eeb5a9d3432e8b41284',
    messagingSenderId: '317171059661',
    projectId: 'carpooling-ainshams',
    authDomain: 'carpooling-ainshams.firebaseapp.com',
    storageBucket: 'carpooling-ainshams.appspot.com',
    measurementId: 'G-MEXT4QG3T9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCo64lu3bx_5Q-xblpYGnG7stGhcSKRJ4o',
    appId: '1:317171059661:android:3e88cba38ee9de05b41284',
    messagingSenderId: '317171059661',
    projectId: 'carpooling-ainshams',
    storageBucket: 'carpooling-ainshams.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_ZSTPQtKnTxHXZy4oFdTkHsNjnSVJJnc',
    appId: '1:317171059661:ios:c1bfe5b66579c78db41284',
    messagingSenderId: '317171059661',
    projectId: 'carpooling-ainshams',
    storageBucket: 'carpooling-ainshams.appspot.com',
    iosBundleId: 'com.example.projCarpooling',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_ZSTPQtKnTxHXZy4oFdTkHsNjnSVJJnc',
    appId: '1:317171059661:ios:1dba10957748804fb41284',
    messagingSenderId: '317171059661',
    projectId: 'carpooling-ainshams',
    storageBucket: 'carpooling-ainshams.appspot.com',
    iosBundleId: 'com.example.projCarpooling.RunnerTests',
  );
}