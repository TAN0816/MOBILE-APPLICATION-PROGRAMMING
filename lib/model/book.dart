
class Book {
  late final String id;
  final String sellerId;
  final String name;
  final double price;
  final int quantity;
  final String detail;
  final List<String> images;
  final String year;
  final String course;

  Book({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.detail,
    required this.images,
    required this.year,
    required this.course,
  });

  String get getId => id;
  String get getSellerId => sellerId;
  double get getPrice => price;
  String get getName => name;
  String get getDetail => detail;
  int get getQuantity => quantity;
  List<String> get getImages => images;
  String get getYear => year;
  String get getCourse => course;

  // static Future<Book> fromSnapshot(DocumentSnapshot<Object?> snapshot) {}
}
