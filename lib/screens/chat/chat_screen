import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_book_selling_platform/model/message.dart';
import 'package:secondhand_book_selling_platform/services/chat_service.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;

  const ChatScreen({
    Key? key,
    required this.chatRoomId,
    required this.receiverId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
enum UserRole {
  Buyer,
  Seller,
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  UserService _userService = UserService();
  ChatService _chatService = ChatService();
  UserModel? _receiverUserData;
  UserModel? _currentUserData;
  String _username = '';
  String _imageUrl = '';
  File? _imageFile;
  UserRole _currentUserRole = UserRole.Buyer;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    fetchReceiverUserData();
     determineUserRole(); 
     fetchSenderUserData();
    
  }
  void determineUserRole() {
    // Implement logic to determine user role based on your app's requirements
    // For example, check current user data or other conditions
    // This logic will set _currentUserRole accordingly
    // For now, let's set it to Seller if the current user ID matches the receiver ID
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId == widget.receiverId) {
      _currentUserRole = UserRole.Seller;
    } else {
      _currentUserRole = UserRole.Buyer;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  void fetchUserData() async {
    if (_currentUserRole == UserRole.Buyer) {
      fetchReceiverUserData();
    } else if (_currentUserRole == UserRole.Seller) {
      fetchSenderUserData();
    }
  }

  void fetchReceiverUserData() async {
    try {
      _receiverUserData = await _userService.getUser(widget.receiverId);
      if (_receiverUserData == null) {
        print('Receiver user data not found');
      } else {
        setState(() {
          _username = _receiverUserData!.username;
          _imageUrl = _receiverUserData!.image;
        });
      }
    } catch (e) {
      print('Error fetching receiver user data: $e');
    }
  }

  void fetchSenderUserData() async {
    try {
      String senderId = await _chatService.getSenderIdFromChatRoom(widget.chatRoomId);
      _currentUserData = await _userService.getUser(senderId);
      if (_currentUserData == null) {
        print('Sender user data not found');
      } else {
        setState(() {
          _username = _currentUserData!.username;
          _imageUrl = _currentUserData!.image;
        });
      }
    } catch (e) {
      print('Error fetching sender user data: $e');
    }
  }
 

  void _sendMessage() async {
  final messageText = _messageController.text.trim();
  if (messageText.isNotEmpty) {
    try {
      final Timestamp timestamp = Timestamp.now();
      final String messageId = FirebaseFirestore.instance.collection('chatRooms').doc().collection('messages').doc().id;
      
      // Get the current user's ID (sender ID)
      String senderId = FirebaseAuth.instance.currentUser!.uid;

      // Check if the chat room document exists
      DocumentReference chatRoomDocRef = FirebaseFirestore.instance.collection('chatRooms').doc(widget.chatRoomId);
      bool chatRoomExists = (await chatRoomDocRef.get()).exists;

      if (!chatRoomExists) {
        // Create the chat room document if it doesn't exist
        await chatRoomDocRef.set({
          'users': [senderId, widget.receiverId],
          'lastMessageTimestamp': timestamp,
          'lastMessage': messageText,
          'senderId': senderId,
        });
      } else {
        // Update existing chat room document
        await chatRoomDocRef.update({
          'lastMessageTimestamp': timestamp,
          'lastMessage': messageText,
          'senderId': senderId,
        });
      }

      // Add message to chat room messages subcollection
      DocumentReference messageDocRef = FirebaseFirestore.instance.collection('chatRooms').doc(widget.chatRoomId).collection('messages').doc(messageId);
      ChatMessage chatMessage = ChatMessage(
        id: messageId,
        senderId: senderId,
        receiverId: widget.receiverId,
        message: messageText,
        timestamp: timestamp,
      );
      await messageDocRef.set(chatMessage.toMap());

      print('Message sent successfully');

      // Clear message input field
      _messageController.clear();

      // Scroll to bottom
      _scrollToBottom();

    } catch (e) {
      print('Error sending message: $e');
      // Handle error gracefully
      // Show snackbar or other UI feedback
    }
  }
}


  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void deleteMessage(String messageId) {
    try {
      ChatService().deleteMessage(widget.chatRoomId, messageId);
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  void showDeleteConfirmationDialog(ChatMessage message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Message"),
          content: Text("Are you sure you want to delete this message?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                deleteMessage(message.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: FutureBuilder<UserModel?>(
    future: _currentUserRole == UserRole.Buyer ? _userService.getUser(widget.receiverId) : _userService.getUser(FirebaseAuth.instance.currentUser!.uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error fetching user data');
      } else if (snapshot.hasData) {
        String username = snapshot.data?.username ?? 'User';
        String imageUrl = snapshot.data?.image ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0), // Adjust padding as needed
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : _imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : AssetImage('assets/images/profileicon.jpg') as ImageProvider,
                  ),
                  SizedBox(width: 12), // Adjust spacing between CircleAvatar and Text
                  Expanded(
                    child: Text(
                      username,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return Text('User data not found');
      }
    },
  ),
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(30.0+1.0), 
    child: Column(
              children: [
                Divider(
                  height: 1,
                  color: const Color.fromARGB(
                      255, 212, 210, 210), 
                ),
                SizedBox(height:20.0), // Adjust the height of the space below the Divider
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: ChatService().getMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSentByUser = message.senderId == FirebaseAuth.instance.currentUser!.uid;

                    return GestureDetector(
                      onTap: () {
                        if (isSentByUser) {
                          showDeleteConfirmationDialog(message);
                        }
                      },
                      child: Align(
                        alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: isSentByUser ? Color(0xffc6d8f7) : Color(0xffe8f3f1),
                              borderRadius: BorderRadius.only(
                                topLeft: isSentByUser ? Radius.circular(16.0) : Radius.circular(0.0),
                                topRight: isSentByUser ? Radius.circular(0.0) : Radius.circular(16.0),
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0),
                              ),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.message,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  DateFormat.jm().format(message.timestamp.toDate().add(Duration(hours: 8))),
                                  style: TextStyle(fontSize: 10, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
           padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.black),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
