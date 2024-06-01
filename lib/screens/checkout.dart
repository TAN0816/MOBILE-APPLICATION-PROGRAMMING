
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/model/cart_model.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';
import 'package:secondhand_book_selling_platform/services/order_service.dart';
import 'package:secondhand_book_selling_platform/widgets/appbar_with_back.dart'; // Assuming you have a Book model

class CheckoutPage extends StatefulWidget {
  final List<String> selectedBookIds; // List of selected bookIds
  final List<CartItem> selectedBooks; // List of selected books

  const CheckoutPage({
    super.key,
    required this.selectedBookIds,
    required this.selectedBooks,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _selectedPaymentMethod;
  double totalPrice = 0.0;
  double subTotalPrice = 0.0;
  double deliveryFee = 3;
  String username = '';
  String phone = '';
  String address = '';
  String? deliveryMethod;
  String? paymentMethod;


  @override
  void initState() {
    super.initState();

    setState(() {
      fetchUserData();
      for (CartItem c in widget.selectedBooks) {
        subTotalPrice += c.book.getPrice * c.getQuantity;
      }
      totalPrice = subTotalPrice + deliveryFee;
    });
  }

  void fetchUserData() async {
    String uid = UserService().getUserId;
    UserModel user = await UserService().getUserData(uid);
    setState(() {
      username = user.getUsername;
      phone = user.getPhone;
      address = user.getAddress;
    });
  }


   void _placeOrder() async {
    try {
      final orderService = OrderService();
  
      await orderService.placeOrder(
        books: widget.selectedBooks.map((item) => item.book).toList(),
        quantities: widget.selectedBooks.map((item) => item.getQuantity).toList(),
        deliveryMethod: deliveryMethod ?? '',
        paymentMethod: paymentMethod ?? '',
        userId: UserService().getUserId,
      );

          ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to the home page after a delay
    Future.delayed(const Duration(seconds: 2), () {
     context.push('/');
    });

    } catch (error) {
      // Handle errors here
      print('Error placing order: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackBtn(
        title: 'Checkout',
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 245, 245)),
              child: Column(
                children: [
                  const Row(
                    children: [Text('Order Item: ')],
                  ),
                  ListView.builder(
                    shrinkWrap:
                        true, // Make ListView take only the necessary height
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.selectedBookIds.length,
                    itemBuilder: (context, index) {
                      final cartItem = widget.selectedBooks[index];
                      final book = cartItem.getBook;
                      return Container(
                        height: 100,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(children: [
                          //book img
                          Image(
                            height: 80,
                            width: 80,
                            image: book.images != ""
                                ? NetworkImage(book.images[0]) as ImageProvider
                                : const AssetImage('assets/images/book.jpg'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          book.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "RM${book.getPrice.toStringAsFixed(2)}"),
                                    Row(
                                      children: [
                                        Text("Qty: ${cartItem.getQuantity}"),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ]),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment Method: '),
                        TextButton(
                          onPressed: () {
                            _showPaymentSelectBottomSheet(context);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            children: [
                              paymentMethod == null
                                  ? const Text('*Select Payment Method')
                                  : Text(paymentMethod!),
                              const Icon(Icons.arrow_forward_ios_outlined)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Getting this: '),
                            TextButton(
                              onPressed: () {
                                _showModalBottomSheet(context);
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  deliveryMethod == null
                                      ? const Text('*Select Delivery Method')
                                      : Text(deliveryMethod!),
                                  const Icon(Icons.arrow_forward_ios_outlined)
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Receiver Name: '),
                            Text(username),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Receiver Phone Number: '),
                            Text(phone),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Receiver Address: '),
                            Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 80),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Payment Details: '),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal: '),
                            Text('RM${subTotalPrice.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee: '),
                            Text('RM${deliveryFee.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total: '),
                            Text('RM${totalPrice.toStringAsFixed(2)}'),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                  color: Color.fromARGB(255, 214, 214, 214),
                )),
                color: Colors.white,
              ),
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Total: ',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            "RM${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 217, 44, 32),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {_placeOrder();},
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xff4a56c1),
                            padding: const EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                        child: const Text('Place Order',
                            style: TextStyle(
                                color: Color.fromARGB(255, 234, 234, 234),
                                fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return PopScope(
              canPop: false,
              onPopInvoked: (didPop) async {
                Navigator.pop(context, deliveryMethod);
              },
              child: SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Delivery Method',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RadioListTile<String>(
                        title: const Text('Delivery'),
                        value: 'Delivery',
                        groupValue: deliveryMethod,
                        onChanged: (value) {
                          setState(() {
                            deliveryMethod = value;
                            Navigator.pop(context, deliveryMethod);
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Meet'),
                        value: 'Meet',
                        groupValue: deliveryMethod,
                        onChanged: (value) {
                          setState(() {
                            deliveryMethod = value;
                            Navigator.pop(context, deliveryMethod);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        deliveryMethod = value;
      });
    });
  }

  void _showPaymentSelectBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return PopScope(
              canPop: false,
              onPopInvoked: (didPop) async {
                Navigator.pop(context, paymentMethod);
              },
              child: SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RadioListTile<String>(
                        title: const Text('Card'),
                        value: 'Card',
                        groupValue: paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value;
                            Navigator.pop(context, paymentMethod);
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Online Banking'),
                        value: 'Online Banking',
                        groupValue: paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value;
                            Navigator.pop(context, paymentMethod);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        paymentMethod = value;
      });
    });
  }
}
