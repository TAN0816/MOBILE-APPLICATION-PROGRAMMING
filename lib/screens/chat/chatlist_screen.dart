import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:secondhand_book_selling_platform/model/user.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String userId = '';
  String currentUserRole = '';
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    fetchCurrentUserId();
    fetchCurrentUserRole();
  }

  void fetchCurrentUserId() async {
    try {
      userId = await userService.getCurrentUserId();
      setState(() {});
    } catch (e) {
      print('Error fetching current user ID: $e');
    }
  }

  void fetchCurrentUserRole() async {
    try {
      var user = await userService.getUser(userId);
      if (user != null) {
        setState(() {
          currentUserRole = user.role;
        });
      }
    } catch (e) {
      print('Error fetching current user role: $e');
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate().add(Duration(hours: 8));
    ;
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(80.0), // Adjust the preferred height as needed
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(
                top: 50.0, bottom: 12.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chats",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height:
                        5.0), // Adjust the height of the space below "Chats"
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
                5.0 + 1.0), // Height of the Divider + Additional space
            child: Column(
              children: [
                Divider(
                  height: 1,
                  color: const Color.fromARGB(
                      255, 212, 210, 210), // Adjust the color as needed
                ),
                SizedBox(
                    height:
                        5.0), // Adjust the height of the space below the Divider
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('users', arrayContains: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chatRooms = snapshot.data?.docs ?? [];
          if (chatRooms.isEmpty) {
            return Center(child: Text('No chats yet'));
          }
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index].data() as Map<String, dynamic>;
              final otherUserId = (chatRoom['users'] as List)
                  .firstWhere((id) => id != userId); // Get the other user's ID
              final lastMessage = chatRoom['lastMessage'] ?? '';
              final lastMessageTimestamp =
                  chatRoom['lastMessageTimestamp'] as Timestamp?;

              return FutureBuilder(
                future: userService.getUser(otherUserId),
                builder: (context, AsyncSnapshot<UserModel?> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                      ),
                      title: Text('Loading...'),
                      subtitle: Text(''),
                    );
                  }
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                      ),
                      title: Text('Unknown User'),
                      subtitle: Text(''),
                    );
                  }
                  final otherUser = userSnapshot.data!;
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(otherUser.image),
                        ),
                        title: Text(
                          otherUser.username,
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Make the text bold
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: Text(
                                lastMessage,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:
                                      15, // Adjust the font size as needed
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              lastMessageTimestamp != null
                                  ? formatTimestamp(lastMessageTimestamp)
                                  : '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          GoRouter.of(context).push(
                            '/chat/${chatRooms[index].id}?receiverId=$otherUserId',
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      Divider(
                          height: 1,
                          color: const Color.fromARGB(255, 221, 218,
                              218)), // Divider below each ListTile
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
