import 'package:cloud_firestore/cloud_firestore.dart';

void addBooksData() async {
  final CollectionReference books = FirebaseFirestore.instance.collection('books');

  List<Map<String, dynamic>> booksData = [
    {
      "title": "Probability and Statistics",
      "price": 18.00,
      "image": "https://example.com/probability_and_statistics.jpg"
    },
    {
      "title": "C++ Programming in 7 Days",
      "price": 25.00,
      "image": "https://example.com/cpp_programming.jpg"
    },
    {
      "title": "HCI Text Book",
      "price": 148.00,
      "image": "https://example.com/hci_text_book.jpg"
    },
    {
      "title": "Computer Networking Beginners Guide",
      "price": 30.00,
      "image": "https://example.com/computer_networking.jpg"
    },
    {
      "title": "Chemical Engineering",
      "price": 75.00,
      "image": "https://example.com/chemical_engineering.jpg"
    },
    {
      "title": "Discrete Mathematics",
      "price": 45.00,
      "image": "https://example.com/discrete_mathematics.jpg"
    }
  ];

  for (var book in booksData) {
    await books.add(book);
  }
}

void main() {
  addBooksData();
}
