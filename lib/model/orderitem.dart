class OrderItem {
  String bookid;
  String name;
  List<String> images;
  int quantity;

  OrderItem({
    required this.bookid,
    required this.name,
    required this.images,
    required this.quantity,
  });



  String get getBookId => bookid;

  String get getName => name;
    List<String> get getImage => images;

  int get getQuantity => quantity;
}
