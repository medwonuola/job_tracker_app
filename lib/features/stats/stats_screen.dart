import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/data/providers/stats_provider.dart';
import 'package:job_tracker_app/features/stats/widgets/application_status_chart.dart';
import 'package:job_tracker_app/features/stats/widgets/time_spent_chart.dart';
import 'package:job_tracker_app/features/stats/widgets/application_trend_chart.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Consumer<StatsProvider>(
        builder: (context, provider, child) {
          final stats = provider.stats;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(ContextSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(context, stats),
                const SizedBox(height: ContextSpacing.xl),
                _buildChartSection(
                  child: ApplicationStatusChart(
                    statusCounts: stats.statusCounts,
                  ),
                ),
                const SizedBox(height: ContextSpacing.xl),
                _buildChartSection(
                  child: TimeSpentChart(
                    averageDaysInStatus: stats.averageDaysInStatus,
                  ),
                ),
                const SizedBox(height: ContextSpacing.xl),
                _buildChartSection(
                  child: ApplicationTrendChart(
                    trendData: stats.applicationTrend,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, StatsData stats) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            context,
            'Total Applications',
            stats.totalApplications.toString(),
            Icons.work_outline,
          ),
        ),
        const SizedBox(width: ContextSpacing.md),
        Expanded(
          child: _buildSummaryCard(
            context,
            'Per Week',
            stats.averageApplicationsPerWeek.toStringAsFixed(1),
            Icons.timeline,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(ContextSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: ContextColors.border,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: ContextColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: ContextSpacing.xs),
              Text(
                title,
                style: textTheme.bodySmall?.copyWith(
                  color: ContextColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: ContextSpacing.xs),
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              color: ContextColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(ContextSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(
          color: ContextColors.border,
          width: 2.0,
        ),
      ),
      child: child,
    );
  }
}
