import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secondhand_book_selling_platform/screens/home_page.dart';

class EmailPasswordLogin extends StatefulWidget {
  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Authenticate user with email and password using FirebaseAuth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If authentication succeeds, return true
      return true;
    } catch (error) {
      // If authentication fails, show an error dialog
      showErrorDialog(context);
      // Return false to indicate login failure
      return false;
    }
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid email or password. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Align children to the start (left) horizontally
        children: [
          const SizedBox(height: 80),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 30), // Add padding for better visual alignment
            child: Text(
              "Sign in",
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xff272727),
                height: 90 / 32,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 63,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xfff4f4f4),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 63,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xfff4f4f4),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock),
                  obscureText: !isPasswordVisible,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // forgot password?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle password reset action
                  },
                  child: const Row(
                    children: [
                      Text(
                        "Forgot your password?",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff222222),
                          height: 20 / 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                bool loginSuccess = await loginUser(
                  email: emailController.text,
                  password: passwordController.text,
                  context: context,
                );
                if (loginSuccess) {
                  // Show popup message
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
                                    "Yeay! Welcome Back",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                      height: 10), // Add spacing between texts
                                  Text(
                                    "Once again you logged in successfully into SBS app.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Button to navigate to the home screen
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to the home screen
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Color(0xff4a56c1), // Set background color
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Set border radius
                                  ),
                                ),
                                textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      color: Colors.white), // Set text color
                                ),
                              ),
                              child: const SizedBox(
                                width: 150,
                                height: 55,
                                child: Center(
                                  child: Text(
                                    "Go to Home",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
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
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color(0xff4a56c1), // Set background color
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Set border radius
                  ),
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white), // Set text color
                ),
              ),
              child: const SizedBox(
                width: 290,
                height: 50,
                child: Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Center(
          //   child: Text(
          //     "Or login with social account",
          //     style: const TextStyle(
          //       fontFamily: "Roboto",
          //       fontSize: 14,
          //       fontWeight: FontWeight.w500,
          //       color: Color(0xff222222),
          //       height: 20 / 14,
          //     ),
          //     textAlign: TextAlign.center, // Align text center
          //   ),
          // ),

          const SizedBox(height: 40),

          // Center(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Container(
          //         width: 92,
          //         height: 64,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(24),
          //           color: Colors.white,
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey.withOpacity(0.5),
          //               spreadRadius: 2,
          //               blurRadius: 5,
          //               offset: Offset(0, 3),
          //             ),
          //           ],
          //         ),
          //         child: InkWell(
          //           onTap: signInWithGoogle,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Image.asset(
          //                 'assets/Google.png', // Assuming you have the Google logo asset
          //                 width: 24,
          //                 height: 24,
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 40),
          //       Container(
          //         width: 92,
          //         height: 64,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(24),
          //           color: Colors.white,
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey.withOpacity(0.5),
          //               spreadRadius: 2,
          //               blurRadius: 5,
          //               offset: Offset(0, 3),
          //             ),
          //           ],
          //         ),
          //         child: InkWell(
          //           onTap: () {
          //             // Handle Facebook sign-in
          //           },
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Image.asset(
          //                 'assets/facebook_logo.png', // Assuming you have the Facebook logo asset
          //                 width: 24,
          //                 height: 24,
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup-email-password');
                },
                child: const Text(
                  'Sign Up Now',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ), // Adjust as needed
              ),
            ],
          )
        ],
      ),
    );
  }
}
