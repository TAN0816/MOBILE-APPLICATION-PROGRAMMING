import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/profile_edit_option.dart';
import '../widgets/appbar_with_back.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final onPressed = () => {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackBtn(title: 'Edit Profile'),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: GestureDetector(
              onTap: () {
                // upload profile
                print('upload profile');
              },
              child: const Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    // backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(95, 30, 16, 121),
                        radius: 20,
                        child: Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 243, 245, 255),
                          size: 24,
                        ),
                      )),
                ],
              ),
            ),
          ),
          ProfileEditOption(title: 'Full Name', placeholder: 'User1'),
          ProfileEditOption(title: 'Mobile', placeholder: '012345678'),
          ProfileEditOption(title: 'Email', placeholder: 'user1@gmail.com'),
          ProfileEditOption(title: 'Address', placeholder: '123, abcStreet'),
        ],
      ),
    );
  }
}
