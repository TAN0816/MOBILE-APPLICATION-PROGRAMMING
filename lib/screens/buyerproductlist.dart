import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/services/book_service.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookService bookService = BookService();
  List<Book> books = [];
  String? selectedFaculty;
  Set<String> selectedYears = {};
  bool _isAscending = true; // Track the current sort order

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

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
        _sortBooksByPrice();
      });
    } catch (error) {
      print('Error fetching books: $error');
      setState(() {
        books = [];
      });
    }
  }

  void _sortBooksByPrice() {
    books.sort((a, b) {
      if (_isAscending) {
        return a.price.compareTo(b.price);
      } else {
        return b.price.compareTo(a.price);
      }
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _sortBooksByPrice();
    });
  }

  void showFilterForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Price Range'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        decoration: InputDecoration(
                          labelText: 'Min Price',
                          prefixText: 'RM',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        decoration: InputDecoration(
                          labelText: 'Max Price',
                          prefixText: 'RM',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Faculty'),
                ListTile(
                  title: Text(selectedFaculty ?? 'Select Faculty'),
                  trailing: Icon(Icons.arrow_drop_down),
                  onTap: () {
                    showFacultySelection();
                  },
                ),
                SizedBox(height: 16),
                Text('Year'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: ['Year 1', 'Year 2', 'Year 3', 'Year 4'].map((year) {
                    return FilterChip(
                      label: Text(year),
                      selected: selectedYears.contains(year),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedYears.add(year);
                          } else {
                            selectedYears.remove(year);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _minPriceController.clear();
                          _maxPriceController.clear();
                          selectedFaculty = null;
                          selectedYears.clear();
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black),
                      ),
                      child: Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        double? minPrice = double.tryParse(_minPriceController.text);
                        double? maxPrice = double.tryParse(_maxPriceController.text);

                        Navigator.pop(context);
                        GoRouter.of(context).go('/search_results', extra: {
                          'query': '', // Provide the actual search query here
                          'minPrice': minPrice,
                          'maxPrice': maxPrice,
                          'faculty': selectedFaculty,
                          'years': selectedYears.toList(),
                        });
                      },
                      child: Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showFacultySelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Faculty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      'Civil Engineering',
                      'Mechanical Engineering',
                      'Electrical Engineering',
                      'Chemical & Energy Engineering',
                      'Computing',
                      'Science',
                      'Built Environment & Surveying',
                      'Social Sciences & Humanities',
                      'Management',
                    ].map((faculty) {
                      return RadioListTile<String>(
                        title: Text(faculty),
                        value: faculty,
                        groupValue: selectedFaculty,
                        onChanged: (value) {
                          setState(() {
                            selectedFaculty = value;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(child: Text('Apply')),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                                onPressed: () {
                                  print('Search button pressed');
                                },
                              ),
                              suffixIconConstraints: BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {},
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            showFilterForm();
                          },
                          icon: Icon(Icons.filter_list, color: Color.fromARGB(255, 87, 86, 86)),
                          label: Text('Filters', style: TextStyle(color: Color.fromARGB(255, 87, 86, 86))),
                        ),
                        SizedBox(width: 16),
                        TextButton.icon(
                          onPressed: _toggleSortOrder,
                          icon: Icon(Icons.sort, color: Color.fromARGB(255, 87, 86, 86)),
                          label: Text(
                            _isAscending ? 'Price: lowest to highest' : 'Price: highest to lowest',
                            style: TextStyle(color: Color.fromARGB(255, 87, 86, 86)),
                          ),
                        ),
                      ],
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
                  SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.67,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      var book = books[index];
                      var imageUrl = book.images.isNotEmpty ? book.images[0] : '';
                      var bookName = book.name;
                      var bookPrice = book.price.toString();

                      return InkWell(
                        onTap: () {
                          GoRouter.of(context).go('/details', extra: book);
                        },
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.all(8.0),
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
                                      onPressed: () {},
                                    ),
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
            ),
    );
  }
}
