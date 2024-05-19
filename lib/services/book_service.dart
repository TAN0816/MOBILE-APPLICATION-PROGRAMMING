import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> bookCollection = FirebaseFirestore.instance.collection('books');

  Future<List<Book>> getAllBooks() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await bookCollection.get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Book(
        id: doc.id,
        sellerId: (data['sellerId'] as String?) ?? 'Unknown Seller',
        name: (data['name'] as String?) ?? 'Unknown Title',
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        quantity: (data['quantity'] as int?) ?? 0,
        images: List<String>.from(data['images'] ?? []),
        faculty: (data['faculty'] as String?) ?? 'Unknown Faculty',
        year: (data['year'] as String?) ?? 'Unknown Year',
      );
    }).toList();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBooksStream() {
    return bookCollection.snapshots();
  }

  Future<List<Book>> searchBooksByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await bookCollection
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: name + '\uf8ff')
        .get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Book(
        id: doc.id,
        sellerId: (data['sellerId'] as String?) ?? 'Unknown Seller',
        name: (data['name'] as String?) ?? 'Unknown Title',
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        quantity: (data['quantity'] as int?) ?? 0,
        images: List<String>.from(data['images'] ?? []),
        faculty: (data['faculty'] as String?) ?? 'Unknown Faculty',
        year: (data['year'] as String?) ?? 'Unknown Year',
      );
    }).toList();
  }

//   Future<List<Book>> fetchBooks({double? minPrice, double? maxPrice, String? faculty, List<String>? years}) async {
//     Query<Map<String, dynamic>> query = bookCollection;

//     if (minPrice != null) {
//         query = query.where('price', isGreaterThanOrEqualTo: minPrice);
//     }

//     if (maxPrice != null) {
//         query = query.where('price', isLessThanOrEqualTo: maxPrice);
//     }

//     if (faculty != null && faculty.isNotEmpty && faculty != 'All') {
//         query = query.where('faculty', isEqualTo: faculty);
//     }

//     if (years != null && years.isNotEmpty) {
//         query = query.where('year', whereIn: years);
//     }

//     QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
//     return snapshot.docs.map((doc) {
//         var data = doc.data();
//         return Book(
//             id: doc.id,
//             sellerId: data['sellerId'] ?? 'Unknown Seller',
//             name: data['name'] ?? 'Unknown Title',
//             price: (data['price'] as num?)?.toDouble() ?? 0.0,
//             quantity: data['quantity'] ?? 0,
//             images: List<String>.from(data['images'] ?? []),
//             faculty: data['faculty'] ?? 'Unknown Faculty',
//             year: data['year'] ?? 'Unknown Year',
//         );
//     }).toList();
// }
Future<List<Book>> searchAndFilterBooks({
    required String query,
    double? minPrice,
    double? maxPrice,
    String? faculty,
    List<String>? years,
  }) async {
    Query<Map<String, dynamic>> queryRef = bookCollection;

    if (minPrice != null) {
      queryRef = queryRef.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      queryRef = queryRef.where('price', isLessThanOrEqualTo: maxPrice);
    }

    if (faculty != null && faculty.isNotEmpty && faculty != 'All') {
      queryRef = queryRef.where('faculty', isEqualTo: faculty);
    }

    if (years != null && years.isNotEmpty) {
      queryRef = queryRef.where('year', whereIn: years);
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await queryRef.get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Book(
        id: doc.id,
        sellerId: (data['sellerId'] as String?) ?? 'Unknown Seller',
        name: (data['name'] as String?) ?? 'Unknown Title',
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        quantity: (data['quantity'] as int?) ?? 0,
        images: List<String>.from(data['images'] ?? []),
        faculty: (data['faculty'] as String?) ?? 'Unknown Faculty',
        year: (data['year'] as String?) ?? 'Unknown Year',
      );
    }).toList();
  }

}
