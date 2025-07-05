import 'package:dio/dio.dart';
import '../data/models/job.dart';
import '../data/models/search_filters.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://hidden-job-board.p.rapidapi.com';
  static const String _apiKey =
      '0db1d88ad9msh5325755eeb1a162p11dd72jsn3298ebbfc37d';

  ApiService() {
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
        final dynamic responseData = response.data;

        if (responseData is! Map<String, dynamic>) {
          throw Exception(
              'Invalid response format: expected Map, got ${responseData.runtimeType}',);
        }

        final Map<String, dynamic> dataMap = responseData;

        if (!dataMap.containsKey('jobs')) {
          return [];
        }

        final dynamic jobsData = dataMap['jobs'];

        if (jobsData == null) {
          return [];
        }

        if (jobsData is! List) {
          throw Exception(
              'Invalid jobs format: expected List, got ${jobsData.runtimeType}',);
        }

        final List<dynamic> jobList = jobsData;

        return jobList
            .whereType<Map<String, dynamic>>()
            .map((json) => Job.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'API Error: Status ${response.statusCode}, Body: ${response.data}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (e.response?.statusCode == 401) {
        throw Exception('API authentication failed. Please check API key.');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
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

        return (departmentsData)
            .whereType<String>()
            .cast<String>()
            .toList();
      } else {
        throw Exception(
          'API Error: Status ${response.statusCode}, Body: ${response.data}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
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

        return (industriesData)
            .whereType<String>()
            .cast<String>()
            .toList();
      } else {
        throw Exception(
          'API Error: Status ${response.statusCode}, Body: ${response.data}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
