// lib/services/notification_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

// Import the submit screen so we can navigate with full args on tap
import '../screens/submit_crowd_level_screen.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // 🔔 Request Notification Permission (Android 13+)
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidInit);

    // Newer versions: handle taps with onDidReceiveNotificationResponse
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // payload is JSON string
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> payload = jsonDecode(response.payload!);
            // Navigate to SubmitCrowdLevelScreen with the hospital data
            Get.to(() => SubmitCrowdLevelScreen(
                  name: payload['name'] ?? 'Hospital',
                  website: payload['website'] ?? '',
                  address: payload['address'] ?? '',
                  hours: payload['hours'] ?? '',
                  latitude: (payload['latitude'] is num)
                      ? (payload['latitude'] as num).toDouble()
                      : double.tryParse(payload['latitude'].toString()) ?? 0.0,
                  longitude: (payload['longitude'] is num)
                      ? (payload['longitude'] as num).toDouble()
                      : double.tryParse(payload['longitude'].toString()) ?? 0.0,
                ));
          } catch (e) {
            // ignore parse errors
          }
        }
      },
    );
  }

  static Future<void> showNotificationWithPayload(
      {required String title,
      required String body,
      required Map<String, dynamic> payload}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "hospital_channel", // Channel ID
      "Nearby Hospitals", // Channel Name
      channelDescription: "Alerts when you enter a hospital zone",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // Unique ID for each notification
    int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final String encodedPayload = jsonEncode(payload);

    await _plugin.show(
      id,
      title,
      body,
      details,
      payload: encodedPayload,
    );
  }

  // Backwards-compatible simple method if you prefer no payload:
  static Future<void> showNotification(String title, String body) async {
    await showNotificationWithPayload(
      title: title,
      body: body,
      payload: {"title": title, "body": body},
    );
  }
}
