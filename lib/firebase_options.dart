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
    apiKey: 'AIzaSyCc5gJL6GqNzOnRuRGkcerKH5WUiSHSDNQ',
    appId: '1:304786707067:web:5fa4c6563a8449956388de',
    messagingSenderId: '304786707067',
    projectId: 'golfapp-2a426',
    authDomain: 'golfapp-2a426.firebaseapp.com',
    storageBucket: 'golfapp-2a426.firebasestorage.app',
    measurementId: 'G-VLY63R03VL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBrgXkifLqZ8VYaV03qfh5Wgulk4KpF-A',
    appId: '1:304786707067:android:fce697ac532bdf3e6388de',
    messagingSenderId: '304786707067',
    projectId: 'golfapp-2a426',
    storageBucket: 'golfapp-2a426.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_JjvzkDTFYXR4qpmvt7qMG51xb0wDDBc',
    appId: '1:304786707067:ios:86fe0380f0cbf9036388de',
    messagingSenderId: '304786707067',
    projectId: 'golfapp-2a426',
    storageBucket: 'golfapp-2a426.firebasestorage.app',
    iosBundleId: 'com.example.golfApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_JjvzkDTFYXR4qpmvt7qMG51xb0wDDBc',
    appId: '1:304786707067:ios:86fe0380f0cbf9036388de',
    messagingSenderId: '304786707067',
    projectId: 'golfapp-2a426',
    storageBucket: 'golfapp-2a426.firebasestorage.app',
    iosBundleId: 'com.example.golfApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCc5gJL6GqNzOnRuRGkcerKH5WUiSHSDNQ',
    appId: '1:304786707067:web:5fa4c6563a8449956388de',
    messagingSenderId: '304786707067',
    projectId: 'golfapp-2a426',
    authDomain: 'golfapp-2a426.firebaseapp.com',
    storageBucket: 'golfapp-2a426.firebasestorage.app',
    measurementId: 'G-VLY63R03VL',
  );
}
