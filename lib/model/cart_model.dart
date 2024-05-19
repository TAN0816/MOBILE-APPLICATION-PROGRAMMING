import 'package:secondhand_book_selling_platform/model/book_model.dart';

class CartItem {
  late Book book;
  int quantity = 1;
  Book get getBook => book;
  int get getQuantity => quantity;
  void setQuantity(qtt) => quantity = qtt;
  CartItem({required this.book, required this.quantity});
}
