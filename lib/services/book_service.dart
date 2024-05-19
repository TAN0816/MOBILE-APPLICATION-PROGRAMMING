import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        faculty: data['faculty'] ?? 'Unknown Course',
      );
    }).toList();
  }

  Stream<QuerySnapshot> getBooksStream() {
    return _firestore.collection('books').snapshots();
  }

  Future<List<Book>> searchBooksByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('books')
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
        year: data['year'] ?? 'Unknown Year',
        faculty: data['faculty'] ?? 'Unknown Course',
      );
    }).toList();
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
        faculty: data['faculty'] ?? 'Unknown Course',
      );
    } else {
      return null; // Book not found
    }
  }

  // Method to delete a book from Firestore
  Future<void> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
    } catch (e) {
      print('Error deleting book: $e');
      throw e;
    }
  }
}
