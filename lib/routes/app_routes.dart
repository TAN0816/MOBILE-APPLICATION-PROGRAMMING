import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_book_selling_platform/screens/cart/cart_screen.dart';
import 'package:secondhand_book_selling_platform/screens/forgot_password.dart';
import 'package:secondhand_book_selling_platform/screens/home_page.dart';
import 'package:secondhand_book_selling_platform/screens/login_email_password_screen.dart';
import 'package:secondhand_book_selling_platform/screens/login_screen.dart';
import 'package:secondhand_book_selling_platform/screens/notification_screen.dart';
import 'package:secondhand_book_selling_platform/screens/message_screen.dart';
import 'package:secondhand_book_selling_platform/screens/me_screen.dart';
import 'package:secondhand_book_selling_platform/screens/edit_profile.dart';
import 'package:secondhand_book_selling_platform/screens/signup_email_password_screen.dart';
import 'package:secondhand_book_selling_platform/screens/reset.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          final firebaseUser = context.watch<User?>();
          if (firebaseUser != null) {
            return const Homepage();
          }
          return const MainScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const EmailPasswordLogin(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const EmailPasswordSignup(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            const Homepage(), // Handle route without tab parameter
      ),
      GoRoute(
          path: '/home/:tab',
          // builder: (context, state) => const Homepage(),
          builder: (context, state) {
            String? tab = state.pathParameters['tab'];
            print(tab);
            int index = 0;
            if (tab != null) {
              index = int.tryParse(tab) ?? 0;
            }
            return Homepage(bottomIndex: index);
          }),
      GoRoute(
        path: '/notification',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessageScreen(),
      ),
      GoRoute(
        path: '/me',
        builder: (context, state) => const MeScreen(),
      ),
      GoRoute(
        path: '/resetscreen',
        builder: (context, state) => const DetailsScreen(),
      ),
      GoRoute(
        path: '/edit_profile/:userId',
        builder: (context, state) {
          final String? userId = state.pathParameters['userId'];
          return EditProfile(userId: userId!);
        },
      ),
      GoRoute(
        path: '/forgot_password',
        builder: (context, state) => const ForgotPassword(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => CartScreen(),
      )
    ],
  );
}
