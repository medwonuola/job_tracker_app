import 'package:flutter/foundation.dart';
import '../models/job.dart';
import 'application_tracker_provider.dart';

class StatsData {
  final Map<ApplicationStatus, int> statusCounts;
  final Map<ApplicationStatus, double> averageDaysInStatus;
  final List<ApplicationTrendPoint> applicationTrend;
  final int totalApplications;
  final double averageApplicationsPerWeek;

  StatsData({
    required this.statusCounts,
    required this.averageDaysInStatus,
    required this.applicationTrend,
    required this.totalApplications,
    required this.averageApplicationsPerWeek,
  });
}

class ApplicationTrendPoint {
  final DateTime date;
  final int cumulativeCount;

  ApplicationTrendPoint({
    required this.date,
    required this.cumulativeCount,
  });
}

class StatsProvider with ChangeNotifier {
  final ApplicationTrackerProvider _trackerProvider;
  StatsData? _cachedStats;

  StatsProvider(this._trackerProvider) {
    _trackerProvider.addListener(_invalidateCache);
  }

  void _invalidateCache() {
    _cachedStats = null;
    notifyListeners();
  }

  StatsData get stats {
    _cachedStats ??= _computeStats();
    return _cachedStats!;
  }

  StatsData _computeStats() {
    final jobs = _trackerProvider.trackedJobs.values.toList();
    
    if (jobs.isEmpty) {
      return StatsData(
        statusCounts: Map.fromEntries(
          ApplicationStatus.values.map((status) => MapEntry(status, 0)),
        ),
        averageDaysInStatus: {},
        applicationTrend: [],
        totalApplications: 0,
        averageApplicationsPerWeek: 0.0,
      );
    }

    final statusCounts = _computeStatusCounts(jobs);
    final averageDaysInStatus = _computeAverageDaysInStatus(jobs);
    final applicationTrend = _computeApplicationTrend(jobs);
    final averageApplicationsPerWeek = _computeAverageApplicationsPerWeek(jobs);

    return StatsData(
      statusCounts: statusCounts,
      averageDaysInStatus: averageDaysInStatus,
      applicationTrend: applicationTrend,
      totalApplications: jobs.length,
      averageApplicationsPerWeek: averageApplicationsPerWeek,
    );
  }

  Map<ApplicationStatus, int> _computeStatusCounts(List<Job> jobs) {
    final Map<ApplicationStatus, int> counts = {};
    for (final status in ApplicationStatus.values) {
      counts[status] = jobs.where((job) => job.status == status).length;
    }
    return counts;
  }

  Map<ApplicationStatus, double> _computeAverageDaysInStatus(List<Job> jobs) {
    final Map<ApplicationStatus, List<int>> statusDays = {};
    
    for (final status in ApplicationStatus.values) {
      statusDays[status] = [];
    }

    for (final job in jobs) {
      for (final status in ApplicationStatus.values) {
        final days = job.getDaysInStatus(status);
        if (days > 0) {
          statusDays[status]!.add(days);
        }
      }
    }

    final Map<ApplicationStatus, double> averages = {};
    for (final status in ApplicationStatus.values) {
      final days = statusDays[status]!;
      if (days.isNotEmpty) {
        averages[status] = days.reduce((a, b) => a + b) / days.length;
      } else {
        averages[status] = 0.0;
      }
    }

    return averages;
  }

  List<ApplicationTrendPoint> _computeApplicationTrend(List<Job> jobs) {
    if (jobs.isEmpty) return [];

    final sortedJobs = jobs.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final List<ApplicationTrendPoint> trend = [];
    final startDate = sortedJobs.first.createdAt;
    final endDate = DateTime.now();
    
    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    var jobIndex = 0;
    var cumulativeCount = 0;

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      while (jobIndex < sortedJobs.length &&
             sortedJobs[jobIndex].createdAt.isBefore(currentDate.add(const Duration(days: 1)))) {
        cumulativeCount++;
        jobIndex++;
      }

      trend.add(ApplicationTrendPoint(
        date: currentDate,
        cumulativeCount: cumulativeCount,
      ),);

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return trend;
  }

  double _computeAverageApplicationsPerWeek(List<Job> jobs) {
    if (jobs.isEmpty) return 0.0;

    final sortedJobs = jobs.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final startDate = sortedJobs.first.createdAt;
    final endDate = DateTime.now();
    final totalDays = endDate.difference(startDate).inDays;
    
    if (totalDays == 0) return jobs.length.toDouble() * 7;

    final totalWeeks = totalDays / 7.0;
    return jobs.length / totalWeeks;
  }

  @override
  void dispose() {
    _trackerProvider.removeListener(_invalidateCache);
    super.dispose();
  }
}
