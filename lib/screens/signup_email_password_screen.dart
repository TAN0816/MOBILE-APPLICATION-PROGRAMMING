import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/services/firebase_auth_methods.dart';

class EmailPasswordSignup extends StatefulWidget {
  const EmailPasswordSignup({super.key});

  @override
  _EmailPasswordSignupState createState() => _EmailPasswordSignupState();
}

// Inside CustomTextField widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? errorMessage; // Add error message parameter

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.errorMessage, // Add error message parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorMessage, // Show error message
      ),
    );
  }
}

class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isBuyerSelected = false;
  bool isSellerSelected = false;
  bool isPasswordVisible = false;
  bool iscPasswordVisible = false;

  String? emailErrorMessage; // Error message for email field
  String? phoneErrorMessage;

  @override
  void initState() {
    super.initState();
    emailController.addListener(validateEmail); // Add listener for email field
    phoneController
        .addListener(validatePhoneNumber); // Add listener for phone field
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

// Regular expression pattern for validating email addresses
  static const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Function to validate email
  void validateEmail() {
    final regExp = RegExp(emailPattern);
    setState(() {
      if (!regExp.hasMatch(emailController.text)) {
        emailErrorMessage = 'Please enter a valid email address.';
      } else {
        emailErrorMessage = null;
      }
    });
  }

  // Function to validate phone number
  void validatePhoneNumber() {
    setState(() {
      if (!isValidMalaysianPhoneNumber(phoneController.text)) {
        phoneErrorMessage = 'Please enter a valid phone number.';
      } else {
        phoneErrorMessage = null;
      }
    });
  }

  void signUpUser() async {
    // Check if all fields are filled in
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        cpasswordController.text.isEmpty) {
      showErrorSnackBar('Please fill in all fields.');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Please fill in all fields.'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      return;
    }

    // Check if password matches
    if (passwordController.text != cpasswordController.text) {
      showErrorSnackBar('Passwords do not match.');
      return;
    }

    // Validate email format
    final regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(emailController.text)) {
      showErrorSnackBar('Please enter a valid email address.');
      return;
    }

    if (!isValidMalaysianPhoneNumber(phoneController.text)) {
      showErrorSnackBar('Please enter a valid phone number.');
      return;
    }

    String role =
        isBuyerSelected ? 'Buyer' : (isSellerSelected ? 'Seller' : '');
    FirebaseAuthMethods().signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      username: usernameController.text,
      phone: phoneController.text,
      role: role,
      context: context,
    );
  }

  // Function to validate Malaysian phone number format
  bool isValidMalaysianPhoneNumber(String phoneNumber) {
    // Malaysian phone numbers should start with 0 and have 10 digits
    return phoneNumber.startsWith('0') && phoneNumber.length == 10;
  }

  // Function to display error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Select a role:",
                  style: TextStyle(
                    color: Color(0xff4a56c1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isBuyerSelected = !isBuyerSelected;
                        if (isBuyerSelected) {
                          isSellerSelected = false;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => isBuyerSelected
                              ? const Color.fromARGB(255, 98, 104, 211)
                              : const Color.fromARGB(255, 133, 150, 163)),
                      minimumSize: MaterialStateProperty.all(
                        const Size(150, 50),
                      ),
                    ),
                    child: const Text(
                      "Buyer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSellerSelected = !isSellerSelected;
                        if (isSellerSelected) {
                          isBuyerSelected = false;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => isSellerSelected
                              ? const Color.fromARGB(255, 98, 104, 211)
                              : const Color.fromARGB(255, 133, 150, 163)),
                      minimumSize: MaterialStateProperty.all(
                        const Size(150, 50),
                      ),
                    ),
                    child: const Text(
                      "Seller",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                height: 63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      controller: usernameController,
                      hintText: 'Username',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                height: 63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      errorMessage: emailErrorMessage,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                height: 63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Phone Number',
                      errorMessage: phoneErrorMessage,
                    ),
                  ],
                ),
              ),

              // CustomTextField(
              //   controller: phoneController,
              //   hintText: 'Phone Number',
              //   errorMessage: phoneErrorMessage, // Pass error message
              // ),
              const SizedBox(height: 20),
              Container(
                height: 63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Enter your password',
                      // prefixIcon: Icon(Icons.lock),
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
              const SizedBox(height: 20),
              Container(
                height: 63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      controller: cpasswordController,
                      hintText: 'Confirm password',
                      // prefixIcon: Icon(Icons.lock),
                      obscureText: !iscPasswordVisible,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          iscPasswordVisible = !iscPasswordVisible;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          iscPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      context.push('/login');
                    },
                    child: const Text(
                      'Login in Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: signUpUser,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff4a56c1)),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width / 2.5, 50),
                  ),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
