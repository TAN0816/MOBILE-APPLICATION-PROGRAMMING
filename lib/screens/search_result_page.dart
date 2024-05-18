// search_results_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/services/book_service.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({Key? key, required this.query}) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final BookService bookService = BookService();
  List<Book> _searchResults = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchBooks(widget.query);
  }

  void _searchBooks(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _searchResults = [];
    });

    try {
      List<Book> results = await bookService.searchBooksByName(query);
      if (results.isEmpty) {
        setState(() {
          _errorMessage = 'No books found';
        });
      } else {
        setState(() {
          _searchResults = results;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error searching books: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchSubmitted(String query) {
    _searchBooks(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF4F4F4),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                onSubmitted: _onSearchSubmitted,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Search Book Name',
                  hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16, 10, 0, 8),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _onSearchSubmitted(_searchResults.join(", ")); // Pass the current query
                    },
                  ),
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_alt_outlined, color: Color.fromARGB(255, 3, 71, 122)),
              iconSize: 30,
              onPressed: () {},
            ),
          ],
        ),    
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color.fromARGB(255, 227, 225, 225),
            height: 1.0,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white, // Set filter row background color to white
                        padding: EdgeInsets.symmetric(vertical: 3.0),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: () {
                              // Handle sorting button press
                            },
                            icon: Icon(Icons.sort, color: Color.fromARGB(255, 87, 86, 86)),
                            label: Text('Price: lowest to high', style: TextStyle(color: Color.fromARGB(255, 87, 86, 86))),
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 203, 202, 202),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${_searchResults.length} Results Found',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.67,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          var book = _searchResults[index];
                          var imageUrl = book.images.isNotEmpty ? book.images[0] : 'assets/image5.png';
                          return Card(
                            color: Colors.white, // Set card color to white
                            margin: EdgeInsets.all(8.0), // Reduce the margin to make space between cards smaller
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 2,
                                    child: imageUrl.startsWith('http')
                                        ? Image.network(imageUrl, fit: BoxFit.cover)
                                        : Image.asset(imageUrl, fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(22.0, 15.0, 15.0, 6.0),
                                  child: Text(book.name, style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 22.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'RM${double.parse(book.price.toString()).toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 16, color: Color(0xFF4A56C1)),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.add_shopping_cart_outlined, size: 18, color: Color(0xFF4A56C1)),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
