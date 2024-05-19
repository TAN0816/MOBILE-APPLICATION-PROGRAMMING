class Book {
  final String id;
  final String sellerId;
  final String name;
  final double price;
  final int quantity;
  final List<String> images;
  final String faculty; // Add this field
  final String year;    // Add this field

  Book( {
    required this.id,
    required this.sellerId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.images,
    required this.faculty,
    required this.year, // Add this field
  });

  String get getId => id;
  String get getSellerId => sellerId;
  double get getPrice => price;
  String get getName => name;
  int get getQuantity => quantity;
  List<String> get getImages => images;
  String get getFaculty => faculty; // Add this getter
  String get getYear => year;       // Add this getter
}
