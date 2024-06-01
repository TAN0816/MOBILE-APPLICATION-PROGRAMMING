import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/model/order.dart';
import 'package:secondhand_book_selling_platform/services/order_service.dart';

class CancelOrderForm extends StatefulWidget {
  final String orderId;

  const CancelOrderForm({required this.orderId});

  @override
  _CancelOrderFormState createState() => _CancelOrderFormState();
}

class _CancelOrderFormState extends State<CancelOrderForm> {
  int? _selectedReason;
  bool _isReasonSelected = false;
  OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Select the Cancellation Reason',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Divider(),
          RadioListTile<int>(
            title: Text('Need to change delivery address'),
            value: 1,
            groupValue: _selectedReason,
            onChanged: (int? value) {
              setState(() {
                _selectedReason = value;
                _isReasonSelected = true;
              });
            },
          ),
          RadioListTile<int>(
            title: Text('Modify existing order (quantity, etc.)'),
            value: 2,
            groupValue: _selectedReason,
            onChanged: (int? value) {
              setState(() {
                _selectedReason = value;
                _isReasonSelected = true;
              });
            },
          ),
          RadioListTile<int>(
            title: Text('Seller is not responsive to my inquiries'),
            value: 3,
            groupValue: _selectedReason,
            onChanged: (int? value) {
              setState(() {
                _selectedReason = value;
                _isReasonSelected = true;
              });
            },
          ),
          RadioListTile<int>(
            title: Text('Others'),
            value: 4,
            groupValue: _selectedReason,
            onChanged: (int? value) {
              setState(() {
                _selectedReason = value;
                _isReasonSelected = true;
              });
            },
          ),
          SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _isReasonSelected
                  ? () async {
                      // Call a method to cancel the order and store the reason
                      await _updateOrderStatusAndReasons(
                          widget.orderId, _selectedReason!);
                      showCancelSuccessDialog(context);
                    }
                  : null,
              child: Container(
                width: 289,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xff4a56c1),
                ),
                child: Center(
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCancelSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF5F8FF),
                ),
                child: const Center(
                  child: Icon(
                    Icons.done,
                    size: 48,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Center-aligned text
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Order Success Cancelled",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10), // Add spacing between texts
                    Text(
                      "Your order has been successfully cancelled. If you have any further questions or concerns, feel free to reach out to us. Thank you!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Button to close the dialog
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go('/home');
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xff4a56c1), // Set background color
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25.0), // Set border radius
                    ),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white), // Set text color
                  ),
                ),
                child: const SizedBox(
                  width: 150,
                  height: 55,
                  child: Center(
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateOrderStatusAndReasons(
      String orderId, int selectedReason) async {
    String status = 'CANCELLED'; // Set the status to 'Cancelled'
    String reason = _getReasonText(
        selectedReason); // Get the reason text based on the selected reason
    try {
      await _orderService.updateOrderStatusAndReasons(orderId, status, reason);
    } catch (e) {
      // Handle errors
      print('Error updating order status and reasons: $e');
      rethrow; // Rethrow the exception for handling
    }
  }

  String _getReasonText(int selectedReason) {
    switch (selectedReason) {
      case 1:
        return 'Need to change delivery address';
      case 2:
        return 'Modify existing order (quantity, etc.)';
      case 3:
        return 'Seller is not responsive to my inquiries';
      case 4:
        return 'Others';
      default:
        return 'Unknown reason';
    }
  }
}
