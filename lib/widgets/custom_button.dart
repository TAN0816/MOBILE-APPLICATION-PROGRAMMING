import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Color? buttonColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      // Wrap the ElevatedButton with Center
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize:
              const Size(double.infinity - 10, 50), // Adjust width here
          backgroundColor: buttonColor,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
