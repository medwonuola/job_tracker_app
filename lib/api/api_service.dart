import 'package:dio/dio.dart';
import '../models/job.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://hidden-job-board.p.rapidapi.com';
  static const String _apiKey =
      '0db1d88ad9msh5325755eeb1a162p11dd72jsn3298ebbfc37d';

  ApiService() {
    _dio.options.headers['X-RapidAPI-Key'] = _apiKey;
    _dio.options.headers['X-RapidAPI-Host'] = 'hidden-job-board.p.rapidapi.com';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<Job>> searchJobs({required String query}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/search-jobs',
        queryParameters: {
          'locationShort': 'US',
          'region': 'anywhere_in_world',
          'workplaceTypes': 'Remote',
          'jobTitleQuery': query,
          'size': 25,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jobList = response.data['jobs'];
        return jobList.map((json) => Job.fromJson(json)).toList();
      } else {
        throw Exception(
            'API Error: Status ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
