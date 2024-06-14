import 'package:secondhand_book_selling_platform/screens/home_screen.dart';
import 'package:secondhand_book_selling_platform/screens/notification_screen.dart';
import 'package:secondhand_book_selling_platform/screens/message_screen.dart';
import 'package:secondhand_book_selling_platform/screens/me_screen.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final int bottomIndex;
  const Homepage({super.key, this.bottomIndex = 0});

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
  void initState() {
    super.initState();
    _selectedIndex = widget.bottomIndex;
  }

  @override
  Widget build(BuildContext context) {
    Widget getBodyWidget(int index) {
      switch (index) {
        case 0:
          return const HomeScreen();
        case 1:
          return const NotificationScreen();
        case 2:
          return const MessageScreen(orderId: "51eYXmaIFJlk1bcwLgRv",);
        case 3:
          return const MeScreen();

        default:
          return const HomeScreen(); // Default to HomeScreen if index is out of range
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
      body: getBodyWidget(_selectedIndex),
    );
  }
}
