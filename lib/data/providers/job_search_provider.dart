import 'package:flutter/foundation.dart';
import '../../api/api_service.dart';
import '../models/job.dart';
import '../models/search_filters.dart';

enum SearchState { initial, loading, loaded, error }

class JobSearchProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;

  SearchState _state = SearchState.initial;
  SearchState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  SearchFilters _filters = const SearchFilters();
  SearchFilters get filters => _filters;

  String _lastQuery = '';
  String get lastQuery => _lastQuery;

  Future<void> performSearch(String query, [SearchFilters? customFilters]) async {
    if (query.isEmpty) {
      _state = SearchState.initial;
      _jobs = [];
      _lastQuery = '';
      notifyListeners();
      return;
    }

    _state = SearchState.loading;
    _lastQuery = query;
    notifyListeners();

    try {
      _jobs = await _apiService.searchJobs(
        query: query,
        filters: customFilters ?? _filters,
      );
      _state = SearchState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = SearchState.error;
    }
    notifyListeners();
  }

  void updateFilters(SearchFilters newFilters) {
    _filters = newFilters;
    notifyListeners();
    
    if (_lastQuery.isNotEmpty) {
      performSearch(_lastQuery);
    }
  }

  void clearFilters() {
    _filters = const SearchFilters();
    notifyListeners();
    
    if (_lastQuery.isNotEmpty) {
      performSearch(_lastQuery);
    }
  }

  bool get hasActiveFilters => !_filters.isEmpty;
}
