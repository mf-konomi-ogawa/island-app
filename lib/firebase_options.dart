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
    apiKey: 'AIzaSyBu6veShb20Y9sBv3LysUBE9O0Fp7R33R4',
    appId: '1:229244289320:web:2235e6cb1bf6fe032d501d',
    messagingSenderId: '229244289320',
    projectId: 'island-develop',
    authDomain: 'island-develop.firebaseapp.com',
    databaseURL: 'https://island-develop-default-rtdb.firebaseio.com',
    storageBucket: 'island-develop.appspot.com',
    measurementId: 'G-CDQWKTGKNG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBgu_LMXSQWYUVefk5DUaGFM73yJMUzFw',
    appId: '1:229244289320:android:c2a132d7fdb6ead92d501d',
    messagingSenderId: '229244289320',
    projectId: 'island-develop',
    databaseURL: 'https://island-develop-default-rtdb.firebaseio.com',
    storageBucket: 'island-develop.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvqtFkR0dx6IOx2GQdbN8E-Tp7qEU9C8I',
    appId: '1:229244289320:ios:c516c659d88f7c812d501d',
    messagingSenderId: '229244289320',
    projectId: 'island-develop',
    databaseURL: 'https://island-develop-default-rtdb.firebaseio.com',
    storageBucket: 'island-develop.appspot.com',
    iosClientId: '229244289320-mu7c1fh7v9p2tj19o80fuh6f465cmujo.apps.googleusercontent.com',
    iosBundleId: 'com.example.apikicker',
  );
}