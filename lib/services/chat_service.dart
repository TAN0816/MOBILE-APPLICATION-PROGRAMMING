import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondhand_book_selling_platform/model/chatroom.dart'; // Import your ChatRoom model
import 'package:secondhand_book_selling_platform/model/message.dart'; // Import your ChatMessage model

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
  Future<ChatRoom?> getChatRoomById(String chatRoomId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          
          .get();

      if (!docSnapshot.exists) {
        return null; // Chat room with given ID doesn't exist
      }

      var data = docSnapshot.data();
      return ChatRoom(
        id: chatRoomId,
        users: List<String>.from(data?['users'] ?? []),
        lastMessageTimestamp: data?['lastMessageTimestamp'] ?? Timestamp.now(),
        // Add other fields as necessary
      );
    } catch (e) {
      print('Error fetching chat room: $e');
      return null; // Handle error gracefully
    }
  }
  
  Future<void> sendMessage(String chatRoomId, String senderId, String receiverId, String message) async {
  try {
    final Timestamp timestamp = Timestamp.now();

    // Create new message object
    final ChatMessage chatMessage = ChatMessage(
      id: _firestore.collection('chatRooms').doc(chatRoomId).collection('messages').doc().id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // Firestore batch to perform multiple operations atomically
    WriteBatch batch = _firestore.batch();

    // Step 1: Update the chat room document with latest message details
    DocumentReference chatRoomDocRef = _firestore.collection('chatRooms').doc(chatRoomId);
    batch.update(chatRoomDocRef, {
      'lastMessageTimestamp': timestamp,
      'users': FieldValue.arrayUnion([senderId, receiverId]), // Add sender and receiver to users array
      'lastMessage': message,
      'senderId': senderId, // Update last message field
    });

    // Step 2: Add message to chat room messages subcollection
    DocumentReference messageDocRef = chatRoomDocRef.collection('messages').doc(chatMessage.id);
    batch.set(messageDocRef, chatMessage.toMap());

    // Commit the batch operation
    await batch.commit();

    print('Message sent successfully');
  } catch (e) {
    print('Error sending message: $e');
    throw e; // Propagate error to caller
  }
}

Future<String> getSenderIdFromChatRoom(String chatRoomId) async {
    DocumentSnapshot chatRoomSnapshot = await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).get();
    if (chatRoomSnapshot.exists) {
      List<dynamic> users = chatRoomSnapshot['users'];
      for (String userId in users) {
        if (userId != FirebaseAuth.instance.currentUser!.uid) {
          return userId;
        }
      }
    }
    throw Exception('Sender ID not found in chat room');
  }
  
Future<ChatRoom> createChatRoom(String sellerId, String currentUserId, String chatRoomId) async {
    try {
      // Example: Creating a chat room document in Firestore
      DocumentReference<Map<String, dynamic>> chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);

      // Example data for chat room
      Map<String, dynamic> chatRoomData = {
        'id': chatRoomId,
        'users': [sellerId, currentUserId], // Include both sellerId and currentUserId
        'lastMessageTimestamp': Timestamp.now(), // Example: Timestamp for last message
        // Add other relevant data as needed
      };

      // Set the chat room data in Firestore
      await chatRoomRef.set(chatRoomData);

      // Return the created ChatRoom object
      return ChatRoom(
        id: chatRoomId,
        users: [sellerId, currentUserId],
        lastMessageTimestamp: Timestamp.now(),
        // Add other relevant data as needed
      );
    } catch (error) {
      print('Error creating chat room: $error');
      rethrow; // Re-throw the error to be handled further up the call stack
    }
  }
  // Fetch messages for a specific chat room
  Stream<List<ChatMessage>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromDocumentSnapshot(doc))
            .toList());
  }


  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    try {
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      print('Error deleting message: $e');
      throw Exception('Failed to delete message');
    }
  }

}

