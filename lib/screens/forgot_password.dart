import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:secondhand_book_selling_platform/services/firebase_auth_methods.dart';
// import 'package:secondhand_book_selling_platform/services/user_service.dart';
import 'package:secondhand_book_selling_platform/widgets/custom_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Success'),
            );
          });
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       content: Text('Password reset link sent! Check your email'),
      //     );
      //   },
      // );
    } on FirebaseAuthException catch (e) {
      print(e);
      print('Firebase Auth Error: ${e.code}');
      print('Firebase Auth Error Message: ${e.message}');
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('The email is not registered or is invalid.'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('An error occurred: ${e.message}'),
            );
          },
        );
        //}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 25.0),
          //   child: Text(
          //     "Forgot Password",
          //     textAlign: TextAlign.left,
          //     style: TextStyle(fontSize: 20),
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 40), // Add padding for better visual alignment
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff272727),
                  height: 90 / 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 63,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xfff4f4f4),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: passwordReset,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xff4a56c1)),
              textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
            child: const Text(
              "Continue",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
