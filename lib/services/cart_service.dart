import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondhand_book_selling_platform/model/cart_model.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';

class CartService {
  List<CartItem> cartList = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;

  CartService();

  // List<CartItem> get getCartList => cartList;
  Future<void> addtoCart(String pid) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await FirebaseFirestore.instance.collection('cart').doc(userId).get();

    if (docSnapshot.exists) {
      Map<String, dynamic> cartData = docSnapshot.data()!;
      var cartList = cartData['cartList'] as List<dynamic>;

      bool itemExists = false;
      for (var item in cartList) {
        if (item['bookId'] == pid) {
          // item['quantity'] += 1;
          itemExists = true;
          break;
        }
      }

      if (!itemExists) {
        cartList.add({
          'bookId': pid,
          'quantity': 1,
        });
      }

      await FirebaseFirestore.instance.collection('cart').doc(userId).update({
        'cartList': cartList,
      });
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(userId).set({
        'cartList': [
          {
            'bookId': pid,
            'quantity': 1,
          },
        ]
      });
    }
  }

  Future<void> updateQuantity(String pid, int newQuantity) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await FirebaseFirestore.instance.collection('cart').doc(userId).get();

    if (!docSnapshot.exists) {
      print("Document does not exist");
      return;
    }

    List<dynamic> cartList = docSnapshot.get('cartList');

    int itemIndex = cartList.indexWhere((item) => item['bookId'] == pid);

    if (itemIndex != -1) {
      // Item found, update the quantity
      cartList[itemIndex]['quantity'] = newQuantity;
    } else {
      // Item not found, add new item
      cartList.add({
        'bookId': pid,
        'quantity': newQuantity,
      });
    }

    await FirebaseFirestore.instance.collection('cart').doc(userId).update({
      'cartList': cartList,
    });
  }

  Future<void> deleteFormCart(String pid) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await FirebaseFirestore.instance.collection('cart').doc(userId).get();

    if (!docSnapshot.exists) {
      print("Document does not exist");
      return;
    }

    List<dynamic> cartList = docSnapshot.get('cartList');

    cartList.removeWhere((item) => item['bookId'] == pid);

    await FirebaseFirestore.instance.collection('cart').doc(userId).update({
      'cartList': cartList,
    });
  }

  Future<List<CartItem>> getCartList() async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await FirebaseFirestore.instance.collection('cart').doc(userId).get();

    List<CartItem> cartItemList = [];
    bool cartUpdated = false;

    if (docSnapshot.exists) {
      Map<String, dynamic> cartData = docSnapshot.data()!;
      var cartList = cartData['cartList'];
      List<Map<String, dynamic>> updatedCartList = [];
      for (var cartItemData in cartList) {
        DocumentSnapshot<Map<String, dynamic>> bookSnapshot =
            await FirebaseFirestore.instance
                .collection('books')
                .doc(cartItemData['bookId'])
                .get();
        if (bookSnapshot.exists) {
          Map<String, dynamic> bookData = bookSnapshot.data()!;
          Book book = Book(
            id: bookSnapshot.id,
            sellerId: bookData['sellerId'] ?? '',
            name: bookData['name'] ?? 'Unknown Title',
            price: (bookData['price'] as num?)?.toDouble() ?? 0.0,
            quantity: bookData['quantity'] ?? 0,
            images: List<String>.from(bookData['images'] ?? []),
            year: bookData['year'] ?? 'Unknown Year',
            course: bookData['course'] ?? 'Unknown Course',
            detail: bookData['detail'] ?? 'No details available',
          );

          CartItem cartItem = CartItem(
            book: book,
            quantity: cartItemData['quantity'],
          );

          cartItemList.add(cartItem);
          updatedCartList.add(cartItemData);
        } else {
          cartUpdated = true;
        }
      }
      if (cartUpdated) {
        await FirebaseFirestore.instance.collection('cart').doc(userId).update({
          'cartList': updatedCartList,
        });
      }
    }
    return cartItemList;
  }

  Future<UserModel> getSellerData(String sellerId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(sellerId)
        .get();

    Map<String, dynamic> userData = docSnapshot.data()!;
    UserModel seller = UserModel(
      username: userData['username'],
      email: userData['email'],
      phone: userData['phone'],
      address: userData['address'] ?? "",
      role: userData['role'],
      image: userData['image'] ?? "",
    );

    return seller;
  }

  Future<Map<String, UserModel>> fetchSellers(Set<String> sellerIds) async {
    Map<String, UserModel> sellers = {};
    for (var sellerId in sellerIds) {
      if (sellerId == "") {
        sellers['others'] = UserModel(
          username: "",
          email: "",
          phone: "",
          address: "",
          role: "",
          image: "",
        );
      } else {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(sellerId)
                .get();
        Map<String, dynamic> sellerData = docSnapshot.data()!;
        UserModel seller = UserModel(
          username: sellerData['username'],
          email: sellerData['email'],
          phone: sellerData['phone'],
          address: sellerData['address'] ?? "",
          role: sellerData['role'],
          image: sellerData['image'] ?? "",
        );
        sellers[sellerId] = seller;
      }
    }
    return sellers;
  }
}
