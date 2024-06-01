import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/model/order.dart' as OrderList;
import 'package:secondhand_book_selling_platform/model/orderitem.dart';

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
      // Group books by sellerId
      Map<String, List<Book>> booksBySeller = {};
      Map<String, List<int>> quantitiesBySeller = {};

      for (int i = 0; i < books.length; i++) {
        String sellerId = books[i].sellerId; // Assuming Book model has a sellerId field
        if (!booksBySeller.containsKey(sellerId)) {
          booksBySeller[sellerId] = [];
          quantitiesBySeller[sellerId] = [];
        }
        booksBySeller[sellerId]!.add(books[i]);
        quantitiesBySeller[sellerId]!.add(quantities[i]);
      }

      // Create separate orders for each seller
      for (String sellerId in booksBySeller.keys) {
        await _createOrderForSeller(
          books: booksBySeller[sellerId]!,
          quantities: quantitiesBySeller[sellerId]!,
          deliveryMethod: deliveryMethod,
          paymentMethod: paymentMethod,
          userId: userId,
          sellerId: sellerId,
        );
      }

      // Update cart and book quantities
      await _updateCartAndBookQuantities(books, quantities, userId);

      print('All orders placed successfully');
    } catch (error) {
      print('Error placing order: $error');
      rethrow;
    }
  }

  Future<void> _createOrderForSeller({
    required List<Book> books,
    required List<int> quantities,
    required String deliveryMethod,
    required String paymentMethod,
    required String userId,
    required String sellerId,
  }) async {
    DocumentReference orderRef = _firestore.collection('orders').doc();

    List<Map<String, dynamic>> bookData = [];
    double totalAmount = 0;

    for (int i = 0; i < books.length; i++) {
      Map<String, dynamic> bookInfo = {
        'bookId': books[i].id,
        'name': books[i].name,
        'quantity': quantities[i],
      };
      bookData.add(bookInfo);
      totalAmount += (books[i].price * quantities[i]); // Calculate total amount
    }

    Map<String, dynamic> orderData = {
      'userId': userId,
      'books': bookData,
      'sellerId': sellerId,
      'deliveryMethod': deliveryMethod,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount, // Store total amount in order data
      'timestamp': FieldValue.serverTimestamp(),
    };

    await orderRef.set(orderData);
    print('Order placed successfully with ID: ${orderRef.id}');
  }

  Future<void> _updateCartAndBookQuantities(
      List<Book> books, List<int> quantities, String userId) async {
    WriteBatch batch = _firestore.batch();

    DocumentReference cartRef = _firestore.collection('cart').doc(userId);
    DocumentSnapshot<Object?> cartSnapshot = await cartRef.get();

    if (!cartSnapshot.exists) {
      print('Cart does not exist for user: $userId');
      throw Exception('Cart does not exist');
    }

    List<dynamic> cartList = cartSnapshot.get('cartList');

    for (int i = 0; i < books.length; i++) {
      cartList.removeWhere((item) => item['bookId'] == books[i].id);

      // Reduce quantity of books in inventory
      DocumentReference bookRef = _firestore.collection('books').doc(books[i].id);
      batch.update(bookRef, {'quantity': FieldValue.increment(-quantities[i])});
    }

    batch.update(cartRef, {'cartList': cartList});

    try {
      await batch.commit();
      print('Batch commit successful');
    } catch (e) {
      print('Error committing batch: $e');
      rethrow;
    }
  }
Future<List<OrderList.Order>> getOrder(String userId) async {
  try {
    QuerySnapshot orderSnapshots = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();

    if (orderSnapshots.docs.isEmpty) {
      throw Exception('No orders found for user ID: $userId');
    }

    List<OrderList.Order> orders = [];

    for (QueryDocumentSnapshot orderSnapshot in orderSnapshots.docs) {
      // Retrieve order data as Map<String, dynamic>
      Map<String, dynamic> orderData = orderSnapshot.data()! as Map<String, dynamic>;

      // Retrieve order items
      QuerySnapshot orderItemsSnapshot = await _firestore
          .collection('orders')
          .doc(orderSnapshot.id)
          .collection('books')
          .get();

      // Convert Firestore documents to OrderItem objects
      List<OrderItem> orderItems = orderItemsSnapshot.docs.map((doc) {
        return OrderItem(
          bookid: doc['orderId'],
          name: doc['name'],
          quantity: doc['quantity'],
        );
      }).toList();

      // Construct the Order object
      OrderList.Order order = OrderList.Order(
        id: orderSnapshot.id,
        userId: orderData['userId'],
        sellerId: orderData['sellerId'],
        orderItems: orderItems,
        deliveryMethod: orderData['deliveryMethod'],
        paymentMethod: orderData['paymentMethod'],
        totalAmount: orderData['totalAmount'],
        timestamp: orderData['timestamp'],
      );

      orders.add(order);
    }

    return orders;
  } catch (error) {
    print('Error retrieving orders: $error');
    // Handle error gracefully, e.g., show a message to the user
    throw error; // Rethrow the error to be handled by the caller
  }
}


}
