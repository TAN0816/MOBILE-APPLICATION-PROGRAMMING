import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/book.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to upload a book to Firestore
  Future<void> uploadBook(
    String name,
    double price,
    String detail,
    String faculty,
    String year,
    int quantity,
    List<String> imageUrls,
  ) async {
    try {
      await _firestore.collection('books').add({
        'name': name,
        'price': price,
        'detail': detail,
        'faculty': faculty,
        'year': year,
        'quantity': quantity,
        'images': imageUrls,
      });
    } catch (e) {
      print('Error uploading book: $e');
      throw e; // Throw the error to handle it in the calling code
    }
  }

// Method to retrieve a book from Firestore by its ID
  Future<Book> getBookById(String bookId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('books').doc(bookId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Book(
      id: snapshot.id,
      // sellerId: data[
      //     'sellerId'], // Ensure your Firestore document has a sellerId field
      name: data['name'],
      price: data['price'],
      quantity: data['quantity'],
      detail: data['detail'],
      images: List<String>.from(data['images']),
      year: data['year'],
      faculty: data['faculty'],
    );
  }

  // Method to update a book in Firestore
  Future<void> updateBook(
    String bookId,
    String name,
    double price,
    String detail,
    String faculty,
    String year,
    int quantity,
    List<String> imageUrls,
  ) async {
    await _firestore.collection('books').doc(bookId).update({
      'name': name,
      'price': price,
      'detail': detail,
      'faculty': faculty,
      'year': year,
      'quantity': quantity,
      'images': imageUrls,
    });
  }

  // // Method to delete a book from Firestore
  // Future<void> deleteBook(String bookId) async {
  //   try {
  //     await _firestore.collection('books').doc(bookId).delete();
  //   } catch (e) {
  //     print('Error deleting book: $e');
  //     throw e;
  //   }
  // }
}
