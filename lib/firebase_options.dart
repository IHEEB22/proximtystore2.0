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
    apiKey: 'AIzaSyC7ZniNaZ0PRUpwOvQC0WNphlf9jOfIU8E',
    appId: '1:562314622439:web:7ef1d51e761e606e86b942',
    messagingSenderId: '562314622439',
    projectId: 'proximitystore2',
    authDomain: 'proximitystore2.firebaseapp.com',
    storageBucket: 'proximitystore2.appspot.com',
    measurementId: 'G-7Q3J6488DJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCGodlSHyxY6sE2xcGhMjOcoXTGuW5gzvE',
    appId: '1:562314622439:android:e09153b04464a5ff86b942',
    messagingSenderId: '562314622439',
    projectId: 'proximitystore2',
    storageBucket: 'proximitystore2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFUIMCUYsAWVynp6A8-kVPpMMfWG4XYUQ',
    appId: '1:562314622439:ios:ad37be22ba72963086b942',
    messagingSenderId: '562314622439',
    projectId: 'proximitystore2',
    storageBucket: 'proximitystore2.appspot.com',
    iosClientId: '562314622439-n3n1cf3sasklsif63ivlq1u3f5r0a1ps.apps.googleusercontent.com',
    iosBundleId: 'com.example.proximitystore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCFUIMCUYsAWVynp6A8-kVPpMMfWG4XYUQ',
    appId: '1:562314622439:ios:ad37be22ba72963086b942',
    messagingSenderId: '562314622439',
    projectId: 'proximitystore2',
    storageBucket: 'proximitystore2.appspot.com',
    iosClientId: '562314622439-n3n1cf3sasklsif63ivlq1u3f5r0a1ps.apps.googleusercontent.com',
    iosBundleId: 'com.example.proximitystore',
  );
}
