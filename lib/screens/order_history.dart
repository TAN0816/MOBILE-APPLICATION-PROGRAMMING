import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/services/order_history_service.dart';
import 'package:secondhand_book_selling_platform/model/order.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/appbar_with_back.dart';

class OrderHistory extends StatefulWidget {
  final String userId;

  OrderHistory({required this.userId});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  OrderHistoryService _orderHistoryService = OrderHistoryService();
  List<Order> _orders = [];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      List<Order> orders =
          await _orderHistoryService.getOrderHistory(widget.userId);
      setState(() {
        _orders = orders;
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
        _errorMessage = 'Error fetching orders: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Order History'),
      // ),
      appBar: const AppBarWithBackBtn(title: 'Order History'),

      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _orders.isEmpty
                  ? Center(child: Text('No orders found'))
                  : ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        Order order = _orders[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0, // Adjust vertical padding
                            horizontal: 10.0, // Adjust horizontal padding
                          ),
                          child: Card(
                            elevation: 3, // Add elevation for a shadow effect
                            child: Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Add padding inside the Card
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        IconData(0xf02cb,
                                            fontFamily: 'MaterialIcons'),
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'Order No: ${order.id}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(order.timestamp),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),

                                  // Text(
                                  //   'Order No: ${order.id}',
                                  //   style: TextStyle(fontWeight: FontWeight.bold),
                                  // ),
                                  // SizedBox(height: 5),
                                  // Text(
                                  //     'Delivery Method: ${order.deliveryMethod ?? 'Unknown'}'), // Use null-aware operator and provide default value
                                  // Text(
                                  //     'Payment Method: ${order.paymentMethod ?? 'Unknown'}'), // Use null-aware operator and provide default value
                                  SizedBox(
                                      height:
                                          20), // Add spacing between elements
                                  ...order.order.map((orderItem) {
                                    return ListTile(
                                      leading: orderItem.book.images.isNotEmpty
                                          ? Image.network(
                                              orderItem.book.images[0],
                                              fit: BoxFit.cover,
                                              width: 50,
                                              height: 80,
                                            )
                                          : Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.grey,
                                            ),
                                      title: Text(orderItem.book.name),
                                      subtitle: Text(
                                          'Quantity: ${orderItem.quantity}'),
                                      trailing: Text(
                                          'RM${orderItem.book.price * orderItem.quantity}'),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
