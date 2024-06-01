import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/services/order_history_service.dart';
import 'package:secondhand_book_selling_platform/model/order.dart';

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
                        final formattedTimestamp =
                            DateFormat('MM/dd/yyyy').format(order.timestamp);

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 6.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.article_rounded,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Order No: ${order.id}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      order.order[0].book.images.isNotEmpty
                                          ? Image.network(
                                              order.order[0].book.images[0],
                                              width: 100,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 100,
                                              height: 120,
                                              color: Colors.grey,
                                            ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order.order[0].book.name,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Quantity: ${order.order[0].quantity}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(
                                                    255, 48, 48, 48),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Date: $formattedTimestamp',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(
                                                    255, 48, 48, 48),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Total Amount: ',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromARGB(
                                                        255, 48, 48, 48),
                                                  ),
                                                ),
                                                Text(
                                                  'RM${order.totalAmountValue}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 48, 48, 48),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
