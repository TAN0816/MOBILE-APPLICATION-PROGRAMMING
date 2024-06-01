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
      Map<String, List<Book>> booksBySeller = {};
      Map<String, List<int>> quantitiesBySeller = {};

      for (int i = 0; i < books.length; i++) {
        String sellerId = books[i].sellerId;
        if (!booksBySeller.containsKey(sellerId)) {
          booksBySeller[sellerId] = [];
          quantitiesBySeller[sellerId] = [];
        }
        booksBySeller[sellerId]!.add(books[i]);
        quantitiesBySeller[sellerId]!.add(quantities[i]);
      }

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
        'images': books[i].images,
        'quantity': quantities[i],
      };
      bookData.add(bookInfo);
      totalAmount += (books[i].price * quantities[i]);
    }

    Map<String, dynamic> orderData = {
      'userId': userId,
      'books': bookData,
      'sellerId': sellerId,
      'deliveryMethod': deliveryMethod,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'timestamp': FieldValue.serverTimestamp(),
      'status': "Pending",
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

      DocumentReference bookRef =
          _firestore.collection('books').doc(books[i].id);
      batch.update(bookRef, {'quantity': FieldValue.increment(-quantities[i])});
    }

    _checkBookQuantitiesAndUpdateStatus(books);

    batch.update(cartRef, {'cartList': cartList});

    try {
      await batch.commit();
      print('Batch commit successful');
    } catch (e) {
      print('Error committing batch: $e');
      rethrow;
    }
  }

  Future<Book> getBookById(String bookId) async {
    try {
      // Fetch book data from Firestore or any other data source
      // Example:
      DocumentSnapshot bookSnapshot =
          await _firestore.collection('books').doc(bookId).get();

      if (!bookSnapshot.exists) {
        throw Exception('Book with ID $bookId not found');
      }

      Map<String, dynamic> bookData =
          bookSnapshot.data() as Map<String, dynamic>;

      // Create a Book object from the fetched data
      Book book = Book.fromMap(bookData, bookSnapshot.id);

      return book;
    } catch (error) {
      print('Error retrieving book: $error');
      throw error;
    }
  }


    Future<void> _checkBookQuantitiesAndUpdateStatus(List<Book> books) async {
    for (var book in books) {
      DocumentReference bookRef = _firestore.collection('books').doc(book.id);
      DocumentSnapshot bookSnapshot = await bookRef.get();

      if (bookSnapshot.exists) {
        int currentQuantity = bookSnapshot.get('quantity');
        if (currentQuantity <= 0) {
          await bookRef.update({'status': 'unavailable'});
          print('Book status updated to UNAVAILABLE for book ID: ${book.id}');
        }
      }
    }
  }

  Future<List<OrderList.Order>> getOrder(String userId) async {
    try {
      QuerySnapshot orderSnapshots = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'Pending')
          .get();

      if (orderSnapshots.docs.isEmpty) {
        throw Exception('No orders found for user ID: $userId');
      }

      List<OrderList.Order> orders = [];

      for (QueryDocumentSnapshot orderSnapshot in orderSnapshots.docs) {
        Map<String, dynamic> orderData =
            orderSnapshot.data()! as Map<String, dynamic>;

        List<dynamic> booksData = orderData['books'] as List<dynamic>;

        List<OrderItem> orderItems = await Future.wait(
            booksData.map<Future<OrderItem>>((bookData) async {
          // Assuming you have a method to fetch book data based on bookId
          Book book =
              await getBookById(bookData['bookId']); // Replace with your method

          return OrderItem(
            bookid: bookData['bookId'],
            name: bookData['name'],
            book: book, // Pass the Book object
            images: (bookData['images'] as List<dynamic>).cast<String>(),
            quantity: bookData['quantity'],
          );
        }).toList());

        OrderList.Order order = OrderList.Order(
          id: orderSnapshot.id,
          userId: orderData['userId'],
          sellerId: orderData['sellerId'],
          orderItems: orderItems,
          deliveryMethod: orderData['deliveryMethod'],
          paymentMethod: orderData['paymentMethod'],
          totalAmount: orderData['totalAmount'],
          timestamp: orderData['timestamp'],
          status: orderData['status'],
        );

        orders.add(order);
        print(orders);
      }

      return orders;
    } catch (error) {
      print('Error retrieving orders: $error');
      throw error;
    }
  }

  Future<OrderList.Order> getOrderById(String orderId) async {
    try {
      DocumentSnapshot orderSnapshot =
          await _firestore.collection('orders').doc(orderId).get();

      if (!orderSnapshot.exists) {
        throw Exception('No order found for order ID: $orderId');
      }

      Map<String, dynamic> orderData =
          orderSnapshot.data()! as Map<String, dynamic>;

      List<dynamic> booksData = orderData['books'] as List<dynamic>;

      List<OrderItem> orderItems =
          await Future.wait(booksData.map<Future<OrderItem>>((bookData) async {
        // Assuming you have a method to fetch book data based on bookId
        Book book =
            await getBookById(bookData['bookId']); // Replace with your method

        return OrderItem(
          bookid: bookData['bookId'],
          name: bookData['name'],
          book: book, // Pass the Book object
          images: (bookData['images'] as List<dynamic>).cast<String>(),
          quantity: bookData['quantity'],
        );
      }).toList());

      OrderList.Order order = OrderList.Order(
        id: orderSnapshot.id,
        userId: orderData['userId'],
        sellerId: orderData['sellerId'],
        orderItems: orderItems,
        deliveryMethod: orderData['deliveryMethod'],
        paymentMethod: orderData['paymentMethod'],
        totalAmount: orderData['totalAmount'],
        timestamp: orderData['timestamp'],
        status: orderData['status'],
      );

      return order;
    } catch (error) {
      print('Error retrieving order: $error');
      throw error;
    }
  }

  Future<void> updateOrderStatusAndReasons(
      String orderId, String status, String reasons) async {
    try {
      DocumentReference orderRef = _firestore.collection('orders').doc(orderId);

      await orderRef.update({
        'status': status,
        'reasons': reasons,
      });

      print('Order status and reasons updated successfully');
    } catch (e) {
      print('Error updating order status and reasons: $e');
      throw e;
    }
  }

  Future<List<OrderList.Order>> getSellerCurrentOrder(
      String sellerId, List<String> statuses) async {
    try {
      Query orderQuery = _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId);

      if (statuses.length == 1) {
        orderQuery = orderQuery.where('status', isEqualTo: statuses[0]);
      } else if (statuses.length > 1) {
        orderQuery = orderQuery.where('status', whereIn: statuses);
      }

      QuerySnapshot orderSnapshots = await orderQuery.get();

      List<OrderList.Order> orders = [];

      for (QueryDocumentSnapshot orderSnapshot in orderSnapshots.docs) {
        Map<String, dynamic> orderData =
            orderSnapshot.data()! as Map<String, dynamic>;

        List<dynamic> booksData = orderData['books'] as List<dynamic>;

        List<OrderItem> orderItems = [];

        // Iterate over each book data in the order
        for (var bookData in booksData) {
          // Retrieve the book details based on the book ID
          Book book = await getBookById(bookData['bookId']);

          // Create an OrderItem object
          OrderItem orderItem = OrderItem(
            bookid: bookData['bookId'],
            name: bookData['name'],
            book: book,
            images: (bookData['images'] as List<dynamic>).cast<String>(),
            quantity: bookData['quantity'],
          );

          // Add the OrderItem to the list of orderItems
          orderItems.add(orderItem);
        }

        OrderList.Order order = OrderList.Order(
          id: orderSnapshot.id,
          userId: orderData['userId'],
          sellerId: orderData['sellerId'],
          orderItems: orderItems,
          deliveryMethod: orderData['deliveryMethod'],
          paymentMethod: orderData['paymentMethod'],
          totalAmount: orderData['totalAmount'],
          timestamp: orderData['timestamp'],
          status: orderData['status'],
        );

        orders.add(order);
        print(orders);
      }

      return orders;
    } catch (error) {
      print('Error retrieving orders: $error');
      throw error;
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      print('Order status updated successfully');
    } catch (error) {
      print('Error updating order status: $error');
      throw error;
    }
  }
}
