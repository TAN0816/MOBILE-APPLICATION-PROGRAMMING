import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/services/order_service.dart';

class UpdateOrderStatus extends StatefulWidget {
  final String orderId;

  const UpdateOrderStatus({super.key, required this.orderId});

  @override
  _UpdateOrderStatusState createState() => _UpdateOrderStatusState();
}

class _UpdateOrderStatusState extends State<UpdateOrderStatus> {
  int? _selectedStatus;
  bool _isStatusSelected = false;
  final OrderService _orderService = OrderService();

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
              const Expanded(
                child: Center(
                  child: Text(
                    'Update Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const Divider(),
          RadioListTile<int>(
            title: const Text('Preparing'),
            value: 1,
            groupValue: _selectedStatus,
            onChanged: (int? value) {
              setState(() {
                _selectedStatus = value;
                _isStatusSelected = true;
              });
            },
          ),
          RadioListTile<int>(
            title: const Text('Completed'),
            value: 2,
            groupValue: _selectedStatus,
            onChanged: (int? value) {
              setState(() {
                _selectedStatus = value;
                _isStatusSelected = true;
              });
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _isStatusSelected
                  ? () async {
                      // Call a method to update the order status
                      await updateOrderStatus(widget.orderId, _selectedStatus!);
                      // Show success dialog
                      showUpdateSuccessDialog(context);
                    }
                  : null,
              child: Container(
                width: 289,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xff4a56c1),
                ),
                child: const Center(
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

  void showUpdateSuccessDialog(BuildContext context) {
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
                      "Order Status Update Success",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Button to close the dialog
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName('sellerOrder'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4a56c1), // Set background color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Set border radius
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

  Future<void> updateOrderStatus(String orderId, int selectedStatus) async {
    String status = _getStatusText(selectedStatus);
    try {
      await _orderService.updateOrderStatus(orderId, status);
    } catch (e) {
      // Handle errors
      print('Error updating order status: $e');
      rethrow; // Rethrow the exception for handling
    }
  }

  String _getStatusText(int selectedStatus) {
    switch (selectedStatus) {
      case 1:
        return 'Preparing';
      case 2:
        return 'Completed';
      default:
        return 'Pending';
    }
  }
}
