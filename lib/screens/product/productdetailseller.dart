import 'package:flutter/material.dart';

class ProductDetailSeller extends StatefulWidget {
  const ProductDetailSeller({super.key});

  @override
  _ProductDetailSeller createState() => _ProductDetailSeller();
}

class _ProductDetailSeller extends State<ProductDetailSeller> {
  final List<String> images = [
    'assets/images/hci.jpg',
    'assets/images/profile.jpg',
  ];
  final PageController _pageController = PageController();

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: SingleChildScrollView(
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
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        images[index],
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
                            height: 10), // Adjust the height as needed
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HCI Textbookk', // Placeholder for product details
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'RM141', // Placeholder for product details
                      style: TextStyle(
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
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align the text to the left
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
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Course and Year',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Software Engineering Year 2',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '2 left',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  )
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
                    'The C++ programming language provides a model that comprises memory and computation,(lan­guage constructs) enable programmers to introduce and use new types of objects that resemble the con­cepts of an applicationThe C++ programming language provides a model that comprises memory and computation, and these are very similar to that of most computers. And also, its powerful and flexible ', // Placeholder for product details
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
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xff4a56c1)),
            fixedSize: MaterialStateProperty.all(const Size(300, 50)),
          ),
          onPressed: () {
            // Add your onPressed logic here
          },
          child: const Text(
            'Add to Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < images.length; i++) {
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
