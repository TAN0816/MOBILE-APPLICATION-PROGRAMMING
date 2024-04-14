import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/screens/home_screen.dart';
import 'package:secondhand_book_selling_platform/screens/notification_screen.dart';
import 'package:secondhand_book_selling_platform/screens/message_screen.dart';
import 'package:secondhand_book_selling_platform/screens/me_screen.dart';
import 'package:secondhand_book_selling_platform/screens/edit_profile.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/notification',
        builder: (context, state) => const NotificationScreen(),
        // routes: [
        //   GoRoute(
        //     path: 'cart',
        //     builder: (context, state) => const MyCart(),
        //   ),
        // ],
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
        path: '/edit_profile/:id',
        builder: (context, state) => const MeScreen(),
      ),
      //GoRoute(path: 'cart', builder: (context, state) => const Cart())
    ],
  );
}
