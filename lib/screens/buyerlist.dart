import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/services/book_service.dart';

class BuyerList extends StatefulWidget {
  const BuyerList({super.key});

  @override
  _BuyerList createState() => _BuyerList();
}

class _BuyerList extends State<BuyerList> {
  BookService bookService = BookService();
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
              SizedBox(
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
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            onTap: () {
                              // Navigate to the search page
                              GoRouter.of(context).go('/search');
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Search Book Name',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 10, 0, 8),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  // Handle search button press
                                  print('Search button pressed');
                                },
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
              const SizedBox(height: 10),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 203, 202, 202),
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: bookService.getAllBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error in FutureBuilder: ${snapshot.error}');
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found'));
          }

          books = snapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: bookService.getBooksStream(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (streamSnapshot.hasError) {
                print('Error in StreamBuilder: ${streamSnapshot.error}');
                return Center(
                    child:
                        Text('Something went wrong: ${streamSnapshot.error}'));
              }
              if (!streamSnapshot.hasData ||
                  streamSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No books found'));
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors
                          .white, // Set filter row background color to white
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // Handle filter button press
                            },
                            icon: const Icon(Icons.filter_list,
                                color: Color.fromARGB(255, 87, 86, 86)),
                            label: const Text('Filters',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 87, 86, 86))),
                          ),
                          const SizedBox(width: 16),
                          TextButton.icon(
                            onPressed: () {
                              // Handle sorting button press
                            },
                            icon: const Icon(Icons.sort,
                                color: Color.fromARGB(255, 87, 86, 86)),
                            label: const Text('Price: lowest to high',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 87, 86, 86))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 203, 202, 202),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.67,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        var book = books[index];
                        var imageUrl =
                            book.images.isNotEmpty ? book.images[0] : '';
                        var bookName = book.name;
                        var bookPrice = book.price.toString();
                        var bookId = book.id.toString();

                        return InkWell(
                          onTap: () {
                            context.push('/productdetailbuyer/$bookId');
                          },
                          child: Card(
                            color: Colors.white, // Set card color to white
                            margin: const EdgeInsets.all(
                                8.0), // Reduce the margin to make space between cards smaller
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 2,
                                    child: imageUrl.isNotEmpty
                                        ? (imageUrl.startsWith('http')
                                            ? Image.network(imageUrl,
                                                fit: BoxFit.cover)
                                            : Image.asset(imageUrl,
                                                fit: BoxFit.cover))
                                        : Image.asset('assets/image5.png',
                                            fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      22.0, 15.0, 15.0, 6.0),
                                  child: Text(bookName,
                                      style: const TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 22.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'RM${double.parse(bookPrice).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF4A56C1)),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
