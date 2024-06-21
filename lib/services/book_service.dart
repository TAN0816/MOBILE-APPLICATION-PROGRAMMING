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
        status: data['status'] ?? 'Unknown Status',
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
        status: data['status'] ?? 'Unknown Status',
      );
    }).toList();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBooksStream() {
    return bookCollection.snapshots();
  }

  Future<List<Book>> searchBooksByName(String name) async {
  // Convert search name to lowercase
  String searchNameLower = name.toLowerCase();

  QuerySnapshot<Map<String, dynamic>> querySnapshot = await bookCollection
      .where('name', isGreaterThanOrEqualTo: searchNameLower)
      .where('name', isLessThanOrEqualTo: '$searchNameLower\uf8ff')
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
      status: data['status'] ?? 'Unknown Status',
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
    try {
      // Convert query to lowercase to ensure case-insensitive search
      String queryLowerCase = query.toLowerCase();

      // Construct Firestore query for books collection
      Query<Map<String, dynamic>> queryRef = _firestore.collection('books');

      // Execute the query
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await queryRef.get();

      // Convert QuerySnapshot to a list of Book objects
      List<Book> books = querySnapshot.docs
          .where((doc) => doc.data()['name'].toLowerCase().contains(queryLowerCase))
          .map((doc) {
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
              status: data['status'] ?? 'Unknown Status',
            );
          })
          .toList();

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

      // Filter to show only available books
      books = books.where((book) => book.status == 'available').toList();

      return books;
    } catch (e) {
      print('Error searching and filtering books: $e');
      return []; // Return an empty list or handle error as needed
    }
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
        status: data['status'] ?? 'Unknown Status',
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
