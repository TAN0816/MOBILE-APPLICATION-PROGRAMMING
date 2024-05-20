import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/model/cart_model.dart';
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

  @override
  void initState() {
    super.initState();
    for (CartItem c in widget.selectedBooks) {
      setState(() {
        totalPrice += c.book.getPrice * c.getQuantity;
        print(totalPrice);
      });
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
          ListView.builder(
            itemCount: widget.selectedBookIds.length,
            itemBuilder: (context, index) {
              final cartItem = widget.selectedBooks[index];
              final book = cartItem.getBook;
              return Container(
                height: 100,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  // borderRadius: BorderRadius.circular(16),
                ),
                child: Row(children: [
                  //book img
                  Image(
                    height: 80,
                    width: 80,
                    image: book.images != null && book.images != ""
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("RM${book.getPrice.toStringAsFixed(2)}"),
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
                  Row(
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
                        onPressed: () {},
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
}
