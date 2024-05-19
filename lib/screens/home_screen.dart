// home_screen.dart
import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';
import 'package:secondhand_book_selling_platform/screens/sellerlist.dart';
import 'package:secondhand_book_selling_platform/screens/buyerlist.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String userId = '';
  String role = '';

  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    userId = UserService().getUserId;
    fetchUserData();
  }

  void fetchUserData() async {
    userId = UserService().getUserId;
    UserModel user = await userService.getUserData(userId);
    setState(() {
      role = user.getRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: role == 'Seller' ? const SellerList() : const BuyerList(),
    );
  }
}
