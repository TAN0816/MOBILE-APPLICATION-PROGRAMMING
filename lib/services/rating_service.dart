// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeRating(String orderId, double rating) async {
    try {
      DocumentReference orderRef = _firestore.collection('orders').doc(orderId);

      var orderSnapshot = await orderRef.get();
      if (orderSnapshot.exists) {
        await orderRef.update({
          'rating': rating,
        });
      } else {
        // Handle the case where the order does not exist in the 'orders' collection.
        print("Order not found.");
      }
    } catch (e) {
      // Handle any errors that occur during the operation.
      print("Error placing rating: $e");
    }
  }

  Future<int> getSellerRating(String sellerId) async {
    QuerySnapshot orderSnapshot = await _firestore
        .collection('orders')
        .where('sellerId', isEqualTo: sellerId)
        .get();

    double currentRating = 0;
    int numRating = 0;

    for (QueryDocumentSnapshot orderDoc in orderSnapshot.docs) {
      if (orderDoc.exists) {
        dynamic orderData = orderDoc.data();
        if (orderData != null && orderData.containsKey('rating')) {
          double orderRating = (orderData['rating'] as int).toDouble();
          currentRating += orderRating;
          numRating++;
        }
      }
    }
    if (numRating == 0) {
      return 0;
    }
  int rating = (currentRating / numRating).round();
print("Rating: $rating");
    return rating;
  }
}
