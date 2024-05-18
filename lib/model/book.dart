class Book {
  late final String id;
  final String sellerId;
  final String name;
  final double price;
  final int quantity;
   final List<String> images;

  Book(
      {required this.id,
      required this.sellerId,
      required this.name,
      required this.price,
      required this.quantity,
      required this.images});

  String get getId => id;
  String get getSellerId => sellerId;
  double get getPrice => price;
  String get getName => name;
  int get getQuantity=>quantity;
 List<String> get getImages => images; 

}