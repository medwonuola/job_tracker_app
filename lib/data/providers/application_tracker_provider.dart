import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';

class ApplicationTrackerProvider with ChangeNotifier {
  static const String _storageKey = 'tracked_jobs_map';

  Map<String, Job> _trackedJobs = {};
  Map<String, Job> get trackedJobs => _trackedJobs;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  ApplicationTrackerProvider() {
    loadTrackedJobs();
  }

  bool isJobTracked(String jobId) {
    return _trackedJobs.containsKey(jobId);
  }

  Future<void> loadTrackedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jobsJsonString = prefs.getString(_storageKey);

    if (jobsJsonString != null && jobsJsonString.isNotEmpty) {
      final Map<String, dynamic> decodedMap = json.decode(jobsJsonString);
      _trackedJobs = decodedMap.map(
        (key, value) => MapEntry(key, Job.fromJson(value)),
      );
    } else {
      _trackedJobs = {};
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(_trackedJobs);
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> trackJob(Job job) async {
    if (isJobTracked(job.id)) return;
    _trackedJobs[job.id] = job;
    await _saveJobs();
    notifyListeners();
  }

  Future<void> untrackJob(String jobId) async {
    if (!isJobTracked(jobId)) return;
    _trackedJobs.remove(jobId);
    await _saveJobs();
    notifyListeners();
  }

  Future<void> updateJobStatus(
    String jobId,
    ApplicationStatus newStatus,
  ) async {
    if (!_trackedJobs.containsKey(jobId)) return;
    _trackedJobs[jobId]!.status = newStatus;
    await _saveJobs();
    notifyListeners();
  }
}
