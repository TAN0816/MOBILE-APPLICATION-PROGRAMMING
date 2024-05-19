import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/screens/edit_product.dart';
import 'package:secondhand_book_selling_platform/services/book_service.dart';

class ProductDetailSeller extends StatefulWidget {
  final String bookId;
  final Function()? onBookDeleted; // Add this line

  const ProductDetailSeller(
      {super.key, required this.bookId, this.onBookDeleted});

  @override
  _ProductDetailSellerState createState() => _ProductDetailSellerState();
}

class _ProductDetailSellerState extends State<ProductDetailSeller> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final BookService _bookService = BookService();
  Book? _book;
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
  }

  // Callback function to refresh the product details after update/delete operation
  void _onProductUpdated() {
    _fetchBookDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
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
                                  const SizedBox(height: 10),
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
                              Text(
                                _book!.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Product Detail',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                _buildBulletPoint('Year ${_book!.year}'),
                                _buildBulletPoint(_book!.faculty),
                                _buildBulletPoint('${_book!.quantity} left'),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description of Product',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _book!.detail ?? 'No description available.',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff4a56c1)),
                fixedSize: MaterialStateProperty.all(
                    const Size(200, 50)), // Adjust buttonf size as needed
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductPage(
                      bookId: _book!.id,
                      onBookUpdate: _fetchBookDetails,
                      // Pass the callback function
                    ),
                  ),
                );
              },
              child: const Text(
                'Edit Product',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.red), // Change button color to red for delete
                fixedSize: MaterialStateProperty.all(
                    const Size(140, 50)), // Adjust button size as needed
              ),
              onPressed: () async {
                if (_book != null) {
                  try {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Product"),
                          content: const Text(
                              "Are you sure you want to delete this product?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await _bookService.deleteBook(_book!.id);

                                  // // After successfully deleting the book
                                  widget.onBookDeleted?.call();
                                  Navigator.of(context).pop();
                                  // Navigate back to the home page
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                } catch (e) {
                                  print("Error deleting product: $e");
                                }
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    print("Error showing delete confirmation dialog: $e");
                  }
                } else {
                  print("_book is null");
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 8, // Adjust the width as needed
          child: Icon(
            Icons.circle,
            size: 8, // Adjust the size of the bullet point
            color: Colors.black,
          ),
        ),
        const SizedBox(
            width: 8), // Adjust the spacing between bullet point and text
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
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
