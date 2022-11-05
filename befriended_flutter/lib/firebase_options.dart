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
    apiKey: 'AIzaSyC2wO7BpsUAqB0ahlQi3v-Jnxcz4caL0es',
    appId: '1:356654918297:web:540ad8dbfe2005db3ba608',
    messagingSenderId: '356654918297',
    projectId: 'befriended-97276',
    authDomain: 'befriended-97276.firebaseapp.com',
    databaseURL: 'https://befriended-97276-default-rtdb.firebaseio.com',
    storageBucket: 'befriended-97276.appspot.com',
    measurementId: 'G-95G04GM03L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCxHciZ2RTuK3UsmZvhwtkFHaNfM9RJAo',
    appId: '1:356654918297:android:3391ab77c94ff7b53ba608',
    messagingSenderId: '356654918297',
    projectId: 'befriended-97276',
    databaseURL: 'https://befriended-97276-default-rtdb.firebaseio.com',
    storageBucket: 'befriended-97276.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBya_KluV9yU7eytLbZjgG-VB-grLQWT8I',
    appId: '1:356654918297:ios:a713cd5fef0503913ba608',
    messagingSenderId: '356654918297',
    projectId: 'befriended-97276',
    databaseURL: 'https://befriended-97276-default-rtdb.firebaseio.com',
    storageBucket: 'befriended-97276.appspot.com',
    androidClientId: '356654918297-3psg7kujlt5qjvg0s0r68s5j81om21qs.apps.googleusercontent.com',
    iosClientId: '356654918297-ce66ho7itnufcsv2sk3hmn6dkglc1g7i.apps.googleusercontent.com',
    iosBundleId: 'com.befriended.org.befriended-flutter',
  );
}
