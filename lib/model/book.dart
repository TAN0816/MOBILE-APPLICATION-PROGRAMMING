class Book {
  final String id;
  final String sellerId;
  final String name;
  final double price;
  final int quantity;
  final String detail;
  final List<String> images;
  final String year;
  final String faculty;

  Book({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.detail,
    required this.images,
    required this.year,
    required this.faculty,
  });

  String get getId => id;
  String get getSellerId => sellerId;
  double get getPrice => price;
  String get getName => name;
  String get getDetail => detail;
  int get getQuantity => quantity;
  List<String> get getImages => images;
  String get getYear => year;
  String get getFaculty => faculty;

  // static Future<Book> fromSnapshot(DocumentSnapshot<Object?> snapshot) {}

  factory Book.fromMap(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,
      sellerId: data['sellerId'],
      name: data['name'],
      price: data['price'].toDouble(),
      quantity: data['quantity'],
      detail: data['detail'],
      images: List<String>.from(data['images']),
      year: data['year'],
      faculty: data['faculty'],
    );
  }
}
