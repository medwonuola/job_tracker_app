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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        backgroundColor: ContextColors.background,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            color: ContextColors.border,
          ),
        ),
      ),
      body: Consumer<StatsProvider>(
        builder: (context, provider, child) {
          final stats = provider.stats;

          if (stats.totalApplications == 0) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(ContextSpacing.lg),
                padding: const EdgeInsets.all(ContextSpacing.xl),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ContextColors.border,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ContextSpacing.lg),
                      decoration: BoxDecoration(
                        color: ContextColors.neutralLight,
                        border: Border.all(
                          color: ContextColors.border,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.bar_chart,
                        color: ContextColors.neutral,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: ContextSpacing.lg),
                    Text(
                      'No Analytics Data',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: ContextSpacing.sm),
                    const Text(
                      'Track job applications to see your analytics here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ContextColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(ContextSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(context, stats),
                const SizedBox(height: ContextSpacing.xl),
                _buildChartSection(
                  title: 'Status Distribution',
                  icon: Icons.pie_chart,
                  child: ApplicationStatusChart(
                    statusCounts: stats.statusCounts,
                  ),
                ),
                const SizedBox(height: ContextSpacing.xl),
                _buildChartSection(
                  title: 'Time in Each Status',
                  icon: Icons.access_time,
                  child: TimeSpentChart(
                    averageDaysInStatus: stats.averageDaysInStatus,
                  ),
                ),
                const SizedBox(height: ContextSpacing.xl),
                _buildChartSection(
                  title: 'Application Trend',
                  icon: Icons.trending_up,
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

  Widget _buildSummarySection(BuildContext context, StatsData stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ContextSpacing.md),
          decoration: BoxDecoration(
            color: ContextColors.accent,
            border: Border.all(
              color: ContextColors.borderDark,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.dashboard,
                color: ContextColors.textPrimary,
              ),
              const SizedBox(width: ContextSpacing.sm),
              Text(
                'Overview',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: ContextColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Total Applications',
                stats.totalApplications.toString(),
                Icons.work_outline,
                ContextColors.info,
              ),
            ),
            const SizedBox(width: ContextSpacing.md),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Weekly Average',
                stats.averageApplicationsPerWeek.toStringAsFixed(1),
                Icons.timeline,
                ContextColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(ContextSpacing.lg),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(
          color: color.withAlpha(76),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ContextSpacing.xs),
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: color,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: ContextSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ContextSpacing.md),
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ContextSpacing.md),
          decoration: BoxDecoration(
            color: ContextColors.neutralLight,
            border: Border.all(
              color: ContextColors.border,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: ContextColors.textPrimary,
              ),
              const SizedBox(width: ContextSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: ContextColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ContextSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(
              color: ContextColors.border,
              width: 2,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
