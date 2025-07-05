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

      final Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/search-jobs',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jobList = response.data!['jobs'] as List<dynamic>;
        return jobList
            .map((json) => Job.fromJson(json as Map<String, dynamic>))
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

  Future<List<String>> getDepartments({String? query}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (query != null && query.isNotEmpty) {
        queryParameters['query'] = query;
      }

      final Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/get-departments',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> departments =
            response.data!['departments'] as List<dynamic>;
        return departments.cast<String>();
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

      final Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/get-industries',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> industries =
            response.data!['industries'] as List<dynamic>;
        return industries.cast<String>();
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
