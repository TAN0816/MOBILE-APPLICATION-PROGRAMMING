import 'package:flutter/foundation.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class UserState extends ChangeNotifier {
  UserState() {
    getUserData(userService.getUserId);
  }

  UserModel? userState;
  UserService userService = UserService();
  final List<String> _searchHistory = [];
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
  // Convert query to lowercase for case-insensitive comparison
  String queryLower = query.toLowerCase();

  // Check if the query already exists in the search history (case-insensitive)
  int existingIndex = _searchHistory.indexWhere((history) => history.toLowerCase() == queryLower);

  if (existingIndex != -1) {
    // If query exists, remove it from the current position
    _searchHistory.removeAt(existingIndex);
  }

  // Insert the query at the beginning of the list
  _searchHistory.insert(0, query);

  // Ensure the search history does not exceed 5 entries
  if (_searchHistory.length > 5) {
    _searchHistory.removeLast(); // Remove the oldest entry
  }

  notifyListeners();
}




  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }
}
