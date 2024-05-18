import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Book>> getAllBooks() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('books').get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Book(
        id: doc.id,
        sellerId: data['sellerId'] ?? 'Unknown Seller',
        name: data['name'] ?? 'Unknown Title',
        price: (data['price'] ?? 0.0).toDouble(),
        quantity: data['quantity'] ?? 0,
        images: List<String>.from(data['images'] ?? []),
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
        .where('name', isLessThanOrEqualTo: name + '\uf8ff')
        .get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Book(
        id: doc.id,
        sellerId: data['sellerId'] ?? 'Unknown Seller',
        name: data['name'] ?? 'Unknown Title',
        price: (data['price'] ?? 0.0).toDouble(),
        quantity: data['quantity'] ?? 0,
        images: List<String>.from(data['images'] ?? []),
      );
    }).toList();
  }
}
