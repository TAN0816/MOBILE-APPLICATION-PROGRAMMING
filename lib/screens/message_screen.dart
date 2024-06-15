import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {


  // Constructor with required parameter
  const MessageScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("dd"),
      ),
      body: Center(
        child: Text('This is the message screen for'),
      ),
    );
  }
}