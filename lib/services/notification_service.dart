import 'dart:convert';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../views/cart_view.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'keranjang';

  Future<void> init() async {
    await _fcm.requestPermission(alert: true, sound: true);

    await _registerFCMToken();
    _listenTokenRefresh();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);

    await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: _onLocalTap,
    );

    FirebaseMessaging.onMessage.listen(_onForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    final initial = await _fcm.getInitialMessage();
    if (initial != null) {
      _handleMessage(initial);
    }
  }

  void _onForeground(RemoteMessage message) {
    print('FOREGROUND PAYLOAD DATA: ${message.data}');

    _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? 'Notifikasi',
      message.notification?.body ?? 'Ada notifikasi baru',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Notifikasi Keranjang',
          channelDescription: 'Notifikasi tentang keranjang',
          importance: Importance.max,
          priority: Priority.high,
          sound: const RawResourceAndroidNotificationSound('custom_sound'),
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  Future<void> showLocalNotification({
    required String channel,
    String? title,
    String? body,
  }) async {
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title ?? 'Notifikasi',
      body ?? 'Ada notifikasi baru',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Notifikasi Keranjang',
          channelDescription: 'Notifikasi tentang keranjang',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('custom_sound'),
        ),
      ),
      payload: jsonEncode({
        'channel': channel,
      }),
    );
  }

  void _onLocalTap(NotificationResponse response) {
    if (response.payload == null) return;

    final data = jsonDecode(response.payload!);
    _handleChannel(data);
  }

  void _handleMessage(RemoteMessage message) {
    print('TAP PAYLOAD DATA: ${message.data}');
    _handleChannel(message.data);
  }

  void _handleChannel(Map<String, dynamic> data) {
    final channel = data['channel'];

    if (channel == 'keranjang') {
      _openCart();
    } else {
      print('Channel tidak dikenali: $channel');
    }
  }

  void _openCart() {
    Get.to(() => const CartView());
  }

  Future<void> _registerFCMToken() async {
    final token = await _fcm.getToken();
    if (token != null) {
      print('FCM TOKEN: $token');
    }
  }

  void _listenTokenRefresh() {
    _fcm.onTokenRefresh.listen((token) {
      print('FCM TOKEN UPDATED: $token');
    });
  }
}
