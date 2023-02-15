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
    apiKey: 'AIzaSyCab83PR5PF-cnQLsS9Bi3017sSbRqPwh4',
    appId: '1:1077892951218:web:cfdafff1dd6fd7e5472dab',
    messagingSenderId: '1077892951218',
    projectId: 'streamcom-13d68',
    authDomain: 'streamcom-13d68.firebaseapp.com',
    storageBucket: 'streamcom-13d68.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3vPOnHurPo0oSoNYbbgNQq5Tvb7Tcboc',
    appId: '1:1077892951218:android:603e7a60750227c8472dab',
    messagingSenderId: '1077892951218',
    projectId: 'streamcom-13d68',
    storageBucket: 'streamcom-13d68.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuW88mCm6UyW0-PG7nawJ2YTRvZxcAP3g',
    appId: '1:1077892951218:ios:bb6f448350a9838d472dab',
    messagingSenderId: '1077892951218',
    projectId: 'streamcom-13d68',
    storageBucket: 'streamcom-13d68.appspot.com',
    iosClientId: '1077892951218-o8gkhcc4c7sa9e050f5glr77ejh2laos.apps.googleusercontent.com',
    iosBundleId: 'com.example.streamcom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBuW88mCm6UyW0-PG7nawJ2YTRvZxcAP3g',
    appId: '1:1077892951218:ios:bb6f448350a9838d472dab',
    messagingSenderId: '1077892951218',
    projectId: 'streamcom-13d68',
    storageBucket: 'streamcom-13d68.appspot.com',
    iosClientId: '1077892951218-o8gkhcc4c7sa9e050f5glr77ejh2laos.apps.googleusercontent.com',
    iosBundleId: 'com.example.streamcom',
  );
}