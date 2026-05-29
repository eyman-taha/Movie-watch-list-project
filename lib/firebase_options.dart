import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    return android;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC8QTF7t3pve7zBgs_t5cXMswsF9h9bmbU',
    authDomain: 'movie-watch-list-d2665.firebaseapp.com',
    projectId: 'movie-watch-list-d2665',
    storageBucket: 'movie-watch-list-d2665.firebasestorage.app',
    messagingSenderId: '7372161177',
    appId: '1:7372161177:web:d76be5c0722c4467f7f808',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8QTF7t3pve7zBgs_t5cXMswsF9h9bmbU',
    authDomain: 'movie-watch-list-d2665.firebaseapp.com',
    projectId: 'movie-watch-list-d2665',
    storageBucket: 'movie-watch-list-d2665.firebasestorage.app',
    messagingSenderId: '7372161177',
    appId: '1:7372161177:android:d76be5c0722c4467f7f808',
  );
}
