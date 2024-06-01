import 'package:secondhand_book_selling_platform/model/orderitem.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';


class Order {
  final String id;
  final List<OrderItem> order;
  final String deliveryMethod;
  final String paymentMethod;

  Order({
    required this.id,
    required this.order,
    required this.deliveryMethod,
    required this.paymentMethod,
  });

  String get getId => id;
  List<OrderItem> get getOrder => order;
  String get getDeliveryMethod => deliveryMethod;
  String get getPaymentMethod => paymentMethod;
}
