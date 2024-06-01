class OrderItem {
  String bookId;
  String name;
  List<String> images;
  int quantity;

  OrderItem({
    required this.bookId,
    required this.name,
    required this.images,
    required this.quantity,
  });

  String get getBookId => bookId;
  String get getName => name;
  List<String> get getImage => images;
  int get getQuantity => quantity;
}
