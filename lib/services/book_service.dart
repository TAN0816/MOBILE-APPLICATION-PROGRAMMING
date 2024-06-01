import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> bookCollection =
      FirebaseFirestore.instance.collection('books');

  Future<List<Book>> getAllBooks() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('books').get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Book(
        id: doc.id,
        sellerId: data['sellerId'] ?? 'Unknown Seller',
        name: data['name'] ?? 'Unknown Title',
        price: (data['price'] ?? 0.0).toDouble(),
        quantity: data['quantity'] ?? 0,
        detail: data['detail'] ?? 'No detail available.',
        images: List<String>.from(data['images'] ?? []),
        year: data['year'] ?? 'Unknown Year',
        faculty: data['faculty'] ?? 'Unknown Faculty',
      );
    }).toList();
  }

  Future<List<Book>> getAllBooksBySellerId(String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('books')
        .where('sellerId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Book(
        id: doc.id,
        sellerId: data['sellerId'] ?? 'Unknown Seller',
        name: data['name'] ?? 'Unknown Title',
        price: (data['price'] ?? 0.0).toDouble(),
        quantity: data['quantity'] ?? 0,
        detail: data['detail'] ?? 'No detail available.',
        images: List<String>.from(data['images'] ?? []),
        year: data['year'] ?? 'Unknown Year',
        faculty: data['faculty'] ?? 'Unknown Faculty',
      );
    }).toList();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBooksStream() {
    return bookCollection.snapshots();
  }

  Future<List<Book>> searchBooksByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await bookCollection
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '$name\uf8ff')
        .get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Book(
        id: doc.id,
        sellerId: data['sellerId'] ?? 'Unknown Seller',
        name: data['name'] ?? 'Unknown Title',
        price: (data['price'] ?? 0.0).toDouble(),
        quantity: data['quantity'] ?? 0,
        detail: data['detail'] ?? 'No detail available.',
        images: List<String>.from(data['images'] ?? []),
        faculty: (data['faculty'] as String?) ?? 'Unknown Faculty',
        year: (data['year'] as String?) ?? 'Unknown Year',
      );
    }).toList();
  }

  Future<List<Book>> searchAndFilterBooks({
    required String query,
    double? minPrice,
    double? maxPrice,
    String? faculty,
    List<String>? years,
  }) async {
    Query<Map<String, dynamic>> queryRef = bookCollection;

    // Perform search based on the query
    if (query.isNotEmpty) {
      queryRef = queryRef
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff');
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await queryRef.get();

    // Filter results to ensure case-insensitive search
    List<Book> books = querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Book(
        id: doc.id,
        sellerId: data['sellerId'] ?? 'Unknown Seller',
        name: data['name'] ?? 'Unknown Title',
        price: (data['price'] ?? 0.0).toDouble(),
        quantity: data['quantity'] ?? 0,
        detail: data['detail'] ?? 'No detail available.',
        images: List<String>.from(data['images'] ?? []),
        year: data['year'] ?? 'Unknown Year',
        faculty: data['faculty'] ?? 'Unknown Faculty',
      );
    }).toList();

    // Further filter the results based on the query
    if (query.isNotEmpty) {
      books = books.where((book) {
        return book.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    // Apply additional filters for price, faculty, and years
    if (minPrice != null) {
      books = books.where((book) => book.price >= minPrice).toList();
    }

    if (maxPrice != null) {
      books = books.where((book) => book.price <= maxPrice).toList();
    }

    if (faculty != null && faculty.isNotEmpty && faculty != 'All') {
      books = books.where((book) => book.faculty == faculty).toList();
    }

    if (years != null && years.isNotEmpty) {
      books = books.where((book) => years.contains(book.year)).toList();
    }

    return books;
  }

  Future<Book?> getBookById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _firestore.collection('books').doc(id).get();

    if (docSnapshot.exists) {
      var data = docSnapshot.data()!;
      return Book(
        id: docSnapshot.id,
        sellerId: data['sellerId'] ?? 'Unknown Seller',
        name: data['name'] ?? 'Unknown Title',
        price: (data['price'] ?? 0.0).toDouble(),
        quantity: data['quantity'] ?? 0,
        detail: data['detail'] ?? 'No detail available.',
        images: List<String>.from(data['images'] ?? []),
        year: data['year'] ?? 'Unknown Year',
        faculty: data['faculty'] ?? 'Unknown Faculty',
      );
    } else {
      return null; // Book not found
    }
  }

  Future<UserModel?> getSellerData(String sellerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(sellerId)
              .get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? userData = docSnapshot.data();
        if (userData != null) {
          UserModel seller = UserModel(
            username: userData['username'] ?? '',
            email: userData['email'] ?? '',
            phone: userData['phone'] ?? '',
            address: userData['address'] ?? '',
            role: userData['role'] ?? '',
            image: userData['image'] ?? '',
          );

          return seller;
        }
      }

      return null;
    } catch (e) {
      // Handle errors appropriately here
      print('Error fetching seller data: $e');
      return null;
    }
  }

  Future<void> updateBookAvailability(String bookId, bool availability) async {
    try {
      await _firestore.collection('books').doc(bookId).update({
        'status': availability ? 'available' : 'unavailable',
      });
    } catch (e) {
      print('Error updating book availability: $e');
      rethrow;
    }
  }
}
