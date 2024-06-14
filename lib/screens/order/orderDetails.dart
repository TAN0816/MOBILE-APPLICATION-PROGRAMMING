import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/model/order.dart' as Orderitem;
import 'package:secondhand_book_selling_platform/model/order.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';
import 'package:secondhand_book_selling_platform/screens/order/cancelOrder.dart';
import 'package:secondhand_book_selling_platform/screens/order/giveRating.dart';
import 'package:secondhand_book_selling_platform/screens/order/updateOrderStatus.dart';
import 'package:secondhand_book_selling_platform/services/order_service.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Future<Orderitem.Order>? _orderFuture;
  final UserService _userService = UserService();
  UserModel? currentUserData;
  Future<UserModel>? orderUserData;
  String userId = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    userId = UserService().getUserId;
    _fetchCurrentUserData(userId);
    _orderFuture = _fetchOrders(widget.orderId);
  }

  void _fetchCurrentUserData(String userId) async {
    try {
      UserModel user = await UserService().getUserData(userId);
      setState(() {
        currentUserData = user;
        role = user.getRole;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<UserModel> _fetchOrderUserData(String userId) async {
    try {
      UserModel user = await _userService.getUserData(userId);
      return user;
    } catch (error) {
      print('Error fetching user data: $error');
      rethrow;
    }
  }

  Future<Orderitem.Order> _fetchOrders(String orderId) async {
    try {
      Orderitem.Order orders = await OrderService().getOrderById(orderId);
      return orders;
    } catch (error) {
      print('Error fetching orders: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Orderitem.Order>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Order not found'));
          } else {
            var selectedOrder = snapshot.data!;

            return FutureBuilder<UserModel>(
              future: _fetchOrderUserData(selectedOrder.userId),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                  return const Center(child: Text('User data not found'));
                } else {
                  var userData = userSnapshot.data!;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          OrderInformationCard(
                            orderData: selectedOrder,
                            userData: userData,
                          ),
                          const SizedBox(height: 10),
                          OrderDetailsCard(orderData: selectedOrder),
                          const SizedBox(height: 16),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 289,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (role == "Seller") {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return UpdateOrderStatus(
                                                orderId: widget.orderId);
                                          },
                                        );
                                      } else {
                                        context.push('/contactSeller');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff4a56c1),
                                    ),
                                    child: Text(
                                      role == "Buyer"
                                          ? "Contact Seller"
                                          : "Update Status",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                // if (selectedOrder.status != "Cancelled" &&
                                //     selectedOrder.status != "Completed")
                                const SizedBox(height: 16),

                                SizedBox(
                                  width: 284,
                                  height: 45,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      selectedOrder.status != "Cancelled" &&
                                              selectedOrder.status !=
                                                  "Completed"
                                          ? showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CancelOrderForm(
                                                    orderId: widget.orderId);
                                              },
                                            )
                                          : showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return GiveRating(
                                                    orderId: widget.orderId);
                                              },
                                            );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    child: Text(
                                      selectedOrder.status != "Cancelled" &&
                                              selectedOrder.status !=
                                                  "Completed"
                                          ? "Cancel Order"
                                          : "Give Rating",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class OrderInformationCard extends StatelessWidget {
  final Orderitem.Order orderData;
  final UserModel userData;

  const OrderInformationCard(
      {super.key, required this.orderData, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Remove border radius
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(userData.username ?? 'N/A'),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shipping Address: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(userData.address ?? 'N/A'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Payment Method: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(orderData.paymentMethod ?? 'N/A'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Shipping Method: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(orderData.deliveryMethod ?? 'N/A'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Phone Number: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(userData.phone ?? 'N/A'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsCard extends StatelessWidget {
  final Order orderData;

  const OrderDetailsCard({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Order No: ${orderData.orderId}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                    orderData.timestampValue.toDate().toString().split(' ')[0]),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${orderData.orderItemsList.length} items'),
                const Spacer(),
                Text(
                  orderData.status ?? 'Pending',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            for (var item in orderData.orderItemsList)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Image.network(
                      item.getBook
                          .getImages[0], // Accessing images from Book object
                      width: 80,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.getBook.getName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ), // Accessing name from Book object
                          Text('Units: ${item.getQuantity}'),
                        ],
                      ),
                    ),
                    Text(
                        'RM${item.getBook.getPrice.toStringAsFixed(2)}'), // Accessing price from Book object
                  ],
                ),
              ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            const Row(
              children: [
                Icon(Icons.receipt_long_sharp), // Icon
                SizedBox(width: 8), // Spacer between icon and text
                Text('Payment Details:'),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text(
                    'RM${orderData.totalAmountValue.toStringAsFixed(2)}'), // Use total amount from order data
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Fee'),
                Text('RM3.00'), // Hardcoded delivery fee
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payment',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'RM${(orderData.totalAmountValue + 3.00).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
