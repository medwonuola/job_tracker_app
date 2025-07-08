import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../core/exceptions/api_exceptions.dart';
import '../data/models/job.dart';
import '../data/models/search_filters.dart';
import '../data/models/location_suggestion.dart';

class ApiService {
  late final Dio _dio;
  late final String _apiKey;
  static const Uuid _uuid = Uuid();

  final LinkedHashMap<String, List<LocationSuggestion>> _locationCache =
      LinkedHashMap<String, List<LocationSuggestion>>();

  ApiService() {
    _apiKey = dotenv.env['RAPIDAPI_KEY'] ?? '';
    if (_apiKey.isEmpty) {
      throw AuthenticationException('RAPIDAPI_KEY not found in environment');
    }

    _dio = Dio()
      ..options.headers['X-RapidAPI-Key'] = _apiKey
      ..options.headers['X-RapidAPI-Host'] = AppConstants.rapidApiHost
      ..options.connectTimeout = const Duration(seconds: AppConstants.connectTimeoutSeconds)
      ..options.receiveTimeout = const Duration(seconds: AppConstants.receiveTimeoutSeconds);
  }

  Future<List<Job>> searchJobs({
    required String query,
    SearchFilters? filters,
  }) async {
    if (query.trim().isEmpty) {
      throw ServerException(AppConstants.errorMessages['searchQueryEmpty']!);
    }

    try {
      final queryParameters = _buildJobSearchParams(query, filters);
      
      final response = await _dio.get<dynamic>(
        '${AppConstants.baseApiUrl}${AppConstants.searchJobsEndpoint}',
        queryParameters: queryParameters,
      );

      return _handleJobSearchResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException('${AppConstants.errorMessages['unexpectedError']!}: $e');
    }
  }

  Map<String, dynamic> _buildJobSearchParams(String query, SearchFilters? filters) {
    final Map<String, dynamic> params = {
      'jobTitleQuery': query,
      'locationShort': 'US',
      'region': 'anywhere_in_world',
      'workplaceTypes': 'Remote',
      'size': 25,
    };

    if (filters != null && !filters.isEmpty) {
      params.addAll(filters.toQueryParameters());
    }

    return params;
  }

  List<Job> _handleJobSearchResponse(Response<dynamic> response) {
    if (response.statusCode != 200 || response.data == null) {
      throw ServerException(
        'API Error: Status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    return _parseJobsResponse(response.data);
  }

  List<Job> _parseJobsResponse(dynamic responseData) {
    try {
      final jobsArray = _extractJobsArray(responseData);
      
      return jobsArray
          .whereType<Map<String, dynamic>>()
          .map(_parseJobJson)
          .where((job) => job != null)
          .cast<Job>()
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException('${AppConstants.errorMessages['parseError']!}: $e');
    }
  }

  List<dynamic> _extractJobsArray(dynamic responseData) {
    if (responseData is List<dynamic>) {
      return responseData;
    }
    
    if (responseData is Map<String, dynamic>) {
      final dataMap = responseData;
      
      for (final key in ['jobs', 'data', 'results']) {
        if (dataMap.containsKey(key) && dataMap[key] is List<dynamic>) {
          return dataMap[key] as List<dynamic>;
        }
      }
      
      final possibleArrays = dataMap.values.whereType<List<dynamic>>().toList();
      if (possibleArrays.isNotEmpty) {
        return possibleArrays.first;
      }
    }
    
    return [];
  }

  Job? _parseJobJson(Map<String, dynamic> json) {
    try {
      return Job.fromJson(_normalizeJobData(json));
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _normalizeJobData(Map<String, dynamic> json) {
    return {
      'id': json['id']?.toString() ?? _uuid.v4(),
      'title': json['title']?.toString() ?? AppConstants.defaultJobTitle,
      'description': json['description']?.toString() ?? AppConstants.defaultJobDescription,
      'applyUrl': json['applyUrl']?.toString() ?? json['apply_url']?.toString(),
      'isRemote': json['isRemote'] ?? json['is_remote'] ?? json['remote'] ?? false,
      'company': _normalizeCompanyData(json),
      'location': _normalizeLocationData(json),
      'perks': _normalizePerksData(json),
      'applicationFormEase': json['applicationFormEase'] ?? 
                             json['application_form_ease'] ?? 
                             json['applicationEase'],
    };
  }

  Map<String, dynamic> _normalizeCompanyData(Map<String, dynamic> json) {
    if (json['company'] is Map<String, dynamic>) {
      return json['company'] as Map<String, dynamic>;
    }
    
    return {
      'name': json['company']?.toString() ?? 
              json['company_name']?.toString() ?? 
              json['companyName']?.toString() ?? 
              AppConstants.defaultCompanyName,
      'image': json['company_logo'] ?? json['companyLogo'],
      'industry': json['industry'],
      'website': json['company_website'] ?? json['companyWebsite'],
    };
  }

  Map<String, dynamic> _normalizeLocationData(Map<String, dynamic> json) {
    if (json['location'] is Map<String, dynamic>) {
      return json['location'] as Map<String, dynamic>;
    }
    
    return {
      'formatted': json['location']?.toString() ??
                   json['location_name']?.toString() ??
                   json['locationName']?.toString() ??
                   AppConstants.defaultLocation,
    };
  }

  List<String> _normalizePerksData(Map<String, dynamic> json) {
    if (json['perks'] is List) {
      return (json['perks'] as List).whereType<String>().toList();
    }
    if (json['benefits'] is List) {
      return (json['benefits'] as List).whereType<String>().toList();
    }
    return <String>[];
  }

  Future<List<LocationSuggestion>> searchLocations({String? query}) async {
    if (query == null || query.trim().isEmpty) {
      return [];
    }

    final normalizedQuery = query.trim().toLowerCase();
    if (_locationCache.containsKey(normalizedQuery)) {
      return _locationCache[normalizedQuery]!;
    }

    try {
      final response = await _dio.get<dynamic>(
        '${AppConstants.baseApiUrl}${AppConstants.searchLocationEndpoint}',
        queryParameters: {'query': query},
      );

      final locations = _parseLocationResponse(response);
      _cacheLocationQuery(normalizedQuery, locations);
      
      return locations;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException('${AppConstants.errorMessages['unexpectedError']!}: $e');
    }
  }

  List<LocationSuggestion> _parseLocationResponse(Response<dynamic> response) {
    if (response.statusCode != 200 || response.data == null) {
      throw ServerException(
        'API Error: Status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    final dynamic responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      return [];
    }

    final Map<String, dynamic> dataMap = responseData;
    final dynamic locationsData = dataMap['locations'];

    if (locationsData is! List<dynamic>) {
      return [];
    }

    return locationsData
        .whereType<Map<String, dynamic>>()
        .map((json) => LocationSuggestion.fromJson(json))
        .toList();
  }

  void _cacheLocationQuery(String query, List<LocationSuggestion> locations) {
    if (_locationCache.length >= AppConstants.maxCacheEntries) {
      final firstKey = _locationCache.keys.first;
      _locationCache.remove(firstKey);
    }
    _locationCache[query] = locations;
  }

  Future<List<String>> getDepartments({String? query}) async {
    return _getStringList(AppConstants.getDepartmentsEndpoint, 'departments', query);
  }

  Future<List<String>> getIndustries({String? query}) async {
    return _getStringList(AppConstants.getIndustriesEndpoint, 'result', query);
  }

  Future<List<String>> _getStringList(String endpoint, String dataKey, String? query) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (query != null && query.isNotEmpty) {
        queryParameters['query'] = query;
      }

      final response = await _dio.get<dynamic>(
        '${AppConstants.baseApiUrl}$endpoint',
        queryParameters: queryParameters,
      );

      if (response.statusCode != 200 || response.data == null) {
        throw ServerException(
          'API Error: Status ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final dynamic responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        return [];
      }

      final Map<String, dynamic> dataMap = responseData;
      final dynamic listData = dataMap[dataKey];

      if (listData is! List) {
        return [];
      }

      return listData.whereType<String>().toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException('${AppConstants.errorMessages['unexpectedError']!}: $e');
    }
  }

  ApiException _handleDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    
    switch (statusCode) {
      case 429:
        return RateLimitException(AppConstants.errorMessages['rateLimitError']!);
      case 401:
        return AuthenticationException(AppConstants.errorMessages['authError']!);
      default:
        return NetworkException('${AppConstants.errorMessages['networkError']!}: ${e.message}');
    }
  }
}
