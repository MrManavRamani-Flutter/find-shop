import 'package:flutter/material.dart';
import '../models/search.dart';
import '../database/search_database_helper.dart';

class SearchProvider with ChangeNotifier {
  List<Search> _searches = [];

  List<Search> get searches => _searches;

  Future<void> fetchSearches() async {
    final searchesList = await SearchDatabaseHelper().getSearches();
    _searches = searchesList;
    notifyListeners();
  }

  Future<void> addSearch(Search search) async {
    await SearchDatabaseHelper().insertSearch(search);
    await fetchSearches();
  }

  Future<void> deleteSearch(int searchId) async {
    await SearchDatabaseHelper().deleteSearch(searchId);
    await fetchSearches();
  }
}
