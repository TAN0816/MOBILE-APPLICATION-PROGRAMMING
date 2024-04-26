import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
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
  UserService userService = UserService();
  UserModel? userData;
  String username = '';
  String mobile = '';
  String email = '';
  String address = '';
  String imageUrl = '';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // fetchUserData();
    userService = Provider.of<UserService>(context, listen: false);

    userData = userService.getUser;
    if (userData == null) {
      fetchUserData();
    } else {
      username = userData!.username;
      mobile = userData!.mobile;
      email = userData!.email;
      address = userData!.address;
      imageUrl = userData?.image ?? '';
    }
  }

  void fetchUserData() async {
    UserModel user = await userService.getUserData(widget.userId);
    setState(() {
      userData = user;
      username = user.getUsername;
      mobile = user.getMobile;
      email = user.getEmail;
      address = user.getAddress;
      imageUrl = user.getImage;
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

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : imageUrl != ""
                            ? NetworkImage(imageUrl) as ImageProvider
                            : const AssetImage('assets/images/profile.jpg'),
                  ),
                  const Positioned(
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
                    ),
                  ),
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
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevent user from dismissing the dialog
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    if (_imageFile != null) {
                      final storageRef = FirebaseStorage.instance
                          .ref()
                          .child('profile_images')
                          .child('${widget.userId}.jpg');
                      await storageRef.putFile(_imageFile!);
                      imageUrl = await storageRef.getDownloadURL();
                    }

                    userService
                        .updateProfile(widget.userId, username, mobile, email,
                            address, imageUrl)
                        .then((_) {
                      context.pop();
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Profile updated successfully')));
                    }).catchError((error) {
                      context.pop();
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
