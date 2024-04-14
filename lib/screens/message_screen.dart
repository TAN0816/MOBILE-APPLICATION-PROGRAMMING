import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('Messages'),
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
