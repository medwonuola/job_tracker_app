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

  bool isJobTracked(String jobId) => _trackedJobs.containsKey(jobId);

  Future<void> loadTrackedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jobsJsonString = prefs.getString(_storageKey);

    if (jobsJsonString != null && jobsJsonString.isNotEmpty) {
      final Map<String, dynamic> decodedMap =
          json.decode(jobsJsonString) as Map<String, dynamic>;
      _trackedJobs = decodedMap.map(
        (key, value) =>
            MapEntry(key, Job.fromJson(value as Map<String, dynamic>)),
      );
    } else {
      _trackedJobs = {};
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> jsonMap =
        _trackedJobs.map((k, v) => MapEntry(k, v.toJson()));
    final String jsonString = json.encode(jsonMap);
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
      String jobId, ApplicationStatus newStatus,) async {
    if (!_trackedJobs.containsKey(jobId)) return;
    _trackedJobs[jobId]!.status = newStatus;
    await _saveJobs();
    notifyListeners();
  }
}
