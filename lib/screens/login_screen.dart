import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/main.dart';
import 'package:secondhand_book_selling_platform/screens/login_email_password_screen.dart';
import 'package:secondhand_book_selling_platform/screens/signup_email_password_screen.dart';
import 'package:secondhand_book_selling_platform/widgets/custom_button.dart';
import 'package:secondhand_book_selling_platform/services/firebase_auth_methods.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // logo
            Image.asset(
              "assets/logo.png",
              width: 260,
              height: 275,
            ),

            Text(
              "Let’s get started!",
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xff101522),
                height: 30 / 22,
              ),
              textAlign: TextAlign.center,
            ),

            Text(
              "Login to enjoy the features\nwe’ve provided!",
                style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff707784),
               
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

           Column(
              children: [
                Container(
                  width: 263,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Color(0xff4a56c1),
                  ),
                  child: CustomButton(
                    onTap: () {
                      Navigator.pushNamed(context, EmailPasswordLogin.routeName);
                    },
                    text: 'Login',
                    buttonColor: Color(0xff4a56c1) ,// Set to transparent to use the Container's color
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20), 
                // Add spacing between the buttons
                Container(
                  width: 263,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white,
                  ),
                  child: CustomButton(
                    onTap: () {
                      Navigator.pushNamed(context, EmailPasswordSignup.routeName);
                    },
                    text: 'Sign Up',
                     // Set to transparent to use the Container's color
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
 }
}
