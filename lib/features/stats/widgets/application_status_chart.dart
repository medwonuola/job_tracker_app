import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/extensions.dart';
import 'package:job_tracker_app/data/models/job.dart';

class ApplicationStatusChart extends StatelessWidget {
  final Map<ApplicationStatus, int> statusCounts;

  const ApplicationStatusChart({
    super.key,
    required this.statusCounts,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final totalCount = statusCounts.values.fold(0, (sum, count) => sum + count);

    if (totalCount == 0) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No applications tracked yet',
            style: textTheme.bodyMedium,
          ),
        ),
      );
    }

    final sections = _buildPieChartSections();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Application Status Distribution',
          style: textTheme.labelLarge?.copyWith(
            color: ContextColors.textPrimary,
          ),
        ),
        const SizedBox(height: ContextSpacing.md),
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(width: ContextSpacing.md),
              Expanded(
                child: _buildLegend(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final colors = [
      ContextColors.accent,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
    ];

    final nonZeroStatuses = statusCounts.entries
        .where((entry) => entry.value > 0)
        .toList();

    return nonZeroStatuses.asMap().entries.map((entry) {
      final index = entry.key;
      final statusEntry = entry.value;
      final count = statusEntry.value;
      final total = statusCounts.values.fold(0, (sum, count) => sum + count);
      final percentage = (count / total * 100).toInt();

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: count.toDouble(),
        title: '$percentage%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = [
      ContextColors.accent,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
    ];

    final nonZeroStatuses = statusCounts.entries
        .where((entry) => entry.value > 0)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: nonZeroStatuses.asMap().entries.map((entry) {
        final index = entry.key;
        final statusEntry = entry.value;
        final status = statusEntry.key;
        final count = statusEntry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: ContextSpacing.xs),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: ContextSpacing.xs),
              Expanded(
                child: Text(
                  '${status.displayName} ($count)',
                  style: textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
