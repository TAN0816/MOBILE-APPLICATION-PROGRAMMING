import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Center(
        child: Text(
          'Message Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
