import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SalesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getMonthlySalesData(String sellerId) async {
    try {
      QuerySnapshot orderSnapshots = await _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .where('status', isEqualTo: 'Completed')
          .get();

      Map<String, int> monthlySales = {
        'Jan': 0,
        'Feb': 0,
        'Mar': 0,
        'Apr': 0,
        'May': 0,
        'Jun': 0,
        'Jul': 0,
        'Aug': 0,
        'Sep': 0,
        'Oct': 0,
        'Nov': 0,
        'Dec': 0,
      };

      for (QueryDocumentSnapshot orderSnapshot in orderSnapshots.docs) {
        Map<String, dynamic> orderData =
            orderSnapshot.data() as Map<String, dynamic>;
        List<dynamic> booksData = orderData['books'] as List<dynamic>;

        Timestamp timestamp = orderData['timestamp'] as Timestamp;
        DateTime date = timestamp.toDate();
        String month = DateFormat('MMM').format(date);

        for (var bookData in booksData) {
          int quantity = bookData['quantity'];
          if (monthlySales.containsKey(month)) {
            monthlySales[month] = monthlySales[month]! + quantity;
          } else {
            monthlySales[month] = quantity;
          }
        }
      }

      print('Monthly sales data: $monthlySales');
      return monthlySales;
    } catch (error) {
      print('Error retrieving sales data: $error');
      rethrow;
    }
  }
}
