import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken.');

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(UserService().getUserId)
          .update({'deviceToken': fCMToken});
    } catch (e) {
      print('Error updating token: $e');
      rethrow;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Handle Firebase Messaging onMessage and onMessageOpenedApp callbacks
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showForegroundNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Handle the message when the app is opened from a notification
    });

    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print(
          'App opened from a terminated state by a notification: ${initialMessage.messageId}');
      // Handle the initial message here
    }
  }

  void _showForegroundNotification(RemoteMessage message) {
    // Show a local notification when receiving a message while the app is in the foreground
    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'SBS',
          'This channel is responsible for all the local notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      // payload: 'test notification'
    );
  }

  Future<void> onSelectNotification() async {
    // Handle when a notification is tapped
    await navigatorKey.currentState?.pushNamed('/home/1');
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await navigatorKey.currentState?.pushNamed('/home/1');
  }

  Future<void> storeDeviceToken(String userId) async {
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken.');

    if (fCMToken != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'deviceToken': fCMToken});
        print('Device token updated successfully.');
      } catch (e) {
        print('Error updating token: $e');
      }
    }
  }

  Future<void> setDeviceTokenToNull(String userId) async {
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken.');

    if (fCMToken != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'deviceToken': ""});
        print('Device token updated to null successfully.');
      } catch (e) {
        print('Error updating token: $e');
      }
    }
  }

  Future<void> saveNotification(
      String userId, String title, String body) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': userId,
    });
  }

  Future<String?> getUserDeviceToken(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['deviceToken'];
  }

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }

  Future<void> sendMessage(
      Future<String?> deviceTokenFuture, String title, String body) async {
    final deviceToken = await deviceTokenFuture;
    if (deviceToken == null) {
      print('Device token is null, unable to send message.');
      return;
    }
    final String serverKey = await getAccessToken(); // Your FCM server key
    const String fcmEndpoint =
        'https://fcm.googleapis.com/v1/projects/secondhand-book-selling-ddda4/messages:send';
    // final currentFCMToken = await FirebaseMessaging.instance.getToken();
    // print("fcmkey : $currentFCMToken");
    final Map<String, dynamic> message = {
      'message': {
        'token':
            deviceToken, // Token of the device you want to send the message to
        'notification': {'body': body, 'title': title},
        'data': {
          'current_user_fcm_token':
              deviceToken, // Include the current user's FCM token in data payload
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('FCM message sent successfully');
    } else {
      print('Failed to send FCM message: ${response.statusCode}');
    }
  }
}
