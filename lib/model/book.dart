// book.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String name;
  final double price;
  final String detail;
  final String course;
  final String year;
  final int quantity;
  final List<String> imageUrls;

  Book({
    required this.id,
    required this.name,
    required this.price,
    required this.detail,
    required this.course,
    required this.year,
    required this.quantity,
    required this.imageUrls,
  });

  factory Book.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Book(
      id: snapshot.id,
      name: data['name'],
      price: data['price'],
      detail: data['detail'],
      course: data['course'],
      year: data['year'],
      quantity: data['quantity'],
      imageUrls: List<String>.from(data['images']),
    );
  }
}
