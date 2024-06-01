class OrderItem {
  String bookid;
  String name;
  int quantity;

  OrderItem({
    required this.bookid,
    required this.name,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      bookid: json['bookid'],
      name: json['name'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookid': bookid,
      'name': name,
      'quantity': quantity,
    };
  }

  // Getters for each field
  String get getBookId => bookid;

  String get getName => name;

  int get getQuantity => quantity;
}
