import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/services/order_service.dart';

class UpdateOrderStatus extends StatefulWidget {
  final String orderId;

  const UpdateOrderStatus({Key? key, required this.orderId}) : super(key: key);

  @override
  _UpdateOrderStatusState createState() => _UpdateOrderStatusState();
}

class _UpdateOrderStatusState extends State<UpdateOrderStatus> {
  int? _selectedStatus;
  bool _isStatusSelected = false;
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
                    'Update Status',
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
            title: Text('Preparing'),
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
            title: Text('Completed'),
            value: 2,
            groupValue: _selectedStatus,
            onChanged: (int? value) {
              setState(() {
                _selectedStatus = value;
                _isStatusSelected = true;
              });
            },
          ),
          SizedBox(height: 16),
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

  void showUpdateSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF5F8FF),
                ),
                child: Center(
                  child: Icon(
                    Icons.done,
                    size: 48,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Center-aligned text
              Center(
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
              SizedBox(height: 30),
              // Button to close the dialog
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName('sellerOrder'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff4a56c1), // Set background color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Set border radius
                  ),
                ),
                child: SizedBox(
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
