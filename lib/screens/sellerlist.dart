// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:secondhand_book_selling_platform/screens/add_product.dart';
// import 'package:secondhand_book_selling_platform/model/book.dart';
// import 'package:secondhand_book_selling_platform/services/book_service.dart';
// import 'package:secondhand_book_selling_platform/services/user_service.dart';

// class SellerList extends StatefulWidget {
//   const SellerList({super.key});

//   @override
//   _SellerList createState() => _SellerList();
// }

// class _SellerList extends State<SellerList> {
//   BookService bookService = BookService();
//   List<Book> books = [];
//   List<Book> filteredBooks = [];
//   String userId = '';
//   String searchQuery = '';
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     userId = UserService().getUserId;
//     fetchBooks();
//   }

//   void fetchBooks() async {
//     try {
//       List<Book> fetchedBooks = await bookService.getAllBooksBySellerId(userId);
//       setState(() {
//         books = fetchedBooks;
//         _isLoading = false;

//         filteredBooks = applySearchFilter(fetchedBooks);
//       });
//     } catch (error) {
//       print('Error fetching books: $error');
//       setState(() {
//         books = [];
//         filteredBooks = [];
//       });
//     }
//   }

//   void _onBookDeleted() {
//     // Refresh the book list
//     fetchBooks();
//   }

//   List<Book> applySearchFilter(List<Book> books) {
//     if (searchQuery.isEmpty) {
//       return books;
//     }
//     return books
//         .where((book) =>
//             book.name.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//   }

//   void onSearchChanged(String query) {
//     setState(() {
//       searchQuery = query;
//       filteredBooks = applySearchFilter(books);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         toolbarHeight: 90,
//         flexibleSpace: Padding(
//           padding: const EdgeInsets.only(top: 30.0, bottom: 2.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 60,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(2.0),
//                         child: Image.asset(
//                           'assets/logo.png',
//                           height: 60,
//                           width: 60,
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: TextField(
//                             onChanged: onSearchChanged,
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.grey[200],
//                               hintText: 'Search Book Name',
//                               hintStyle: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                                 borderSide: BorderSide.none,
//                               ),
//                               contentPadding:
//                                   const EdgeInsets.fromLTRB(16, 10, 0, 8),
//                               suffixIcon: IconButton(
//                                 icon: const Icon(Icons.search),
//                                 onPressed: () {},
//                               ),
//                               suffixIconConstraints: const BoxConstraints(
//                                 minWidth: 40,
//                                 minHeight: 40,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 height: 1,
//                 margin: const EdgeInsets.symmetric(horizontal: 10),
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 203, 202, 202),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: FutureBuilder<List<Book>>(
//         future: bookService.getAllBooksBySellerId(userId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             print('Error in FutureBuilder: ${snapshot.error}');
//             return Center(
//                 child: Text('Something went wrong: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No books found'));
//           }

//           books = snapshot.data!;
//           filteredBooks = applySearchFilter(books);

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 filteredBooks.isEmpty
//                     ? const Center(child: Text('No books found'))
//                     : const SizedBox(height: 12),
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.67,
//                   ),
//                   itemCount: filteredBooks.length,
//                   itemBuilder: (context, index) {
//                     var book = filteredBooks[index];
//                     var imageUrl = book.images.isNotEmpty ? book.images[0] : '';
//                     var bookName = book.name;
//                     var bookPrice = book.price.toString();
//                     var bookId = book.id.toString();

//                     return InkWell(
//                       onTap: () {
//                         context.push('/productdetailseller/$bookId');
//                       },
//                       child: Card(
//                         color: Colors.white,
//                         margin: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: AspectRatio(
//                                 aspectRatio: 2,
//                                 child: imageUrl.isNotEmpty
//                                     ? (imageUrl.startsWith('http')
//                                         ? Image.network(imageUrl,
//                                             fit: BoxFit.cover)
//                                         : Image.asset(imageUrl,
//                                             fit: BoxFit.cover))
//                                     : Image.asset('assets/image5.png',
//                                         fit: BoxFit.cover),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(
//                                   22.0, 15.0, 15.0, 6.0),
//                               child: Text(bookName,
//                                   style: const TextStyle(fontSize: 18)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(
//                                   22.0, 5.0, 15.0, 10.0),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     'RM${double.parse(bookPrice).toStringAsFixed(2)}',
//                                     style: GoogleFonts.alegreya(
//                                       textStyle: const TextStyle(
//                                         color: Color(0xff4a56c1),
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // Navigate to the AddNewBookPage and wait for the result
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddNewBookPage(
//                 onBookAdded: () {
//                   // Call setState to trigger a rebuild of the HomeScreen
//                   setState(() {});
//                 },
//               ),
//             ),
//           );

//           // If result is true, fetch the updated list of books
//           if (result == true) {
//             fetchBooks();
//           }
//         },
//         child: Icon(Icons.add, color: Colors.white),
//         backgroundColor: Color(0xff4a56c1),
//         elevation: 4,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secondhand_book_selling_platform/screens/add_product.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/services/book_service.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class SellerList extends StatefulWidget {
  const SellerList({super.key});

  @override
  _SellerList createState() => _SellerList();
}

class _SellerList extends State<SellerList> {
  BookService bookService = BookService();
  List<Book> books = [];
  List<Book> filteredBooks = [];
  String userId = '';
  String searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    userId = UserService().getUserId;
    fetchBooks();
  }

  void fetchBooks() async {
    try {
      List<Book> fetchedBooks = await bookService.getAllBooksBySellerId(userId);
      setState(() {
        books = fetchedBooks;
        _isLoading = false;

        filteredBooks = applySearchFilter(fetchedBooks);
      });
    } catch (error) {
      print('Error fetching books: $error');
      setState(() {
        books = [];
        filteredBooks = [];
      });
    }
  }

  void _onBookDeleted() {
    // Refresh the book list
    fetchBooks();
  }

  List<Book> applySearchFilter(List<Book> books) {
    if (searchQuery.isEmpty) {
      return books;
    }
    return books
        .where((book) =>
            book.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      filteredBooks = applySearchFilter(books);
    });
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
                            onChanged: onSearchChanged,
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
        future: bookService.getAllBooksBySellerId(userId),
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
          filteredBooks = applySearchFilter(books);

          return SingleChildScrollView(
            child: Column(
              children: [
                filteredBooks.isEmpty
                    ? const Center(child: Text('No books found'))
                    : const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.67,
                  ),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    var book = filteredBooks[index];
                    var imageUrl = book.images.isNotEmpty ? book.images[0] : '';
                    var bookName = book.name;
                    var bookPrice = book.price.toString();
                    var bookId = book.id.toString();

                    return InkWell(
                      onTap: () {
                        context.push('/productdetailseller/$bookId');
                      },
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(8.0),
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
                                  style: const TextStyle(fontSize: 18)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  22.0, 5.0, 15.0, 10.0),
                              child: Row(
                                children: [
                                  Text(
                                    'RM${double.parse(bookPrice).toStringAsFixed(2)}',
                                    style: GoogleFonts.alegreya(
                                      textStyle: const TextStyle(
                                        color: Color(0xff4a56c1),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the AddNewBookPage and wait for the result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewBookPage(
                onBookAdded: () {
                  // Call setState to trigger a rebuild of the HomeScreen
                  setState(() {});
                },
              ),
            ),
          );

          // If result is true, fetch the updated list of books
          if (result == true) {
            fetchBooks();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xff4a56c1),
        elevation: 4,
      ),
    );
  }
}
