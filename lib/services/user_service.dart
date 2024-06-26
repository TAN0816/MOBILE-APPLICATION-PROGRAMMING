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

  Future<int> getSellerOrderNumber(String sellerId) async {
    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .get();
      return orderSnapshot.size;
    } catch (e) {
      print("Error getting seller order number: $e");
      return 0;
    }
  }

  Future<int> getBuyerOrderNumber(String userId) async {
    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['Pending', 'Preparing']).get();
      return orderSnapshot.size;
    } catch (e) {
      print("Error getting seller order number: $e");
      return 0;
    }
  }

  Future<int> getBuyerOrderHistory(String userId) async {
    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['Cancelled', 'Completed']).get();
      return orderSnapshot.size;
    } catch (e) {
      print("Error getting seller order number: $e");
      return 0;
    }
  }

   Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> userData = docSnapshot.data()!; // Ensure data is not null
        return UserModel(
          username: userData['username'],
          email: userData['email'],
          phone: userData['phone'],
          address: userData['address'] ?? "",
          role: userData['role'],
          image: userData['image'] ?? "",
        );
      } else {
        print('Document does not exist for user ID: $userId');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null; // Return null if any error occurs during data fetching
    }
  }
  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User not authenticated or not found');
    }
  }
}
