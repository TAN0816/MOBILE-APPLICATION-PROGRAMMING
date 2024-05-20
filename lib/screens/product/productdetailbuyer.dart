import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/model/user.dart';
import 'package:secondhand_book_selling_platform/services/book_service.dart';
import 'package:secondhand_book_selling_platform/services/cart_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailBuyer extends StatefulWidget {
  final String bookId;
  const ProductDetailBuyer({super.key, required this.bookId});

  @override
  _ProductDetailBuyerState createState() => _ProductDetailBuyerState();
}

class _ProductDetailBuyerState extends State<ProductDetailBuyer> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final BookService _bookService = BookService();
  final CartService _cartService = CartService();

  Book? _book;
  UserModel? _seller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    _fetchBookDetails();
  }

  Future<void> _fetchBookDetails() async {
    Book? book = await _bookService.getBookById(widget.bookId);
    setState(() {
      _book = book;
      _isLoading = false;
    });

    if (_book != null) {
      UserModel? seller = await _bookService.getSellerData(_book!.sellerId);
      setState(() {
        _seller = seller;
      });
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: const Color.fromARGB(244, 255, 255, 255),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          'Product Detail',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500, // Set the font weight to medium
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.push('/cart');
            },
          ),
          const SizedBox(width: 16), // Adding padding to the right
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            color: Color.fromARGB(255, 214, 214, 214),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _book == null
              ? const Center(child: Text('Book not found'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 500,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _book!.images.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  _book!.images[index],
                                  height: 500,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 18,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                      height:
                                          10), // Adjust the height as needed
                                  _buildPageIndicator(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_book!.name,
                                  style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                              Text(
                                'RM${_book!.price.toStringAsFixed(2)}',
                                style: GoogleFonts.alegreya(
                                  textStyle: const TextStyle(
                                    color: Color(0xff4a56c1),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Delivery Method',
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       Text(
                      //         'Delivery',
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w300,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Text(
                            //   'Description of Product',
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            Text(
                              _book!.detail ?? 'No description available.',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: _seller?.image != null &&
                                          _seller?.image != ""
                                      ? NetworkImage(_seller!.image)
                                      : const AssetImage(
                                              'assets/images/profileicon.jpg')
                                          as ImageProvider,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _seller?.username ?? 'Unknown Seller',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Text(
                                      '4.5/5',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 83, 83, 83),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 72, 72, 72),
                                    width: 1),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/productdetailbuyer');
                              },
                              child: const Text('Chat'),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xff4a56c1)),
            fixedSize: MaterialStateProperty.all(const Size(300, 50)),
          ),
          onPressed: () {
            _cartService.addtoCart(_book!.id).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Product added to cart successfully')));
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Failed to add product to cart')));
            });
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, color: Colors.white),
              SizedBox(width: 8), // Add spacing between icon and text
              Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _book!.images.length; i++) {
      indicators.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}
