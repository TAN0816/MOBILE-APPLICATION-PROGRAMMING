import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon? prefixIcon; 
  final bool obscureText; // Make prefixIcon nullable

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixIcon, // Make prefixIcon nullable
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(0, 96, 92, 92), width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        filled: true,
        fillColor: const Color(0xffF5F6FA),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: prefixIcon, // Use the prefix icon here
      ),
    );
  }
}
