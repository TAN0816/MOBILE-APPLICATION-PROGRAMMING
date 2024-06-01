import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_book_selling_platform/services/order_history_service.dart';
import 'package:secondhand_book_selling_platform/model/order.dart' as Orderitem;
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class MyOrderScreen extends StatefulWidget {
  final String userId;

  const MyOrderScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  late Future<List<Orderitem.Order>> _ordersFuture;
  OrderHistoryService orderHistoryService = OrderHistoryService();

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders(widget.userId);
  }

  Future<List<Orderitem.Order>> _fetchOrders(String userId) async {
    try {
      final orders = await orderHistoryService.getOrderHistory(userId);
      return orders;
    } catch (error) {
      print('Error fetching orders: $error');
      throw error;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'preparing':
        return Colors.yellow;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders History'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 247, 247, 247),
        padding: const EdgeInsets.all(15),
        child: FutureBuilder<List<Orderitem.Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No orders available'));
            } else {
              final orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final formattedTimestamp =
                      DateFormat('MM/dd/yyyy').format(order.timestamp.toDate());

                  final status = order.status.toLowerCase();
                  final statusColor = _getStatusColor(status);

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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Image.network(
                                  order.orderItemsList[0].images[0],
                                  width: 100,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.orderItemsList[0].name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Quantity: ${order.orderItemsList[0].quantity}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromARGB(255, 48, 48, 48),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Date: $formattedTimestamp',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromARGB(255, 48, 48, 48),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: statusColor
                                      .withOpacity(0.2), // Light color
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the radius as needed
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  // 'Status: ${order.status}',
                                  ' ${order.status}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
