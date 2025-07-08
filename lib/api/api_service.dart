import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import '../core/exceptions/api_exceptions.dart';
import '../data/models/job.dart';
import '../data/models/search_filters.dart';
import '../data/models/location_suggestion.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://hidden-job-board.p.rapidapi.com';
  late final String _apiKey;
  final Uuid _uuid = const Uuid();

  final LinkedHashMap<String, List<LocationSuggestion>> _locationCache =
      LinkedHashMap<String, List<LocationSuggestion>>();
  static const int _maxCacheEntries = 50;

  ApiService() {
    _apiKey = dotenv.env['RAPIDAPI_KEY']!;

    _dio.options.headers['X-RapidAPI-Key'] = _apiKey;
    _dio.options.headers['X-RapidAPI-Host'] = 'hidden-job-board.p.rapidapi.com';
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  Future<List<Job>> searchJobs({
    required String query,
    SearchFilters? filters,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'jobTitleQuery': query,
        'locationShort': 'US',
        'region': 'anywhere_in_world',
        'workplaceTypes': 'Remote',
        'size': 25,
      };

      if (filters != null && !filters.isEmpty) {
        queryParameters.addAll(filters.toQueryParameters());
      }

      final Response<dynamic> response = await _dio.get<dynamic>(
        '$_baseUrl/search-jobs',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        return _parseJobsResponse(response.data);
      } else {
        throw ServerException(
          'API Error: Status ${response.statusCode}, Body: ${response.data}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw const RateLimitException(
            'Rate limit exceeded. Please try again later.',);
      } else if (e.response?.statusCode == 401) {
        throw const AuthenticationException(
            'API authentication failed. Please check API key.',);
      } else {
        throw NetworkException('Network Error: ${e.message}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  List<Job> _parseJobsResponse(dynamic responseData) {
    try {
      List<dynamic> jobsArray;

      if (responseData is List<dynamic>) {
        jobsArray = responseData;
      } else if (responseData is Map<String, dynamic>) {
        final dataMap = responseData;

        if (dataMap.containsKey('jobs') && dataMap['jobs'] is List<dynamic>) {
          jobsArray = dataMap['jobs'] as List<dynamic>;
        } else if (dataMap.containsKey('data') &&
            dataMap['data'] is List<dynamic>) {
          jobsArray = dataMap['data'] as List<dynamic>;
        } else if (dataMap.containsKey('results') &&
            dataMap['results'] is List<dynamic>) {
          jobsArray = dataMap['results'] as List<dynamic>;
        } else {
          final possibleArrays =
              dataMap.values.whereType<List<dynamic>>().toList();
          if (possibleArrays.isNotEmpty) {
            jobsArray = possibleArrays.first;
          } else {
            return [];
          }
        }
      } else {
        throw ServerException(
            'Unexpected response format: ${responseData.runtimeType}',);
      }

      return jobsArray
          .whereType<Map<String, dynamic>>()
          .map((json) => _parseJobJson(json))
          .where((job) => job != null)
          .cast<Job>()
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException('Failed to parse jobs response: $e');
    }
  }

  Job? _parseJobJson(Map<String, dynamic> json) {
    try {
      final jobData = <String, dynamic>{};

      jobData['id'] = json['id']?.toString() ?? _uuid.v4();
      jobData['title'] = json['title']?.toString() ?? 'No Title';
      jobData['description'] = json['description']?.toString() ?? '';
      jobData['applyUrl'] =
          json['applyUrl']?.toString() ?? json['apply_url']?.toString();
      jobData['isRemote'] =
          json['isRemote'] ?? json['is_remote'] ?? json['remote'] ?? false;

      if (json['company'] is Map<String, dynamic>) {
        jobData['company'] = json['company'];
      } else if (json['company'] is String) {
        jobData['company'] = {
          'name': json['company'],
          'image': json['company_logo'] ?? json['companyLogo'],
          'industry': json['industry'],
          'website': json['company_website'] ?? json['companyWebsite'],
        };
      } else {
        jobData['company'] = {
          'name':
              json['company_name'] ?? json['companyName'] ?? 'Unknown Company',
          'image': json['company_logo'] ?? json['companyLogo'],
          'industry': json['industry'],
          'website': json['company_website'] ?? json['companyWebsite'],
        };
      }

      if (json['location'] is Map<String, dynamic>) {
        jobData['location'] = json['location'];
      } else {
        jobData['location'] = {
          'formatted': json['location']?.toString() ??
              json['location_name']?.toString() ??
              json['locationName']?.toString() ??
              'Remote',
        };
      }

      if (json['perks'] is List) {
        jobData['perks'] = json['perks'];
      } else if (json['benefits'] is List) {
        jobData['perks'] = json['benefits'];
      } else {
        jobData['perks'] = <String>[];
      }

      jobData['applicationFormEase'] = json['applicationFormEase'] ??
          json['application_form_ease'] ??
          json['applicationEase'];

      return Job.fromJson(jobData);
    } catch (e) {
      return null;
    }
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
      final Response<dynamic> response = await _dio.get<dynamic>(
        '$_baseUrl/search-location',
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;

        if (responseData is! Map<String, dynamic>) {
          return [];
        }

        final Map<String, dynamic> dataMap = responseData;
        final dynamic locationsData = dataMap['locations'];

        if (locationsData is! List<dynamic>) {
          return [];
        }

        final locations = locationsData
            .whereType<Map<String, dynamic>>()
            .map((json) => LocationSuggestion.fromJson(json))
            .toList();

        _cacheLocationQuery(normalizedQuery, locations);
        return locations;
      } else {
        throw ServerException(
          'API Error: Status ${response.statusCode}, Body: ${response.data}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network Error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  void _cacheLocationQuery(String query, List<LocationSuggestion> locations) {
    if (_locationCache.length >= _maxCacheEntries) {
      final firstKey = _locationCache.keys.first;
      _locationCache.remove(firstKey);
    }
    _locationCache[query] = locations;
  }

  Future<List<String>> getDepartments({String? query}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (query != null && query.isNotEmpty) {
        queryParameters['query'] = query;
      }

      final Response<dynamic> response = await _dio.get<dynamic>(
        '$_baseUrl/get-departments',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;

        if (responseData is! Map<String, dynamic>) {
          return [];
        }

        final Map<String, dynamic> dataMap = responseData;
        final dynamic departmentsData = dataMap['departments'];

        if (departmentsData is! List) {
          return [];
        }

        return departmentsData.whereType<String>().toList();
      } else {
        throw ServerException(
          'API Error: Status ${response.statusCode}, Body: ${response.data}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network Error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  Future<List<String>> getIndustries({String? query}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (query != null && query.isNotEmpty) {
        queryParameters['query'] = query;
      }

      final Response<dynamic> response = await _dio.get<dynamic>(
        '$_baseUrl/get-industries',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;

        if (responseData is! Map<String, dynamic>) {
          return [];
        }

        final Map<String, dynamic> dataMap = responseData;
        final dynamic industriesData = dataMap['result'];

        if (industriesData is! List) {
          return [];
        }

        return industriesData.whereType<String>().toList();
      } else {
        throw ServerException(
          'API Error: Status ${response.statusCode}, Body: ${response.data}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network Error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}
