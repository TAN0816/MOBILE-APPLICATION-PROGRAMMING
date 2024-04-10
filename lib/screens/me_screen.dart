import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_book_selling_platform/services/firebase_auth_methods.dart';
import 'package:secondhand_book_selling_platform/widgets/custom_button.dart';
import 'package:secondhand_book_selling_platform/widgets/custom_textfield.dart';
import 'package:secondhand_book_selling_platform/screens/login_screen.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
      body: Column(
        children: [
          if (!user.emailVerified && !user.isAnonymous)
            CustomButton(
              onTap: () {
                context
                    .read<FirebaseAuthMethods>()
                    .sendEmailVerification(context);
              },
              text: 'Verify Email',
            ),

          // CustomButton(
          //   onTap: () {
          //     context.read<FirebaseAuthMethods>().deleteAccount(context);
          //   },
          //   text: 'Delete Account',
          // ),
          // CustomButton(
          //   onTap: () {
          //     context.read<FirebaseAuthMethods>().signOut(context);
          //   },
          //   text: 'Sign Out',
          // ),
          // Text(user.uid),
          // Place the ElevatedButton at the top
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 600.0), // Adjust bottom padding as needed
              child: ElevatedButton(
                onPressed: () {
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
                                  Icons.logout_rounded,
                                  size: 48,
                                  color: Color(0xFF199A8E),
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            // Center-aligned text
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Are you sure to log out of your account?",
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff101522),
                                      height: 25 / 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            // Buttons
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await context
                                        .read<FirebaseAuthMethods>()
                                        .signOut(context);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen()),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Color(
                                          0xff4a56c1), // Set background color for logout button
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: 140,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: 140,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Color(0xFF00456B),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff4a56c1)),
                  fixedSize: MaterialStateProperty.all(
                      Size(300, 50)), // Set background color for the button
                ),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
