import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/services/order_service.dart';
import 'package:secondhand_book_selling_platform/model/order.dart' as Orderitem;
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class SellerOrderList extends StatefulWidget {
  const SellerOrderList({super.key});

  @override
  State<SellerOrderList> createState() => _SellerOrderListState();
}

class _SellerOrderListState extends State<SellerOrderList>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  final sellerId = UserService().getUserId;
  Future<List<Orderitem.Order>> fetchCurrentOrders(String sellerId) async {
    try {
      final orders = await OrderService()
          .getSellerCurrentOrder(sellerId, ['Pending', 'Preparing']);
      return orders;
    } catch (error) {
      print('Error fetching orders: $error');
      throw error;
    }
  }

  Future<List<Orderitem.Order>> fetchCompletedOrders(String sellerId) async {
    try {
      final orders =
          await OrderService().getSellerCurrentOrder(sellerId, ['Completed']);
      return orders;
    } catch (error) {
      print('Error fetching orders: $error');
      throw error;
    }
  }

  Future<List<Orderitem.Order>> fetchCancelledOrders(String sellerId) async {
    try {
      final orders =
          await OrderService().getSellerCurrentOrder(sellerId, ['Cancelled']);
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
        title: Text('My Sales'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Current Order'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Container(
            color: Colors.white,
            child: orderList(() => fetchCurrentOrders(sellerId)),
          ),
          Container(
            color: Colors.white,
            child: orderList(() => fetchCompletedOrders(sellerId)),
          ),
          Container(
            color: Colors.white,
            child: orderList(() => fetchCancelledOrders(sellerId)),
          )
        ],
      ),
    );
  }

  Widget orderList(Function() queryFunction) {
    return FutureBuilder<List<Orderitem.Order>>(
      future: queryFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders yet'));
        } else {
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: index < orders.length - 1
                      ? const Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 223, 223, 223),
                            width: 1,
                          ),
                        )
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description_outlined),
                            const Text(
                              'Order No: ', // Display order ID
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(order.id)
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              order.status, // Display order status
                              style: const TextStyle(
                                color: Color.fromARGB(255, 36, 55,
                                    197), // Adjust color based on status
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        children: [
                          Image.network(
                            order.orderItemsList[0].images[0],
                            width: 60,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Title: ${order.orderItemsList[0].name}"),
                                  Text(
                                      "Qty: ${order.orderItemsList[0].quantity}")
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.push('/orderDetails/${order.id}');
                            },
                            icon: Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
