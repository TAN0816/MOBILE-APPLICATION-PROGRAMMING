import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/utils/showOTPDialog.dart';
import 'package:secondhand_book_selling_platform/utils/showSnackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/screens/login_screen.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuthMethods();

  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String role,
    required BuildContext context,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID
      String userId = userCredential.user!.uid;

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'phone': phone,
        'role': role,
        // Add more fields as needed
      });

// Show a pop-up dialog indicating successful registration
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Registration Successful'),
//             content: Text('You have successfully registered.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context)
//                       .push(MaterialPageRoute(builder: (context) {
//                     return const EmailPasswordLogin();
//                   }));
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );

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
                        "Registration Successful",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10), // Add spacing between texts
                      Text(
                        "You have successfully registered.",
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
                  // onPressed: () {
                  //   // Navigate to the home screen
                  //   context.go('/home');
                  // },

                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const EmailPasswordLogin();
                    }));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xff4a56c1), // Set background color
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
                    width: 150,
                    height: 55,
                    child: Center(
                      child: Text(
                        "Go to Login",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      // Handle sign-up errors
      print('Sign up error: $e');
      // Show error message to the user
      String errorMessage =
          'An error occurred during sign-up. Please try again.';
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          errorMessage =
              'The email address is already in use by another account.';
        } else {
          errorMessage = e.message ?? errorMessage;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red, // Set the background color to red
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  // GOOGLE SIGN IN
  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     if (kIsWeb) {
  //       GoogleAuthProvider googleProvider = GoogleAuthProvider();

  //       googleProvider
  //           .addScope('https://www.googleapis.com/auth/contacts.readonly');

  //       await _auth.signInWithPopup(googleProvider);
  //     } else {
  //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //       final GoogleSignInAuthentication? googleAuth =
  //           await googleUser?.authentication;

  //       if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
  //         // Create a new credential
  //         final credential = GoogleAuthProvider.credential(
  //           accessToken: googleAuth?.accessToken,
  //           idToken: googleAuth?.idToken,
  //         );
  //         UserCredential userCredential =
  //             await _auth.signInWithCredential(credential);

  //         // if you want to do specific task like storing information in firestore
  //         // only for new users using google sign in (since there are no two options
  //         // for google sign in and google sign up, only one as of now),
  //         // do the following:

  //         // if (userCredential.user != null) {
  //         //   if (userCredential.additionalUserInfo!.isNewUser) {}
  //         // }
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message!); // Displaying the error message
  //   }
  // }

  // ANONYMOUS SIGN IN
  Future<void> signInAnonymously(BuildContext context) async {
    try {
      await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // FACEBOOK SIGN IN
  // Future<void> signInWithFacebook(BuildContext context) async {
  //   try {
  //     final LoginResult loginResult = await FacebookAuth.instance.login();

  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //     await _auth.signInWithCredential(facebookAuthCredential);
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message!); // Displaying the error message
  //   }
  // }

  // PHONE SIGN IN
  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      // !!! Works only on web !!!
      ConfirmationResult result =
          await _auth.signInWithPhoneNumber(phoneNumber);

      // Diplay Dialog Box To accept OTP
      showOTPDialog(
        codeController: codeController,
        context: context,
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );

          await _auth.signInWithCredential(credential);
          Navigator.of(context).pop(); // Remove the dialog box
        },
      );
    } else {
      // FOR ANDROID, IOS
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //  Automatic handling of the SMS code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // !!! works only on android !!!
          await _auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          showSnackBar(context, e.message!);
        },
        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          showOTPDialog(
            codeController: codeController,
            context: context,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: codeController.text.trim(),
              );

              // !!! Works only on Android, iOS !!!
              await _auth.signInWithCredential(credential);
              Navigator.of(context).pop(); // Remove the dialog box
            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

  //Forget Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      throw error;
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }

  void signInWithGoogle(BuildContext context) {}

  void signInWithFacebook(BuildContext context) {}
}