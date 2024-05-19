import 'package:flutter/material.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/services/book_service.dart';

class ProductDetailSeller extends StatefulWidget {
  final String bookId;
  const ProductDetailSeller({super.key, required this.bookId});

  @override
  _ProductDetailSellerState createState() => _ProductDetailSellerState();
}

class _ProductDetailSellerState extends State<ProductDetailSeller> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  BookService _bookService = BookService();
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
                                  const SizedBox(height: 10), // Adjust the height as needed
                                  _buildPageIndicator(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
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
                                style: const TextStyle(
                                  color: Color(0xff4a56c1),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Method',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Delivery',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Course and Year',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_book!.course} Year ${_book!.year}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quantity',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_book!.quantity} left',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description of Product',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'The C++ Programming Language is a computer programming book first published in October 1985. It was the first book to describe the C++ programming language, written by the languages creator, Bjarne Stroustrup. In the absence of an official standard, the book served for several years as the de facto documentation for the evolving C++ language, until the release of the ISO/IEC 14882:1998: Programming Language C++ standard on 1 September 1998',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
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
    child:Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
  children: [
    ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xff4a56c1)),
        fixedSize: MaterialStateProperty.all(const Size(200, 50)), // Adjust button size as needed
      ),
      onPressed: () {
        // Add your onPressed logic for editing here
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
        backgroundColor: MaterialStateProperty.all(Colors.red), // Change button color to red for delete
        fixedSize: MaterialStateProperty.all(const Size(140, 50)), // Adjust button size as needed
      ),
      onPressed: () {
        // Add your onPressed logic for deleting here
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