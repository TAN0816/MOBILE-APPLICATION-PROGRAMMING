import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/model/cart_model.dart';
import 'package:secondhand_book_selling_platform/services/cart_service.dart';
import 'package:secondhand_book_selling_platform/widgets/appbar_with_back.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool selectAll = false;
  double totalPrice = 0.0;
  Map<String, List<CartItem>> groupedItems = {};
  Map<String, bool> _itemSelections = {};
  final Map<String, bool> _sellerSelections = {};
  List<CartItem>? cartItems;

  @override
  void initState() {
    super.initState();

    fetchCartItems();
  }

  void fetchCartItems() async {
    List<CartItem> cart = await CartService().getCartList();
    setState(() {
      cartItems = cart;
      _itemSelections = {
        for (var item in cartItems!.map((item) => item.getBook.id)) item: false
      };

      groupItemsBySeller(cartItems!);
    });
  }

  void toggleSelectAll() {
    setState(() {
      if (selectAll) {
        groupedItems.forEach((key, value) {
          _sellerSelections[key] = true;

          for (var item in value) {
            _itemSelections[item.getBook.getId] = true;
          }
        });
      } else {
        groupedItems.forEach((key, value) {
          _sellerSelections[key] = false;
          for (var item in value) {
            _itemSelections[item.getBook.getId] = false;
          }
        });
      }
      calculateTotalPrice();
    });
  }

  void calculateTotalPrice() {
    setState(() {
      totalPrice = 0;
      _itemSelections.forEach((key, value) {
        if (value == true) {
          CartItem? selectedCartItem =
              cartItems!.firstWhere((item) => item.getBook.id == key);
          totalPrice += selectedCartItem.getBook.getPrice *
              selectedCartItem.getQuantity;
                }
      });
    });
  }

  void updateSelectAll() {
    setState(() {
      bool allItemsSelected = true;
      _itemSelections.forEach((key, value) {
        if (value == false) {
          allItemsSelected = false;
        }
      });
      selectAll = allItemsSelected;
    });
  }

  void groupItemsBySeller(List<CartItem> items) {
    Map<String, List<CartItem>> group = {};

    for (var item in items) {
      if (group.containsKey(item.getBook.sellerId)) {
        group[item.getBook.sellerId]!.add(item);
      } else {
        group[item.getBook.sellerId] = [item];
      }
    }

    groupedItems = group;
  }

  void updateSellerSelection(String sellerId) {
    setState(() {
      bool allItemsSelected = true;
      for (String itemId in _itemSelections.keys) {
        if (cartItems!
                .firstWhere((item) => item.getBook.id == itemId)
                .getBook
                .sellerId ==
            sellerId) {
          if (!_itemSelections[itemId]!) {
            allItemsSelected = false;
            break;
          }
        }
      }
      _sellerSelections[sellerId] = allItemsSelected;
    });
    updateSelectAll();
  }

  void selectSellerItems(String sellerId, bool selected) {
    setState(() {
      for (String itemId in _itemSelections.keys) {
        if (cartItems!
                .firstWhere((item) => item.getBook.id == itemId)
                .getBook
                .sellerId ==
            sellerId) {
          _itemSelections[itemId] = selected;
        }

        calculateTotalPrice();
      }
      _sellerSelections[sellerId] = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackBtn(
        title: 'Cart',
        actions: [
          IconButton(
              onPressed: () {
                context.go('/home/1');
              },
              icon: const Icon(Icons.message))
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 245, 245, 245),
              ),
              child: ListView.builder(
                itemCount: groupedItems.length,
                itemBuilder: (context, index) {
                  String sellerId = groupedItems.keys.elementAt(index);
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: _sellerSelections[sellerId] ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    selectSellerItems(sellerId, value!);
                                    updateSellerSelection(sellerId);
                                  });
                                }),
                            const CircleAvatar(
                              radius: 16,
                              backgroundImage:
                                  AssetImage('assets/images/profile.jpg'),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Seller Name",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        for (int i = 0; i < groupedItems[sellerId]!.length; i++)
                          Container(
                            height: 83,
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(children: [
                              Checkbox(
                                  value: _itemSelections[
                                          groupedItems[sellerId]![i]
                                              .getBook
                                              .getId] ??
                                      false,
                                  onChanged: (value) {
                                    setState(() {
                                      _itemSelections[groupedItems[sellerId]![i]
                                          .getBook
                                          .getId] = value!;
                                      calculateTotalPrice();
                                      updateSellerSelection(sellerId);
                                    });
                                  }),
                              //book img
                              const Image(
                                height: 80,
                                width: 80,
                                image: AssetImage('assets/images/book.jpg'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              groupedItems[sellerId]![i]
                                                  .getBook
                                                  .getName,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "RM${groupedItems[sellerId]![i].getBook.getPrice.toStringAsFixed(2)}"),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (groupedItems[sellerId]![i]
                                                          .getQuantity <=
                                                      1) {
                                                    showDeleteConfirmationDialog(
                                                        context, sellerId, i);
                                                  } else {
                                                    groupedItems[sellerId]![i]
                                                        .setQuantity(groupedItems[
                                                                    sellerId]![i]
                                                                .getQuantity -
                                                            1);
                                                  }
                                                  CartService().updateQuantity(
                                                      groupedItems[sellerId]![i]
                                                          .getBook
                                                          .getId,
                                                      groupedItems[sellerId]![i]
                                                          .getQuantity);
                                                  calculateTotalPrice();
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.remove_circle_outline),
                                            ),
                                            Text(
                                                "${groupedItems[sellerId]![i].getQuantity}"),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (groupedItems[sellerId]![
                                                                i]
                                                            .getQuantity >=
                                                        groupedItems[sellerId]![
                                                                i]
                                                            .getBook
                                                            .getQuantity) {
                                                      return;
                                                    } else {
                                                      groupedItems[sellerId]![i]
                                                          .setQuantity(groupedItems[
                                                                      sellerId]![i]
                                                                  .getQuantity +
                                                              1);
                                                    }
                                                    CartService().updateQuantity(
                                                      groupedItems[sellerId]![i]
                                                          .getBook
                                                          .getId,
                                                      groupedItems[sellerId]![i]
                                                          .getQuantity);
                                                    calculateTotalPrice();
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.add_circle_outline)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                  color: Color.fromARGB(255, 214, 214, 214),
                )),
                color: Colors.white,
              ),
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: selectAll,
                        onChanged: (value) {
                          setState(() {
                            selectAll = value!;
                          });
                          toggleSelectAll();
                        },
                      ),
                      const Text(
                        "All",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Total: ',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            "RM${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 217, 44, 32),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          // Add your checkout functionality here
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xff4a56c1),
                            padding: const EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                        child: const Text('Checkout',
                            style: TextStyle(
                                color: Color.fromARGB(255, 234, 234, 234),
                                fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, String sellerId, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to remove this item from the cart?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                setState(() {
                  CartItem removeItem = groupedItems[sellerId]![index];
                  cartItems!.remove(removeItem);
                  _itemSelections
                      .remove(removeItem.getBook.getId);
                  groupedItems[sellerId]!
                      .remove(removeItem);
                  CartService().deleteFormCart(removeItem.book.getId);
                  calculateTotalPrice();
                  updateSellerSelection(sellerId);
                  groupItemsBySeller(cartItems!);
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}