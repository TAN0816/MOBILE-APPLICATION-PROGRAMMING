import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/model/cart_model.dart'; // Assuming you have a Book model

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: ListView.builder(
        itemCount: widget.selectedBooks.length,
        itemBuilder: (context, index) {
          final cartItem = widget.selectedBooks[index];
          final book = cartItem.getBook;
          return ListTile(
            title: Text(book.name),
            subtitle: Text('Price: RM${book.price.toStringAsFixed(2)}'),
            // You can add more details like author, quantity, etc.
            // Example: subtitle: Text('Price: RM${book.price.toStringAsFixed(2)} | Author: ${book.author}'),
            // onTap: () {
            //   // Handle tapping on a book tile if needed
            // },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedPaymentMethod,
                hint: Text('Select Payment Method'),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Credit Card',
                    child: Text('Credit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'PayPal',
                    child: Text('PayPal'),
                  ),
                  // Add more payment methods if needed
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement your checkout logic here
                  // For example, navigate to a confirmation page
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmationPage()));
                },
                child: Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
