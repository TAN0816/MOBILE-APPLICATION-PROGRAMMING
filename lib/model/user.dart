class UserModel {
  String username;
  String email;
  String phone;
  String address;
  String role;
  String image;

  UserModel(
      {required this.username,
      required this.email,
      required this.phone,
      required this.address,
      required this.role,
      required this.image});

  void setUsername(String newUsername) {
    username = newUsername;
  }

  void setEmail(String newEmail) {
    email = newEmail;
  }

  void setPhone(String newphone) {
    phone = newphone;
  }

  void setAddress(String newAddress) {
    address = newAddress;
  }

  String get getRole=>role;
  String get getUsername => username;
  String get getEmail => email;
  String get getPhone => phone;
  String get getAddress => address;
  String get getImage => image;
}
