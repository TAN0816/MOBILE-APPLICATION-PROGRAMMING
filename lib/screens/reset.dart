import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/screens/login_screen.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Add padding around the Column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/preview.jpg',
              width: 250, // Adjust width as needed
              height: 250, // Adjust height as needed
            ),
            const SizedBox(height: 20),
            Text(
              "We Sent you an Email to reset your password.",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 30 / 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailPasswordLogin()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff4a56c1)),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(100, 50), // Adjust the width as needed
                ),
              ),
              child: const Text(
                "Return to Login",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
