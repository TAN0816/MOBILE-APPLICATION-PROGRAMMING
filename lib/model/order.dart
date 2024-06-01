import 'package:secondhand_book_selling_platform/model/orderitem.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';

class Order {
  final String id;
  final List<OrderItem> order;
  final String deliveryMethod;
  final String paymentMethod;
  final DateTime timestamp;
  // final String status;
  final double totalAmountValue;

  Order({
    required this.id,
    required this.order,
    required this.deliveryMethod,
    required this.paymentMethod,
    // this.deliveryMethod = 'Unknown',
    // this.paymentMethod = 'Unknown',
    required this.timestamp,
    // required this.status,
    required this.totalAmountValue,
  });

  String get getId => id;
  List<OrderItem> get getOrder => order;
  String get getDeliveryMethod => deliveryMethod;
  String get getPaymentMethod => paymentMethod;
  // String get getStatus => status;
  double get getTotalAmountValue => totalAmountValue;
}
