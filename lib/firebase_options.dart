// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'replace-with-web-api-key',
    appId: '1:000000000000:web:taskflowvaibhav',
    messagingSenderId: '000000000000',
    projectId: 'taskflow-vaibhav',
    authDomain: 'taskflow-vaibhav.firebaseapp.com',
    storageBucket: 'taskflow-vaibhav.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkgGlYvQxgoU1D0XisZVTrj__hn2m9SpM',
    appId: '1:614436705322:android:cacce1fdcb607a217cdf53',
    messagingSenderId: '614436705322',
    projectId: 'flutter-todo-lit-app',
    storageBucket: 'flutter-todo-lit-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'replace-with-ios-api-key',
    appId: '1:000000000000:ios:taskflowvaibhav',
    messagingSenderId: '000000000000',
    projectId: 'taskflow-vaibhav',
    storageBucket: 'taskflow-vaibhav.appspot.com',
    iosBundleId: 'com.vaibhav.taskflow',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'replace-with-macos-api-key',
    appId: '1:000000000000:ios:taskflowvaibhavmacos',
    messagingSenderId: '000000000000',
    projectId: 'taskflow-vaibhav',
    storageBucket: 'taskflow-vaibhav.appspot.com',
    iosBundleId: 'com.vaibhav.taskflow.macos',
  );
}
