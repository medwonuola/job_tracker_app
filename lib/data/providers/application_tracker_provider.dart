import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';
import '../../core/constants/app_constants.dart';

class ApplicationTrackerProvider with ChangeNotifier {
  Map<String, Job> _trackedJobs = {};
  Map<String, Job> get trackedJobs => Map.unmodifiable(_trackedJobs);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _disposed = false;

  ApplicationTrackerProvider();

  bool isJobTracked(String jobId) => _trackedJobs.containsKey(jobId);

  Future<void> loadTrackedJobs() async {
    if (_disposed) return;

    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final jobsJsonString = prefs.getString(AppConstants.storageKeyTrackedJobs);

      if (jobsJsonString != null && jobsJsonString.isNotEmpty) {
        final decodedMap = json.decode(jobsJsonString) as Map<String, dynamic>;
        _trackedJobs = decodedMap.map(
          (key, value) => MapEntry(
            key, 
            Job.fromJson(value as Map<String, dynamic>),
          ),
        );
      } else {
        _trackedJobs = {};
      }
    } catch (e) {
      debugPrint('Error loading tracked jobs: $e');
      _trackedJobs = {};
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (_disposed) return;
    
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> _saveJobs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonMap = _trackedJobs.map((k, v) => MapEntry(k, v.toJson()));
      final jsonString = json.encode(jsonMap);
      await prefs.setString(AppConstants.storageKeyTrackedJobs, jsonString);
    } catch (e) {
      debugPrint('Error saving tracked jobs: $e');
    }
  }

  Future<void> trackJob(Job job) async {
    if (_disposed || isJobTracked(job.id)) return;

    final now = DateTime.now();
    final jobToTrack = Job(
      id: job.id,
      title: job.title,
      description: job.description,
      applyUrl: job.applyUrl,
      isRemote: job.isRemote,
      company: job.company,
      location: job.location,
      perks: job.perks,
      applicationFormEase: job.applicationFormEase,
      createdAt: now,
      lastStatusChange: now,
      statusHistory: {now.toIso8601String(): ApplicationStatus.saved.name},
    );

    _trackedJobs[job.id] = jobToTrack;
    await _saveJobs();
    
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> untrackJob(String jobId) async {
    if (_disposed || !isJobTracked(jobId)) return;

    _trackedJobs.remove(jobId);
    await _saveJobs();
    
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> updateJobStatus(String jobId, ApplicationStatus newStatus) async {
    if (_disposed || !_trackedJobs.containsKey(jobId)) return;

    final job = _trackedJobs[jobId]!;
    if (job.status == newStatus) return;

    job.updateStatus(newStatus);
    await _saveJobs();
    
    if (!_disposed) {
      notifyListeners();
    }
  }

  List<Job> getJobsByStatus(ApplicationStatus status) {
    return _trackedJobs.values
        .where((job) => job.status == status)
        .toList();
  }

  Map<ApplicationStatus, int> getStatusCounts() {
    final counts = <ApplicationStatus, int>{};
    for (final status in ApplicationStatus.values) {
      counts[status] = getJobsByStatus(status).length;
    }
    return counts;
  }

  List<Job> getJobsCreatedInDateRange(DateTime start, DateTime end) {
    return _trackedJobs.values
        .where((job) => 
            job.createdAt.isAfter(start.subtract(const Duration(days: 1))) &&
            job.createdAt.isBefore(end.add(const Duration(days: 1))),)
        .toList();
  }

  int get totalTrackedJobs => _trackedJobs.length;

  void clearAllJobs() {
    if (_disposed) return;
    
    _trackedJobs.clear();
    _saveJobs();
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
