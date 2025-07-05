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
        return _parseJobsResponse(response.data);
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

  List<Job> _parseJobsResponse(dynamic responseData) {
    try {
      List<dynamic> jobsArray;

      if (responseData is List) {
        jobsArray = responseData;
      } else if (responseData is Map<String, dynamic>) {
        final dataMap = responseData;
        
        if (dataMap.containsKey('jobs') && dataMap['jobs'] is List) {
          jobsArray = dataMap['jobs'] as List<dynamic>;
        } else if (dataMap.containsKey('data') && dataMap['data'] is List) {
          jobsArray = dataMap['data'] as List<dynamic>;
        } else if (dataMap.containsKey('results') && dataMap['results'] is List) {
          jobsArray = dataMap['results'] as List<dynamic>;
        } else {
          final possibleArrays = dataMap.values.where((value) => value is List).toList();
          if (possibleArrays.isNotEmpty) {
            jobsArray = possibleArrays.first as List<dynamic>;
          } else {
            return [];
          }
        }
      } else {
        throw Exception('Unexpected response format: ${responseData.runtimeType}');
      }

      return jobsArray
          .whereType<Map<String, dynamic>>()
          .map((json) => _parseJobJson(json))
          .where((job) => job != null)
          .cast<Job>()
          .toList();
    } catch (e) {
      throw Exception('Failed to parse jobs response: $e');
    }
  }

  Job? _parseJobJson(Map<String, dynamic> json) {
    try {
      final jobData = <String, dynamic>{};
      
      jobData['id'] = json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
      jobData['title'] = json['title']?.toString() ?? 'No Title';
      jobData['description'] = json['description']?.toString() ?? '';
      jobData['applyUrl'] = json['applyUrl']?.toString() ?? json['apply_url']?.toString();
      jobData['isRemote'] = json['isRemote'] ?? json['is_remote'] ?? json['remote'] ?? false;
      
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
          'name': json['company_name'] ?? json['companyName'] ?? 'Unknown Company',
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
