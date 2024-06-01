import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder({
    required List<Book> books,
    required List<int> quantities,
    required String deliveryMethod,
    required String paymentMethod,
    required String userId,
  }) async {
    try {
      DocumentReference orderRef = _firestore.collection('orders').doc();

      List<Map<String, dynamic>> bookData = [];
      for (int i = 0; i < books.length; i++) {
        Map<String, dynamic> bookInfo = {
          'bookId': books[i].id,
          'name': books[i].name,
          'quantity': quantities[i],
        };
        bookData.add(bookInfo);
      }

      Map<String, dynamic> orderData = {
        'userId': userId,
        'books': bookData,
        'deliveryMethod': deliveryMethod,
        'paymentMethod': paymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await orderRef.set(orderData);

      await _updateCartAndBookQuantities(books, quantities, userId);

      print('Order placed successfully with ID: ${orderRef.id}');
    } catch (error) {
      print('Error placing order: $error');
      throw error;
    }
  }

  Future<void> _updateCartAndBookQuantities(
      List<Book> books, List<int> quantities, String userId) async {
    WriteBatch batch = _firestore.batch();

    // Fetch the user's cart
    DocumentReference cartRef = _firestore.collection('cart').doc(userId);
    DocumentSnapshot<Object?> cartSnapshot = await cartRef.get();

    if (!cartSnapshot.exists) {
      print('Cart does not exist for user: $userId');
      throw Exception('Cart does not exist');
    }

    // Get the current cart list
    List<dynamic> cartList = cartSnapshot.get('cartList');

    // Remove purchased items from the cart list
    for (int i = 0; i < books.length; i++) {
      cartList.removeWhere((item) => item['bookId'] == books[i].id);
      // Reduce quantity of books in inventory
      DocumentReference bookRef =
          _firestore.collection('books').doc(books[i].id);
      batch.update(bookRef, {'quantity': FieldValue.increment(-quantities[i])});
    }

    // Update the cart document with the new cart list
    batch.update(cartRef, {'cartList': cartList});

    try {
      await batch.commit();
      print('Batch commit successful');
    } catch (e) {
      print('Error committing batch: $e');
      throw e;
    }
  }
}
