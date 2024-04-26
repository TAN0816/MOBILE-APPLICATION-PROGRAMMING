import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addUser(String userId, String username, String email,
      String mobile, String address, String role) {
    return FirebaseFirestore.instance.collection('user').doc(userId).set({
      'username': username,
      'email': email,
      'mobile': mobile,
      'address': address,
      'role': role,
    });
  }

  String? getCurrentUserId() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  Future<void> updateProfile(String userId, String username, String email,
      String mobile, String address) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': username,
        'email': email,
        'mobile': mobile,
        'address': address,
      });
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<UserModel> getUserData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
    UserModel user = UserModel(
      username: userData['username'],
      email: userData['email'],
      mobile: userData['mobile'],
      address: userData['address'],
      role: userData['role'],
    );
    return user;
  }
}
