import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // _initializeFirebaseMessaging();
  }

  // void _initializeFirebaseMessaging() async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Received a message while in the foreground!');
  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //       _showForegroundNotification(context, message);
  //     }
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessageOpenedApp event was published!');
  //     // Handle the message when the app is opened from a notification
  //   });

  //   RemoteMessage? initialMessage =
  //       await _firebaseMessaging.getInitialMessage();
  //   if (initialMessage != null) {
  //     print(
  //         'App opened from a terminated state by a notification: ${initialMessage.messageId}');
  //     // Handle the initial message here
  //   }
  // }

  // void _showForegroundNotification(
  //     BuildContext context, RemoteMessage message) {
  //   showDialog(
  //     context: context!,
  //     builder: (context) => AlertDialog(
  //       title: Text(message.notification?.title ?? 'No Title'),
  //       content: Text(message.notification?.body ?? 'No Body'),
  //       actions: [
  //         TextButton(
  //           child: const Text('OK'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String formatTimestamp(Timestamp timestamp) {
    var format =
        DateFormat('yyyy-MM-dd HH:mm'); // 'yyyy-MM-dd HH:mm' for date and time
    return format.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 214, 214, 214),
            height: 1.0,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: UserService().getUserId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Notification', style: TextStyle(fontSize: 16.0)),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Container(
                margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey[200],
                ),
                child: ListTile(
                  leading: const Icon(Icons.notifications_active_rounded,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  title: Text(
                    notification['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['body'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          notification['timestamp'] != null
                              ? formatTimestamp(
                                  notification['timestamp'] as Timestamp)
                              : 'Pending',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
