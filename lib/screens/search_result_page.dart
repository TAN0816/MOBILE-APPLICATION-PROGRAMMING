import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/services/book_service.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final double? minPrice;
  final double? maxPrice;
  final String? faculty;
  final List<String>? years;

  const SearchResultsPage({
    Key? key,
    required this.query,
    this.minPrice,
    this.maxPrice,
    this.faculty,
    this.years,
  }) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final BookService bookService = BookService();
  List<Book> _searchResults = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isAscending = true;

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  String? selectedFaculty;
  Set<String> selectedYears = {};

  @override
  void initState() {
    super.initState();
    _searchAndFilterBooks(widget.query, widget.minPrice, widget.maxPrice, widget.faculty, widget.years);
  }

  void _searchAndFilterBooks(String query, double? minPrice, double? maxPrice, String? faculty, List<String>? years) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _searchResults = [];
    });

    print('Query: $query');
    print('Min Price: $minPrice');
    print('Max Price: $maxPrice');
    print('Faculty: $faculty');
    print('Years: $years');

    try {
      List<Book> results = await bookService.searchAndFilterBooks(
        query: query,
        minPrice: minPrice,
        maxPrice: maxPrice,
        faculty: faculty,
        years: years,
      );

      print('Results: ${results.length}');

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

  void _sortBooksByPrice() {
    setState(() {
      _searchResults.sort((a, b) {
        if (_isAscending) {
          return a.price.compareTo(b.price);
        } else {
          return b.price.compareTo(a.price);
        }
      });
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _sortBooksByPrice();
    });
  }

  void _onSearchSubmitted(String query) {
    _searchAndFilterBooks(query, widget.minPrice, widget.maxPrice, widget.faculty, widget.years);
  }

  void _showFilterOptions() {
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
                    _showFacultySelection();
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
                        _searchAndFilterBooks(widget.query, minPrice, maxPrice, selectedFaculty, selectedYears.toList());
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

  void _showFacultySelection() {
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
                  GoRouter.of(context).go('/');
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
                      _onSearchSubmitted(widget.query);
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
              onPressed: () {
                _showFilterOptions();
              },
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
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 3.0),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: _toggleSortOrder,
                            icon: Icon(Icons.sort, color: Color.fromARGB(255, 87, 86, 86)),
                            label: Text(
                              _isAscending ? 'Price: lowest to highest' : 'Price: highest to lowest',
                              style: TextStyle(color: Color.fromARGB(255, 87, 86, 86)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
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
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${_searchResults.length} Results Found',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.67,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          var book = _searchResults[index];
                          var imageUrl = book.images.isNotEmpty ? book.images[0] : 'assets/image5.png';
                          return Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(8.0),
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
                        childCount: _searchResults.length,
                      ),
                    ),
                  ],
                ),
    );
  }
}
