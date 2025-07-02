import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';

class ApplicationTrackerProvider with ChangeNotifier {
  static const String _storageKey = 'tracked_jobs';

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
    final List<String> jobsJson = prefs.getStringList(_storageKey) ?? [];

    _trackedJobs = {
      for (var jsonString in jobsJson)
        (json.decode(jsonString) as Map<String, dynamic>)['id']:
            Job.fromJson(json.decode(jsonString))
    };

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jobsJson =
        _trackedJobs.values.map((job) => json.encode(job.toJson())).toList();
    await prefs.setStringList(_storageKey, jobsJson);
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
      String jobId, ApplicationStatus newStatus) async {
    if (!isJobTracked(jobId)) return;
    _trackedJobs[jobId]!.status = newStatus;
    await _saveJobs();
    notifyListeners();
  }
}
