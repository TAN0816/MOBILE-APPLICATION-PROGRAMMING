import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

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
