import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:secondhand_book_selling_platform/model/order.dart';
import 'package:secondhand_book_selling_platform/model/orderitem.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';

class OrderHistoryService {
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;

  Future<List<Order>> getOrderHistory(String userId) async {
    try {
      firestore.QuerySnapshot orderSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      List<Order> orders = [];

      for (var doc in orderSnapshot.docs) {
        List<OrderItem> orderItems = [];
        double totalAmountValue = 0.0;

        if (doc['books'] != null) {
          for (var item in doc['books']) {
            var bookId = item['bookId']?.toString() ?? '';
            var quantity = item['quantity'] ?? 0;

            if (bookId.isNotEmpty) {
              firestore.DocumentSnapshot bookSnapshot =
                  await _firestore.collection('books').doc(bookId).get();

              if (bookSnapshot.exists) {
                Book book = Book.fromMap(
                    bookSnapshot.data() as Map<String, dynamic>,
                    bookSnapshot.id);
                OrderItem orderItem = OrderItem(
                  bookid: bookId,
                  name: book.name,
                  images: book.images,
                  quantity: quantity,
                );

                orderItems.add(orderItem);
                totalAmountValue += book.price * quantity;
              }
            }
          }
        }

        var deliveryMethod = doc['deliveryMethod']?.toString() ?? 'Unknown';
        var paymentMethod = doc['paymentMethod']?.toString() ?? 'Unknown';
        var timestamp = doc['timestamp'] as firestore.Timestamp;
        var status = doc['status']?.toString() ?? 'Unknown';

        orders.add(Order(
          id: doc.id,
          userId: doc['userId'],
          sellerId: doc['sellerId'],
          orderItems: orderItems,
          deliveryMethod: deliveryMethod,
          paymentMethod: paymentMethod,
          totalAmount: totalAmountValue,
          timestamp: timestamp,
          status: status,
        ));
      }

      return orders;
    } catch (error) {
      print('Error fetching order history: $error');
      throw error;
    }
  }
}
