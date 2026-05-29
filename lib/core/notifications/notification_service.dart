import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Background isolate Firebase init failure — no notifications
  }
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _messaging.getToken();
    }

    _initialized = true;
  }

  static void handleForegroundMessage(
    BuildContext context,
    WidgetRef ref,
    RemoteMessage message,
  ) {
    if (!context.mounted) return;

    final data = message.data;
    final movieId = data['movie_id'];

    if (movieId != null) {
      final id = int.tryParse(movieId);
      if (id != null) {
        context.push('/movie/$id');
        return;
      }
    }

    final notification = message.notification;
    if (notification != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notification.body ?? notification.title ?? ''),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  static Future<void> handleNotificationOpenedApp(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message == null) return;

    final data = message.data;
    final movieId = data['movie_id'];
    if (movieId != null) {
      final id = int.tryParse(movieId);
      if (id != null) {
        context.push('/movie/$id');
      }
    }
  }
}
