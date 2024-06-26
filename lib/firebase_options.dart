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
    apiKey: 'AIzaSyAW5fX1NiyUaPLRhi1fLH3Ppvm2hQ7XqCs',
    appId: '1:268732997047:web:3cfb62fbd0222b4f20dc32',
    messagingSenderId: '268732997047',
    projectId: 'smartsoftbase',
    authDomain: 'smartsoftbase.firebaseapp.com',
    storageBucket: 'smartsoftbase.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbHKemBmWI_fkcdYIsxCzzlBXD3pltI10',
    appId: '1:268732997047:android:83b86d8b59de9a9020dc32',
    messagingSenderId: '268732997047',
    projectId: 'smartsoftbase',
    storageBucket: 'smartsoftbase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDolXThf7FbhgUMCZrpe1hjyACG7qAUegs',
    appId: '1:268732997047:ios:08ab126568d4be9320dc32',
    messagingSenderId: '268732997047',
    projectId: 'smartsoftbase',
    storageBucket: 'smartsoftbase.appspot.com',
    iosClientId: '268732997047-tmekhqhrss9vkvsu7jm97mi6g44cjn7n.apps.googleusercontent.com',
    iosBundleId: 'com.example.smartsoftApplication',
  );
}
