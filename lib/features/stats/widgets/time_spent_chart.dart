import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/data/models/job.dart';

class TimeSpentChart extends StatelessWidget {
  final Map<ApplicationStatus, double> averageDaysInStatus;

  const TimeSpentChart({
    super.key,
    required this.averageDaysInStatus,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasData = averageDaysInStatus.values.any((days) => days > 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Average Days in Each Status',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 200,
          child: hasData ? _buildChart() : _buildEmptyState(context),
        ),
      ],
    );
  }

  Widget _buildChart() {
    final barGroups = _buildBarGroups();
    final maxY = averageDaysInStatus.values.isNotEmpty
        ? averageDaysInStatus.values.reduce((a, b) => a > b ? a : b) * 1.2
        : 10.0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < ApplicationStatus.values.length) {
                  final status = ApplicationStatus.values[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _getShortStatusName(status),
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        gridData: FlGridData(
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.border,
            strokeWidth: 1,
          ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'No time data available yet',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return ApplicationStatus.values.asMap().entries.map((entry) {
      final index = entry.key;
      final status = entry.value;
      final days = averageDaysInStatus[status] ?? 0.0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: days,
            color: _getStatusColor(status),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return AppColors.accent;
      case ApplicationStatus.applied:
        return Colors.blue;
      case ApplicationStatus.interviewing:
        return Colors.orange;
      case ApplicationStatus.offered:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }

  String _getShortStatusName(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return 'Saved';
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.interviewing:
        return 'Interview';
      case ApplicationStatus.offered:
        return 'Offered';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }
}
