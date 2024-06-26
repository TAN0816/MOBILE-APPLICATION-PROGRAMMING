import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:secondhand_book_selling_platform/model/orderitem.dart'; // Assuming the OrderItem model is imported

class Order {
  String id;
  String userId;
  String sellerId;
  List<OrderItem> orderItems;
  String deliveryMethod;
  String paymentMethod;
  double totalAmount;
  Timestamp timestamp;
  String status;

  Order({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.orderItems,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.totalAmount,
    required this.timestamp,
    required this.status,
  });

  String get orderId => id;

  String get userIdValue => userId;

  String get sellerIdValue => sellerId;

  List<OrderItem> get orderItemsList => orderItems;

  String get deliveryMethodValue => deliveryMethod;

  String get paymentMethodValue => paymentMethod;

  double get totalAmountValue => totalAmount;

  Timestamp get timestampValue => timestamp;
  set cancellationReason(int cancellationReason) {}
  String get getOrderStatus => status;
}
