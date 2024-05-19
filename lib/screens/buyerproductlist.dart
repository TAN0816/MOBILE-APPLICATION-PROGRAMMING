import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/services/book_service.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/services/cart_service.dart';

class BuyerList extends StatefulWidget {
  const BuyerList({Key? key}) : super(key: key);

  @override
  _BuyerList createState() => _BuyerList();
}

class _BuyerList extends State<BuyerList> {
  final BookService bookService = BookService();
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  void fetchBooks() async {
    try {
      List<Book> fetchedBooks = await bookService.getAllBooks();
      setState(() {
        books = fetchedBooks;
      });
    } catch (error) {
      print('Error fetching books: $error');
      setState(() {
        books = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/logo.png',
                          height: 60,
                          width: 60,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            onTap: () {
                              GoRouter.of(context).go('/search');
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Search Book Name',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.fromLTRB(16, 10, 0, 8),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {},
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          context.push('/cart');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 203, 202, 202),
                ),
              ),
            ],
          ),
        ),
      ),
      body: books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.67,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var book = books[index];
                        var imageUrl = book.images.isNotEmpty ? book.images[0] : '';
                        var bookName = book.name;
                        var bookPrice = book.price.toString();
                        var bookId = book.id.toString();

                        return InkWell(
                          onTap: () {
                            context.push('/productdetailbuyer/$bookId');
                          },
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 2,
                                    child: imageUrl.isNotEmpty
                                        ? (imageUrl.startsWith('http')
                                            ? Image.network(imageUrl, fit: BoxFit.cover)
                                            : Image.asset(imageUrl, fit: BoxFit.cover))
                                        : Image.asset('assets/image5.png', fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(22.0, 15.0, 15.0, 6.0),
                                  child: Text(bookName, style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 22.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'RM${double.parse(bookPrice).toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 16, color: Color(0xFF4A56C1)),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.add_shopping_cart_outlined, size: 18, color: Color(0xFF4A56C1)),
                                        onPressed: () {
                                          CartService().addtoCart(bookId).then((_) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Product added to cart successfully')),
                                            );
                                          }).catchError((error) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Failed to add product to cart')),
                                            );
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: books.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
