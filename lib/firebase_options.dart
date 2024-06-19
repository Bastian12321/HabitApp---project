// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCAPiKV0vDy1A_ikLbFN8YAAaKh3qdmqas',
    appId: '1:354860494305:web:1e436bce3c6181002fb6a0',
    messagingSenderId: '354860494305',
    projectId: 'habitapp2-c71a2',
    authDomain: 'habitapp2-c71a2.firebaseapp.com',
    storageBucket: 'habitapp2-c71a2.appspot.com',
    measurementId: 'G-JX9CGE6T7C',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxgNuMGAQKzUoUNh8MjZFC0E4QH46066E',
    appId: '1:354860494305:ios:d0ccc7453599259f2fb6a0',
    messagingSenderId: '354860494305',
    projectId: 'habitapp2-c71a2',
    storageBucket: 'habitapp2-c71a2.appspot.com',
    iosBundleId: 'com.example.habitapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxgNuMGAQKzUoUNh8MjZFC0E4QH46066E',
    appId: '1:354860494305:ios:d0ccc7453599259f2fb6a0',
    messagingSenderId: '354860494305',
    projectId: 'habitapp2-c71a2',
    storageBucket: 'habitapp2-c71a2.appspot.com',
    iosBundleId: 'com.example.habitapp',
  );
}
