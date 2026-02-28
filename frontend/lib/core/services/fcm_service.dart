import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static bool _initialized = false;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for order updates and important notifications',
    importance: Importance.max,
  );

  /// Initialize FCM — safe to call, wraps everything in try-catch.
  static Future<void> initialize({
    required Future<void> Function(String token) onTokenReceived,
    void Function(RemoteMessage message)? onMessageOpenedApp,
  }) async {
    if (_initialized) return;

    try {
      final messaging = FirebaseMessaging.instance;

      // Request permission
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        log('FCM: User denied notification permission');
        return;
      }

      // Set up local notifications for foreground display
      await _setupLocalNotifications();

      // Get and register FCM token
      final token = await messaging.getToken();
      if (token != null) {
        await onTokenReceived(token);
      }

      // Listen for token refresh
      messaging.onTokenRefresh.listen(onTokenReceived);

      // Foreground messages — show a local notification
      FirebaseMessaging.onMessage.listen(_showLocalNotification);

      // Notification tapped while app was in background
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        onMessageOpenedApp?.call(message);
      });

      // App launched from terminated state via notification
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        onMessageOpenedApp?.call(initialMessage);
      }

      _initialized = true;
      log('FCM: initialized successfully');
    } catch (e) {
      log('FCM: initialization skipped ($e)');
    }
  }

  static Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// Delete FCM token (call on logout)
  static Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
  }
}
