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
    apiKey: 'AIzaSyDV3oFJKNA2wZoEODDWRL_BJ2vF7ALdChE',
    appId: '1:139791381142:web:3bdae3edc8f70f285d88b7',
    messagingSenderId: '139791381142',
    projectId: 'myinfopromo-8c7fd',
    authDomain: 'myinfopromo-8c7fd.firebaseapp.com',
    storageBucket: 'myinfopromo-8c7fd.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_22ydwHuxqaqHRSLNMGPw9vrVFVj-MP8',
    appId: '1:139791381142:android:4442f2a93f88772d5d88b7',
    messagingSenderId: '139791381142',
    projectId: 'myinfopromo-8c7fd',
    storageBucket: 'myinfopromo-8c7fd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqXByk_cAoMGHIaFoGoMhhpOjGumdMjSI',
    appId: '1:139791381142:ios:262b46be3c71048f5d88b7',
    messagingSenderId: '139791381142',
    projectId: 'myinfopromo-8c7fd',
    storageBucket: 'myinfopromo-8c7fd.appspot.com',
    androidClientId: '139791381142-5tdr7qbbp8depkki140nu5hsvediufni.apps.googleusercontent.com',
    iosClientId: '139791381142-ovvbt20lb4m96sggm2lf7aqenl3oi9gu.apps.googleusercontent.com',
    iosBundleId: 'com.example.infopromoV1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDqXByk_cAoMGHIaFoGoMhhpOjGumdMjSI',
    appId: '1:139791381142:ios:262b46be3c71048f5d88b7',
    messagingSenderId: '139791381142',
    projectId: 'myinfopromo-8c7fd',
    storageBucket: 'myinfopromo-8c7fd.appspot.com',
    androidClientId: '139791381142-5tdr7qbbp8depkki140nu5hsvediufni.apps.googleusercontent.com',
    iosClientId: '139791381142-ovvbt20lb4m96sggm2lf7aqenl3oi9gu.apps.googleusercontent.com',
    iosBundleId: 'com.example.infopromoV1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDV3oFJKNA2wZoEODDWRL_BJ2vF7ALdChE',
    appId: '1:139791381142:web:72fc69dfea3c57fb5d88b7',
    messagingSenderId: '139791381142',
    projectId: 'myinfopromo-8c7fd',
    authDomain: 'myinfopromo-8c7fd.firebaseapp.com',
    storageBucket: 'myinfopromo-8c7fd.appspot.com',
  );
}
