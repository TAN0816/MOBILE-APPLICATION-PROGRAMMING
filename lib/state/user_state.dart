import 'package:flutter/foundation.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class UserState extends ChangeNotifier {
  UserState() {
    getUserData(userService.getUserId);
  }

  UserModel? userState;
  UserService userService = UserService();
  List<String> _searchHistory = [];
  UserModel? get getUserState => userState;
  List<String> get searchHistory => _searchHistory;

  Future<void> updateProfile(String userId, String username, String email,
      String phone, String address, String imageUrl) async {
    userService.updateProfile(
        userId, username, email, phone, address, imageUrl);

    userState = await userService.getUserData(userId);
    notifyListeners();
  }

  Future<void> getUserData(String userId) async {
    userState = await userService.getUserData(userId);
    notifyListeners();
  }
  void addSearchQuery(String query) {
    _searchHistory.insert(0, query);
    notifyListeners();
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }
}
