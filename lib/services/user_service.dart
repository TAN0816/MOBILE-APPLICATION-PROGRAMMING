import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';

class UserService extends ChangeNotifier {
  UserService() {
    init();
  }

  UserModel? _user;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  UserModel? get getUser => _user;
  String get getUserId => userId;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _user = await getUserData(userId);
      }
      notifyListeners();
    });
  }

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
