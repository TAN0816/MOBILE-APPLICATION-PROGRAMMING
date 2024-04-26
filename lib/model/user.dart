import 'package:flutter/material.dart';

class UserModel{
  String username;
  String email;
  String mobile;
  String address;
  String? role;
 
  UserModel({required this.username, required this.email, required this.mobile, required this.address});

  void setUsername(String newUsername) {
    username = newUsername;
  }

  void setEmail(String newEmail) {
    email = newEmail;
  }
  void setMobile(String newmobile) {
    mobile = newmobile;
  }
  void setAddress(String newAddress) {
    address = newAddress;
  }

  String get getUsername => username;
  String get getEmail => email;
  String get getMobile => mobile;
  String get getAddress => address;

}
