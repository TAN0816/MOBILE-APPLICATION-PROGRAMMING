import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  String _username = 'User Name';
  String _email = 'exp@gmail.com';
  String _phone = '012345678';
  String _address = '123, abc street';

  String get username => _username;

  void setUsername(String newUsername) {
    _username = newUsername;
    notifyListeners(); // Notify listeners of state change
  }
}
