import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/widgets/error_state_widget.dart';
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
      appBar: _buildAppBar(),
      body: Consumer<StatsProvider>(
        builder: (context, provider, child) {
          final stats = provider.stats;

          if (stats.totalApplications == 0) {
            return _buildEmptyState();
          }

          return _buildStatsContent(stats);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Analytics Dashboard'),
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(height: 2, color: AppColors.border),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const ErrorStateWidget(
      title: 'No Analytics Data',
      message: 'Track job applications to see your analytics here',
      icon: Icons.bar_chart,
      backgroundColor: AppColors.neutralLight,
      borderColor: AppColors.border,
    );
  }

  Widget _buildStatsContent(StatsData stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummarySection(stats),
          const SizedBox(height: AppSpacing.xl),
          _buildChartSection(
            title: 'Status Distribution',
            icon: Icons.pie_chart,
            child: ApplicationStatusChart(statusCounts: stats.statusCounts),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildChartSection(
            title: 'Time in Each Status',
            icon: Icons.access_time,
            child: TimeSpentChart(averageDaysInStatus: stats.averageDaysInStatus),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildChartSection(
            title: 'Application Trend',
            icon: Icons.trending_up,
            child: ApplicationTrendChart(trendData: stats.applicationTrend),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(StatsData stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Overview', Icons.dashboard),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Applications',
                stats.totalApplications.toString(),
                Icons.work_outline,
                AppColors.info,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildSummaryCard(
                'Weekly Average',
                stats.averageApplicationsPerWeek.toStringAsFixed(1),
                Icons.timeline,
                AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accent,
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: color),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
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
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.neutralLight,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textPrimary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ],
    );
  }
}
