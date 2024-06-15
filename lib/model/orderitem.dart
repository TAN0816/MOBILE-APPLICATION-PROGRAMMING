import 'package:secondhand_book_selling_platform/model/book.dart';

class OrderItem {
  String bookid;
  String name;
  List<String> images;
  int quantity;
  final Book book;

  OrderItem({
    required this.bookid,
    required this.name,
    required this.book,
    required this.images,
    required this.quantity,
  });

  String get getBookId => bookid;
  Book get getBook => book;
  String get getName => name;
  List<String> get getImage => images;

  int get getQuantity => quantity;

  static fromJson(Object? data) {}
}
