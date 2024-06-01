import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:secondhand_book_selling_platform/model/orderitem.dart'; // Assuming the OrderItem model is imported

class Order {
  String id;
  String userId;
  String sellerId;
  List<OrderItem> orderItems; // Change to list of OrderItem
  String deliveryMethod;
  String paymentMethod;
  double totalAmount;
  Timestamp timestamp;

  Order({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.orderItems, // Change parameter name
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.totalAmount,
    required this.timestamp,
  });

  factory Order.fromDocument(DocumentSnapshot doc) {
    List<OrderItem> orderItemsList = List.from(doc['orderItems']).map((orderItemData) {
      return OrderItem(
        bookid: orderItemData['orderId'],
        name: orderItemData['name'],
        quantity: orderItemData['quantity'],
      );
    }).toList();

    return Order(
      id: doc.id,
      userId: doc['userId'],
      sellerId: doc['sellerId'],
      orderItems: orderItemsList,
      deliveryMethod: doc['deliveryMethod'],
      paymentMethod: doc['paymentMethod'],
      totalAmount: doc['totalAmount'],
      timestamp: doc['timestamp'],
    );
  }

  String get orderId => id;

  String get userIdValue => userId;

  String get sellerIdValue => sellerId;

  List<OrderItem> get orderItemsList => orderItems; // Adjust getter name

  String get deliveryMethodValue => deliveryMethod;

  String get paymentMethodValue => paymentMethod;

  double get totalAmountValue => totalAmount;

  Timestamp get timestampValue => timestamp;


}
