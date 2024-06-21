import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondhand_book_selling_platform/model/message.dart'; // Assuming you have a ChatMessage model

class ChatRoom {
   String id;
  final List<String> users;
  Timestamp lastMessageTimestamp;
  // List<ChatMessage> messages; // Assuming you have a ChatMessage model

  ChatRoom({
    required this.id,
    required this.users,
    required this.lastMessageTimestamp,
    // required this.messages,
  });

  // Factory method to convert Firestore Document to ChatRoom object
  factory ChatRoom.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> messagesData = data['messages'] ?? []; // Handle case where messages might be null
    List<ChatMessage> messages = messagesData.map((messageData) => ChatMessage.fromDocumentSnapshot(messageData)).toList();
    
    return ChatRoom(
      id: doc.id,
      users: List<String>.from(data['users']),
      lastMessageTimestamp: data['lastMessageTimestamp'],
      // messages: messages,
    );
  }

  // Method to convert ChatRoom object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'users': users,
      'lastMessageTimestamp': lastMessageTimestamp,
      // 'messages': messages.map((message) => message.toMap()).toList(),
    };
  }
}
