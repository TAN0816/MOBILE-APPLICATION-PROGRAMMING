import 'package:secondhand_book_selling_platform/model/book.dart';

class OrderItem {
  final Book book;
  final int quantity;
  final String id;

  OrderItem({required this.book, required this.quantity, required this.id});

  Book get getBook => book;

  int get getQuantity => quantity;

  String get getId => id;
}
