import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String role,
    required BuildContext context,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID
      String userId = userCredential.user!.uid;

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'phone': phone,
        'role': role,
        // Add more fields as needed
      });

      // Navigate to home screen or any other screen after successful sign-up
      context.push('/login');
    } catch (e) {
      // Handle sign-up errors
      print('Sign up error: $e');
      // You can show an error message to the user here
    }
  }

  String? getCurrentUserId() {
    //final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    return user?.uid;
  }

  Future<void> updateProfile(String userId, String username, String email,
      String mobile, String address, String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': username,
        'email': email,
        'mobile': mobile,
        'address': address,
        'image': imageUrl,
      });
      _user = await getUserData(userId);
      notifyListeners();
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
      address: userData['address'] ?? "",
      role: userData['role'],
      image: userData['image'] ?? "",
    );
    return user;
  }
}
