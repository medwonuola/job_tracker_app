import 'package:flutter/foundation.dart';
import '../../api/api_service.dart';
import '../../core/constants/app_constants.dart';
import '../models/job.dart';
import '../models/search_filters.dart';

enum SearchState { initial, loading, loaded, error }

class JobSearchProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Job> _jobs = [];
  List<Job> get jobs => List.unmodifiable(_jobs);

  SearchState _state = SearchState.initial;
  SearchState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  SearchFilters _filters = const SearchFilters();
  SearchFilters get filters => _filters;

  String _lastQuery = '';
  String get lastQuery => _lastQuery;

  bool _disposed = false;

  Future<void> performSearch(String query, [SearchFilters? customFilters]) async {
    if (_disposed) return;

    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      _updateState(SearchState.initial, jobs: [], query: '');
      return;
    }

    _updateState(SearchState.loading, query: trimmedQuery);

    try {
      final searchResults = await _apiService.searchJobs(
        query: trimmedQuery,
        filters: customFilters ?? _filters,
      );
      
      if (!_disposed) {
        _updateState(SearchState.loaded, jobs: searchResults);
      }
    } catch (e) {
      if (!_disposed) {
        _updateState(SearchState.error, errorMessage: _getErrorMessage(e));
      }
    }
  }

  void _updateState(
    SearchState newState, {
    List<Job>? jobs,
    String? errorMessage,
    String? query,
  }) {
    if (_disposed) return;

    _state = newState;
    if (jobs != null) _jobs = jobs;
    if (errorMessage != null) _errorMessage = errorMessage;
    if (query != null) _lastQuery = query;
    
    notifyListeners();
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('Network')) {
      return AppConstants.errorMessages['networkError']!;
    } else if (errorString.contains('Rate limit')) {
      return AppConstants.errorMessages['rateLimitError']!;
    } else if (errorString.contains('Authentication')) {
      return AppConstants.errorMessages['authError']!;
    } else {
      return errorString;
    }
  }

  void updateFilters(SearchFilters newFilters) {
    if (_disposed || _filters == newFilters) return;

    _filters = newFilters;
    notifyListeners();
    
    if (_lastQuery.isNotEmpty) {
      performSearch(_lastQuery);
    }
  }

  void clearFilters() {
    updateFilters(const SearchFilters());
  }

  bool get hasActiveFilters => !_filters.isEmpty;

  void reset() {
    if (_disposed) return;
    
    _updateState(
      SearchState.initial,
      jobs: [],
      query: '',
      errorMessage: '',
    );
    _filters = const SearchFilters();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
