import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  Future<void> uploadBook(
    String name,
    double price,
    String detail,
    String course,
    String year,
    int quantity,
    List<String> imageUrls,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('books').add({
        'name': name,
        'price': price,
        'detail': detail,
        'course': course,
        'year': year,
        'quantity': quantity,
        'images': imageUrls,
      });
    } catch (e) {
      print('Error uploading book: $e');
      throw e; // Throw the error to handle it in the calling code
    }
  }
}
