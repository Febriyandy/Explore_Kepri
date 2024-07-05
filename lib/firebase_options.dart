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
    apiKey: 'AIzaSyAQ_iTdjswIcslTzaBsVVD7AEdQA5OeqOQ',
    appId: '1:896636292966:web:e5ba0d71c509df476882a7',
    messagingSenderId: '896636292966',
    projectId: 'explore-kepri-313f6',
    authDomain: 'explore-kepri-313f6.firebaseapp.com',
    storageBucket: 'explore-kepri-313f6.appspot.com',
    measurementId: 'G-PLV1QGB5Z2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfHx_vtxfAkvVw9Pe0kt-a9hKnZQ3CaJo',
    appId: '1:896636292966:android:4035ef299be8cfea6882a7',
    messagingSenderId: '896636292966',
    projectId: 'explore-kepri-313f6',
    storageBucket: 'explore-kepri-313f6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMEIS3E-pmL8d-vsvZUy0FS0TWBJN14tw',
    appId: '1:896636292966:ios:8e6adb03b6bc664e6882a7',
    messagingSenderId: '896636292966',
    projectId: 'explore-kepri-313f6',
    storageBucket: 'explore-kepri-313f6.appspot.com',
    iosBundleId: 'com.example.exploreKepri',
  );

}