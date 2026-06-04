import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbqdshQTCfsI_RqYsDU4jy3byBFakNX3k',
    appId: '1:954555401149:android:011c31e9dcdb9d3a4288d4',
    messagingSenderId: '954555401149',
    projectId: 'ai-story-video-creator-f7a2f',
    storageBucket: 'ai-story-video-creator-f7a2f.firebasestorage.app',
  );
}
