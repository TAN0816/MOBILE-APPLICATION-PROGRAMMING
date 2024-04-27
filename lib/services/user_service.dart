import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';

class UserService {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  String get getUserId => userId;

  Future<void> updateProfile(String userId, String username, String email,
      String phone, String address, String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': username,
        'email': email,
        'phone': phone,
        'address': address,
        'image': imageUrl,
      });
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Future<void> updateEmail(String email) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     await user.verifyBeforeUpdateEmail(email).then((value) async =>
  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(userId)
  //             .update({
  //           'email': email,
  //         }));
  //   }
  // }

  Future<UserModel> getUserData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
    UserModel user = UserModel(
      username: userData['username'],
      email: userData['email'],
      phone: userData['phone'],
      address: userData['address'] ?? "",
      role: userData['role'],
      image: userData['image'] ?? "",
    );
    return user;
  }
}
