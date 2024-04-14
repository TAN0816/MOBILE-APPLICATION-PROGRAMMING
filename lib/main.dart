import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondhand_book_selling_platform/firebase_options.dart';
import 'package:secondhand_book_selling_platform/routes/app_routes.dart';
import 'package:secondhand_book_selling_platform/screens/home_page.dart';
import 'package:secondhand_book_selling_platform/screens/login_email_password_screen.dart';
import 'package:secondhand_book_selling_platform/screens/login_screen.dart';
import 'package:secondhand_book_selling_platform/screens/edit_profile.dart';
import 'package:secondhand_book_selling_platform/screens/signup_email_password_screen.dart';
import 'package:secondhand_book_selling_platform/services/firebase_auth_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp.router(
        title: 'SBS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const AuthWrapper(),
        // routes: {
        //   '/signup-email-password': (context) => const EmailPasswordSignup(),
        //   '/login-email-password': (context) => const EmailPasswordLogin(),
        //   '/home': (context) => const Homepage(),
        //   '/edit-profile':(context) => EditProfile(),
        // },
        routerConfig: router(),
      ),
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User?>();

//     if (firebaseUser != null) {
//       return const Homepage();
//     }
//     return const MainScreen();
//   }
// }


// class FirebaseAuthMethods {
//   final FirebaseAuth _firebaseAuth;

//   FirebaseAuthMethods(this._firebaseAuth);

//   // Method to sign out the user
//   Future<void> signOut(BuildContext context) async {
//     try {
//       await _firebaseAuth.signOut();
//     } catch (e) {
//       // Handle sign-out errors here
//       print('Sign-out failed: $e');
//     }
//   }

  // Other authentication methods...
// }

