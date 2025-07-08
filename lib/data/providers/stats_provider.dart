import 'package:flutter/foundation.dart';
import '../models/job.dart';
import 'application_tracker_provider.dart';

@immutable
class StatsData {
  final Map<ApplicationStatus, int> statusCounts;
  final Map<ApplicationStatus, double> averageDaysInStatus;
  final List<ApplicationTrendPoint> applicationTrend;
  final int totalApplications;
  final double averageApplicationsPerWeek;

  const StatsData({
    required this.statusCounts,
    required this.averageDaysInStatus,
    required this.applicationTrend,
    required this.totalApplications,
    required this.averageApplicationsPerWeek,
  });

  static const StatsData empty = StatsData(
    statusCounts: {},
    averageDaysInStatus: {},
    applicationTrend: [],
    totalApplications: 0,
    averageApplicationsPerWeek: 0.0,
  );
}

@immutable
class ApplicationTrendPoint {
  final DateTime date;
  final int cumulativeCount;

  const ApplicationTrendPoint({
    required this.date,
    required this.cumulativeCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationTrendPoint &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          cumulativeCount == other.cumulativeCount;

  @override
  int get hashCode => date.hashCode ^ cumulativeCount.hashCode;
}

class StatsProvider with ChangeNotifier {
  final ApplicationTrackerProvider _trackerProvider;
  StatsData _cachedStats = StatsData.empty;
  bool _disposed = false;

  StatsProvider(this._trackerProvider) {
    _trackerProvider.addListener(_invalidateCache);
    _computeStats();
  }

  void _invalidateCache() {
    if (_disposed) return;
    
    _computeStats();
    notifyListeners();
  }

  StatsData get stats => _cachedStats;

  void _computeStats() {
    final jobs = _trackerProvider.trackedJobs.values.toList();
    
    if (jobs.isEmpty) {
      _cachedStats = _createEmptyStats();
      return;
    }

    _cachedStats = StatsData(
      statusCounts: _computeStatusCounts(jobs),
      averageDaysInStatus: _computeAverageDaysInStatus(jobs),
      applicationTrend: _computeApplicationTrend(jobs),
      totalApplications: jobs.length,
      averageApplicationsPerWeek: _computeAverageApplicationsPerWeek(jobs),
    );
  }

  StatsData _createEmptyStats() {
    return StatsData(
      statusCounts: Map.fromEntries(
        ApplicationStatus.values.map((status) => MapEntry(status, 0)),
      ),
      averageDaysInStatus: const {},
      applicationTrend: const [],
      totalApplications: 0,
      averageApplicationsPerWeek: 0.0,
    );
  }

  Map<ApplicationStatus, int> _computeStatusCounts(List<Job> jobs) {
    final counts = <ApplicationStatus, int>{};
    
    for (final status in ApplicationStatus.values) {
      counts[status] = jobs.where((job) => job.status == status).length;
    }
    
    return counts;
  }

  Map<ApplicationStatus, double> _computeAverageDaysInStatus(List<Job> jobs) {
    final statusDays = <ApplicationStatus, List<int>>{};
    
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

    final averages = <ApplicationStatus, double>{};
    for (final status in ApplicationStatus.values) {
      final days = statusDays[status]!;
      averages[status] = days.isNotEmpty 
          ? days.reduce((a, b) => a + b) / days.length 
          : 0.0;
    }

    return averages;
  }

  List<ApplicationTrendPoint> _computeApplicationTrend(List<Job> jobs) {
    if (jobs.isEmpty) return [];

    final sortedJobs = List<Job>.from(jobs)
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final trend = <ApplicationTrendPoint>[];
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

    final sortedJobs = List<Job>.from(jobs)
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
    _disposed = true;
    _trackerProvider.removeListener(_invalidateCache);
    super.dispose();
  }
}
