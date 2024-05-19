// search_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondhand_book_selling_platform/screens/search_result_page.dart';
import 'package:secondhand_book_selling_platform/services/search_history_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchHistoryService searchHistoryService = SearchHistoryService();
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    setState(() {
      _isLoading = true;
    });
    List<String> history = await searchHistoryService.getSearchHistory();
    setState(() {
      _searchHistory = history.reversed.toList(); // Display the most recent first
      _isLoading = false;
    });
  }

  void _onSearchButtonPressed() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _navigateToSearchResults(query);
      _saveSearchQuery(query);
    }
  }

  void _onHistoryItemPressed(String query) {
    _searchController.text = query;
    _navigateToSearchResults(query);
    _saveSearchQuery(query);
  }

  void _navigateToSearchResults(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(query: query),
      ),
    );
  }

  void _saveSearchQuery(String query) async {
    await searchHistoryService.addSearchQuery(query);
    _loadSearchHistory(); // Reload search history to update the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  GoRouter.of(context).go('/');
                },
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: true,
        title: const Text('Search', textAlign: TextAlign.center),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 227, 225, 225),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _onSearchButtonPressed(), // Trigger search on "Enter" key
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Search Book Name',
                      hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _onSearchButtonPressed, // Trigger search on button click
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Recently Searched',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: _searchHistory.map((query) => ListTile(
                            leading: const Icon(Icons.history, color: Colors.grey),
                            title: Text(query),
                            onTap: () => _onHistoryItemPressed(query),
                          )).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
