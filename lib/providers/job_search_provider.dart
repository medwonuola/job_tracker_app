import 'package:flutter/foundation.dart';
import '../api/api_service.dart';
import '../models/job.dart';

enum SearchState { initial, loading, loaded, error }

class JobSearchProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;

  SearchState _state = SearchState.initial;
  SearchState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      _state = SearchState.initial;
      _jobs = [];
      notifyListeners();
      return;
    }

    _state = SearchState.loading;
    notifyListeners();

    try {
      _jobs = await _apiService.searchJobs(query: query);
      _state = SearchState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = SearchState.error;
    }
    notifyListeners();
  }
}
