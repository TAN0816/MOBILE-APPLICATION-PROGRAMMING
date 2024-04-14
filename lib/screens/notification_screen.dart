import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text(
          'Notification Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
