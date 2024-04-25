import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_book_selling_platform/services/firebase_auth_methods.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = '1234';
    const sellerRating = 4;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500, // Set the font weight to bold
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 214, 214, 214),
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          ),
          const Text(
            'Evelyn Lim Olivia',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: sellerRating > index ? Colors.amber[400] : Colors.grey,
                );
              }),
            ),
          ),
          TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                context.push('/edit_profile/1');
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 20.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 211, 211, 211),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My orders',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Already have 12 orders',
                          style: TextStyle(
                            color: Color.fromARGB(100, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              )),
          TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                context.push('/edit_profile/1');
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 20.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 211, 211, 211),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order History',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '15 orders had made',
                          style: TextStyle(
                            color: Color.fromARGB(100, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              )),
          TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                context.push('/edit_profile/$userId');
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 20.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 211, 211, 211),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Edit your personal information',
                          style: TextStyle(
                            color: Color.fromARGB(100, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              )),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 100.0), // Adjust bottom padding as needed
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 40),
                            Container(
                              width: 90,
                              height: 90,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF5F8FF),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.logout_rounded,
                                  size: 48,
                                  color: Color(0xFF199A8E),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Center-aligned text
                            const Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Are you sure to log out of your account?",
                                    style: TextStyle(
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
                            const SizedBox(height: 30),
                            // Buttons
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<FirebaseAuthMethods>()
                                        .signOut(context);

                                    if (!context.mounted) return;
                                    context.pop(context);
                                    context.go('/');
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color(
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
                                  child: const SizedBox(
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
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    context.pop(context); // Close the dialog
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
                                  child: const SizedBox(
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
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff4a56c1)),
                  fixedSize: MaterialStateProperty.all(
                      Size(300, 50)), // Set background color for the button
                ),
                child: const Text(
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
