import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_book_selling_platform/state/user_state.dart';
import 'package:secondhand_book_selling_platform/screens/search_result_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchButtonPressed(BuildContext context) {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _navigateToSearchResults(context, query);
      _saveSearchQuery(context, query);
    }
  }

  void _onHistoryItemPressed(BuildContext context, String query) {
    _searchController.text = query;
    _navigateToSearchResults(context, query);
    _saveSearchQuery(context, query);
  }

  void _navigateToSearchResults(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(query: query),
      ),
    );
  }

  void _saveSearchQuery(BuildContext context, String query) {
    Provider.of<UserState>(context, listen: false).addSearchQuery(query);
  }

  void _clearSearchHistory(BuildContext context) {
    Provider.of<UserState>(context, listen: false).clearSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
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
        automaticallyImplyLeading: true,
        title: Text('Search', textAlign: TextAlign.center),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color.fromARGB(255, 227, 225, 225),
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
                    onSubmitted: (_) => _onSearchButtonPressed(context), // Trigger search on "Enter" key
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Search Book Name',
                      hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => _onSearchButtonPressed(context), // Trigger search on button click
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recently Searched',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _clearSearchHistory(context),
                  child: Text('Clear History'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: userState.searchHistory
                    .map((query) => ListTile(
                          leading: Icon(Icons.history, color: Colors.grey),
                          title: Text(query),
                          onTap: () => _onHistoryItemPressed(context, query),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
