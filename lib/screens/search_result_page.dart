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
    super.key,
    required this.query,
    this.minPrice,
    this.maxPrice,
    this.faculty,
    this.years,
  });

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
    _searchAndFilterBooks(widget.query, widget.minPrice, widget.maxPrice,
        widget.faculty, widget.years);
  }

  void _searchAndFilterBooks(String query, double? minPrice, double? maxPrice,
      String? faculty, List<String>? years) async {
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
    _searchAndFilterBooks(
        query, widget.minPrice, widget.maxPrice, widget.faculty, widget.years);
  }


void _showFilterOptions() {
  // Define controllers for min and max price
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  // Local variables for selected filters
  String? localSelectedFaculty = selectedFaculty;
  Set<String> localSelectedYears = Set.from(selectedYears);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
                      const Text(
                        'Filter',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Price Range'),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minPriceController,
                          decoration: const InputDecoration(
                            labelText: 'Min Price',
                            prefixText: 'RM',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: maxPriceController,
                          decoration: const InputDecoration(
                            labelText: 'Max Price',
                            prefixText: 'RM',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Faculty'),
                  DropdownButtonFormField<String>(
                    value: localSelectedFaculty,
                    onChanged: (value) {
                      setState(() {
                        localSelectedFaculty = value;
                      });
                    },
                    items: [
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
                      return DropdownMenuItem<String>(
                        value: faculty,
                        child: Text(faculty),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Year'),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: ['Year 1', 'Year 2', 'Year 3', 'Year 4'].map((year) {
                      return FilterChip(
                        label: Text(year),
                        selected: localSelectedYears.contains(year),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              localSelectedYears.add(year);
                            } else {
                              localSelectedYears.remove(year);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Reset filters locally
                          setState(() {
                            minPriceController.clear();
                            maxPriceController.clear();
                            localSelectedFaculty = null;
                            localSelectedYears.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Apply filters and close modal
                          double? minPrice = double.tryParse(minPriceController.text);
                          double? maxPrice = double.tryParse(maxPriceController.text);

                          Navigator.pop(context); // Close modal on apply
                          _searchAndFilterBooks(widget.query, minPrice, maxPrice, localSelectedFaculty, localSelectedYears.toList());
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF4F4F4),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  context.go('/');
                },
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                onTap: () {
                  GoRouter.of(context).go('/search');
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Search Book Name',
                  hintStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 10, 0, 8),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      GoRouter.of(context).push('/search');
                    },
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined,
                  color: Color.fromARGB(255, 3, 71, 122)),
              iconSize: 30,
              onPressed: _showFilterOptions,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 227, 225, 225),
            height: 1.0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(child: Text(_errorMessage))
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: _toggleSortOrder,
                            icon: const Icon(Icons.sort,
                                color: Color.fromARGB(255, 87, 86, 86)),
                            label: Text(
                              _isAscending
                                  ? 'Price: lowest to highest'
                                  : 'Price: highest to lowest',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 87, 86, 86)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
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
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${_searchResults.length} Results Found',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.67,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          var book = _searchResults[index];
                          var imageUrl = book.images.isNotEmpty
                              ? book.images[0]
                              : 'assets/image5.png';
                          var bookId = book.id.toString();

                          return InkWell(
                            onTap: () {
                              context.push('/productdetailbuyer/$bookId');
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
                                      child: imageUrl.startsWith('http')
                                          ? Image.network(imageUrl,
                                              fit: BoxFit.cover)
                                          : Image.asset(imageUrl,
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        22.0, 15.0, 15.0, 6.0),
                                    child: Text(book.name,
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 22.0, right: 5.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'RM${double.parse(book.price.toString()).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF4A56C1)),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_shopping_cart_outlined,
                                              size: 18,
                                              color: Color(0xFF4A56C1)),
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
                        childCount: _searchResults.length,
                      ),
                    ),
                  ],
                ),
    );
  }
}
