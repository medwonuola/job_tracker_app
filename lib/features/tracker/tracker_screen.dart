import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/extensions.dart';
import 'package:job_tracker_app/data/models/job.dart';
import 'package:job_tracker_app/data/providers/application_tracker_provider.dart';
import 'package:job_tracker_app/features/job_detail/job_detail_screen.dart';
import 'package:job_tracker_app/features/tracker/widgets/tracked_job_list_item.dart';
import 'package:provider/provider.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  ApplicationStatus? _selectedFilter;

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return ContextColors.neutral;
      case ApplicationStatus.applied:
        return ContextColors.info;
      case ApplicationStatus.interviewing:
        return ContextColors.warning;
      case ApplicationStatus.offered:
        return ContextColors.success;
      case ApplicationStatus.rejected:
        return ContextColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Tracker'),
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
      body: Consumer<ApplicationTrackerProvider>(
        builder: (context, provider, child) {
          if (provider.trackedJobs.isEmpty) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(ContextSpacing.lg),
                padding: const EdgeInsets.all(ContextSpacing.xl),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ContextColors.border,
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
                        ),
                      ),
                      child: const Icon(
                        Icons.work_outline,
                        color: ContextColors.neutral,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: ContextSpacing.lg),
                    Text(
                      'No Applications Tracked',
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: ContextSpacing.sm),
                    const Text(
                      'Start tracking your job applications to see them here',
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

          final allJobs = provider.trackedJobs.values.toList();
          final filteredJobs = _selectedFilter == null
              ? allJobs
              : allJobs.where((job) => job.status == _selectedFilter).toList();

          final statusCounts = provider.getStatusCounts();

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(ContextSpacing.lg),
                decoration: const BoxDecoration(
                  color: ContextColors.neutralLight,
                  border: Border(
                    bottom: BorderSide(color: ContextColors.border),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.filter_list,
                          color: ContextColors.textPrimary,
                        ),
                        const SizedBox(width: ContextSpacing.sm),
                        Text(
                          'Filter by Status',
                          style: textTheme.labelLarge?.copyWith(
                            color: ContextColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: ContextSpacing.md),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            'All',
                            allJobs.length,
                            _selectedFilter == null,
                            ContextColors.accent,
                            () => setState(() => _selectedFilter = null),
                          ),
                          const SizedBox(width: ContextSpacing.sm),
                          ...ApplicationStatus.values.map((status) {
                            final count = statusCounts[status] ?? 0;
                            return Padding(
                              padding: const EdgeInsets.only(right: ContextSpacing.sm),
                              child: _buildFilterChip(
                                status.displayName,
                                count,
                                _selectedFilter == status,
                                _getStatusColor(status),
                                () => setState(() => _selectedFilter = status),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredJobs.isEmpty
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(ContextSpacing.lg),
                          padding: const EdgeInsets.all(ContextSpacing.lg),
                          decoration: BoxDecoration(
                            color: ContextColors.neutralLight,
                            border: Border.all(
                              color: ContextColors.border,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _selectedFilter?.icon ?? Icons.search_off,
                                color: ContextColors.neutral,
                                size: 48,
                              ),
                              const SizedBox(height: ContextSpacing.md),
                              Text(
                                'No ${_selectedFilter?.displayName ?? ''} Jobs',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: ContextColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: ContextSpacing.sm),
                              const Text(
                                'Try a different filter or add more applications',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ContextColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(ContextSpacing.lg),
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];
                          return TrackedJobListItem(
                            job: job,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) =>
                                      JobDetailScreen(job: job),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    int count,
    bool isSelected,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ContextSpacing.md,
          vertical: ContextSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : ContextColors.background,
          border: Border.all(
            color: isSelected ? ContextColors.borderDark : ContextColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (color == ContextColors.accent 
                        ? ContextColors.textPrimary 
                        : Colors.white)
                    : ContextColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: ContextSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? (color == ContextColors.accent 
                        ? ContextColors.textPrimary 
                        : Colors.white.withAlpha(51))
                    : color.withAlpha(51),
                border: Border.all(
                  color: isSelected
                      ? (color == ContextColors.accent 
                          ? ContextColors.textPrimary 
                          : Colors.white)
                      : color,
                ),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected
                      ? (color == ContextColors.accent 
                          ? ContextColors.background 
                          : color)
                      : color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
