import 'package:flutter/material.dart';

class  NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text('Messages'),
      ),
      body: const Center(
        child: Text(
          'Message Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
