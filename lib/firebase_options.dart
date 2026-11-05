import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAufBykOIaLSH9fye6vwszc6vN1Wdtm_l8',
    appId: '1:517797338654:android:ff1eff04e01b7caa3ad80f',
    messagingSenderId: '517797338654',
    projectId: 'code-room-chat-4821',
    storageBucket: 'code-room-chat-4821.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6t5FP5zVY2DfhEgK2-KQLMYeo-Db0ueQ',
    appId: '1:517797338654:ios:d6e9cb2dff98a3c73ad80f',
    messagingSenderId: '517797338654',
    projectId: 'code-room-chat-4821',
    storageBucket: 'code-room-chat-4821.firebasestorage.app',
    iosBundleId: 'com.coderoom.chat',
  );
}
