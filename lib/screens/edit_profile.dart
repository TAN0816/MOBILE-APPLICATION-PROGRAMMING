import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';
import '../widgets/profile_edit_option.dart';
import '../widgets/appbar_with_back.dart';

class EditProfile extends StatefulWidget {
  final String userId;

  const EditProfile({super.key, required this.userId});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final UserService userService = UserService();
  UserModel ?userData;
  String username = '';
  String mobile = '';
  String email = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    UserModel user = await userService.getUserData(widget.userId);
    setState(() {
      userData = user;
      username = user.getUsername;
      mobile = user.getMobile;
      email = user.getEmail;
      address = user.getAddress;
    });
  }

  void updateUserName(String username) {
    setState(() {
      this.username = username;
    });
  }

  void updateMobile(String mobile) {
    setState(() {
      this.mobile = mobile;
    });
  }

  void updateEmail(String email) {
    setState(() {
      this.email = email;
    });
  }

  void updateAddress(String address) {
    setState(() {
      this.address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackBtn(title: 'Edit Profile'),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: GestureDetector(
              onTap: () {
                // upload profile
                print('upload profile');
              },
              child: const Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
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
          ProfileEditOption(
            title: 'Full Name',
            placeholder: username,
            updateProfile: updateUserName,
          ),
          ProfileEditOption(
            title: 'Mobile',
            placeholder: mobile,
            updateProfile: updateMobile,
          ),
          ProfileEditOption(
            title: 'Email',
            placeholder: email,
            updateProfile: updateEmail,
          ),
          ProfileEditOption(
            title: 'Address',
            placeholder: address,
            updateProfile: updateAddress,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.fromLTRB(
                    20, 10, 20, 20), // Add margin to the bottom of the button
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff4a56c1),
                  ),
                  onPressed: () {
                    userService
                        .updateProfile(
                            widget.userId, username, mobile, email, address)
                        .then((_) {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Profile updated successfully')));
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Failed to update profile')));
                    });
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
