import 'package:secondhand_book_selling_platform/screens/home_page.dart';
import 'package:secondhand_book_selling_platform/services/firebase_auth_methods.dart';
import 'package:secondhand_book_selling_platform/widgets/custom_button.dart';
import 'package:secondhand_book_selling_platform/screens/home_screen.dart';
import 'package:secondhand_book_selling_platform/screens/notification_screen.dart';
import 'package:secondhand_book_selling_platform/screens/message_screen.dart';
import 'package:secondhand_book_selling_platform/screens/me_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/button_style.dart';

class Homepage extends StatefulWidget {
  static const String routeName = '/home';
  const Homepage({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<Homepage> {
  int _selectedIndex = 0; // Define _selectedIndex here
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    Widget _getBodyWidget(int index) {
      switch (index) {
        case 0:
          return HomeScreen();
        case 1:
          return NotificationScreen();
        case 2:
          return MessageScreen();
        case 3:
          return MeScreen();
        default:
          return HomeScreen(); // Default to HomeScreen if index is out of range
      }
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff4a56c1), // Selected item color
        unselectedItemColor: Colors.black, // Unselected item color
        onTap: _onItemTapped,
        backgroundColor: Colors.white, // Background color of the navigation bar
      ),
      body: _getBodyWidget(_selectedIndex),
    );
  }
}
