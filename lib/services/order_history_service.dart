// import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:secondhand_book_selling_platform/model/order.dart';
// import 'package:secondhand_book_selling_platform/model/orderitem.dart';
// import 'package:secondhand_book_selling_platform/model/book.dart';

// class OrderHistoryService {
//   final firestore.FirebaseFirestore _firestore =
//       firestore.FirebaseFirestore.instance;

//   Future<List<Order>> getOrderHistory(String userId) async {
//     try {
//       firestore.QuerySnapshot orderSnapshot = await _firestore
//           .collection('orders')
//           .where('userId', isEqualTo: userId)
//           .orderBy('timestamp', descending: true)
//           .get();

//       List<Order> orders = [];

//       for (var doc in orderSnapshot.docs) {
//         List<OrderItem> orderItems = [];

//         // Check if the 'books' field exists and is not null
//         if (doc['books'] != null) {
//           for (var item in doc['books']) {
//             var bookId = item['bookId']?.toString() ?? '';
//             var quantity = item['quantity'] ?? 0;

//             if (bookId.isNotEmpty) {
//               firestore.DocumentSnapshot bookSnapshot =
//                   await _firestore.collection('books').doc(bookId).get();

//               if (bookSnapshot.exists) {
//                 Book book = Book.fromMap(
//                     bookSnapshot.data() as Map<String, dynamic>,
//                     bookSnapshot.id);
//                 OrderItem orderItem = OrderItem(
//                   book: book,
//                   quantity: quantity,
//                   id: bookId,
//                 );

//                 orderItems.add(orderItem);
//               }
//             }
//           }
//         }

//         // Check if 'deliveryMethod' and 'paymentMethod' fields exist and are not null
//         var deliveryMethod = doc['deliveryMethod']?.toString() ?? 'Unknown';
//         var paymentMethod = doc['paymentMethod']?.toString() ?? 'Unknown';
//         var timestamp = (doc['timestamp'] as Timestamp)
//             .toDate(); // Retrieve timestamp from Firestore

//         orders.add(Order(
//           id: doc.id,
//           order: orderItems,
//           deliveryMethod: deliveryMethod,
//           paymentMethod: paymentMethod,
//           timestamp: timestamp,
//         ));
//       }

//       return orders;
//     } catch (error) {
//       print('Error fetching order history: $error');
//       throw error;
//     }
//   }
// }

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

        // Check if the 'books' field exists and is not null
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
                  book: book,
                  quantity: quantity,
                  id: bookId,
                );

                orderItems.add(orderItem);
              }
            }
          }
        }

        // Check if 'deliveryMethod' and 'paymentMethod' fields exist and are not null
        var deliveryMethod = doc['deliveryMethod']?.toString() ?? 'Unknown';
        var paymentMethod = doc['paymentMethod']?.toString() ?? 'Unknown';
        var timestamp = (doc['timestamp'] as firestore.Timestamp).toDate();

        orders.add(Order(
          id: doc.id,
          order: orderItems,
          deliveryMethod: deliveryMethod,
          paymentMethod: paymentMethod,
          timestamp: timestamp,
        ));
      }

      return orders;
    } catch (error) {
      print('Error fetching order history: $error');
      throw error;
    }
  }
}
