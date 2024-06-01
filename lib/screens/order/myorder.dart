import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:secondhand_book_selling_platform/services/order_service.dart';
import 'package:secondhand_book_selling_platform/model/order.dart' as Orderitem;
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  late Future<List<Orderitem.Order>> _ordersFuture;
  UserService userService = UserService();
  String userId = '';

  @override
  void initState() {
    super.initState();
    userId = UserService().getUserId;
    _ordersFuture = _fetchOrders(userId);
  }

  Future<List<Orderitem.Order>> _fetchOrders(String userId) async {
    try {
      final orders = await OrderService().getOrder(userId);
      return orders;
    } catch (error) {
      print('Error fetching orders: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
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
                  final formattedTimestamp = DateFormat('MM/dd/yyyy').format(order.timestamp.toDate()); // Format the timestamp
                  return Card(
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
                              Image.asset(
                                'assets/images/hci.jpg', // Replace with actual image path from order data
                                width: 100,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                       'Name: ${order.orderItemsList.isNotEmpty ? order.orderItemsList[0]?.name ?? "Unknown" : "Unknown"}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Quantity: ${order.orderItemsList.isNotEmpty ? order.orderItemsList[0]?.quantity ?? 0 : 0}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(255, 48, 48, 48),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Date: $formattedTimestamp', // Display formatted timestamp
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(255, 48, 48, 48),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(255, 48, 48, 48),
                                          ),
                                        ),
                                        Text(
                                          'RM${order.totalAmountValue}', // Use actual total amount from order data
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 48, 48, 48),
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

