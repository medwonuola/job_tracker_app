import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/extensions.dart';
import 'package:job_tracker_app/core/widgets/error_state_widget.dart';
import 'package:job_tracker_app/core/widgets/loading_state_widget.dart';
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

  static Color _getStatusColor(ApplicationStatus status) {
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<ApplicationTrackerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingStateWidget(message: 'Loading applications...');
          }

          if (provider.trackedJobs.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildJobsList(provider);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Application Tracker'),
      backgroundColor: ContextColors.background,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(height: 2, color: ContextColors.border),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ErrorStateWidget(
      title: 'No Applications Tracked',
      message: 'Start tracking your job applications to see them here',
      icon: Icons.work_outline,
      backgroundColor: ContextColors.neutralLight,
      borderColor: ContextColors.border,
    );
  }

  Widget _buildJobsList(ApplicationTrackerProvider provider) {
    final allJobs = provider.trackedJobs.values.toList();
    final filteredJobs = _selectedFilter == null
        ? allJobs
        : allJobs.where((job) => job.status == _selectedFilter).toList();
    final statusCounts = provider.getStatusCounts();

    return Column(
      children: [
        _buildFilterSection(allJobs, statusCounts),
        Expanded(
          child: filteredJobs.isEmpty
              ? _buildNoFilteredResults()
              : _buildFilteredJobsList(filteredJobs),
        ),
      ],
    );
  }

  Widget _buildFilterSection(List<Job> allJobs, Map<ApplicationStatus, int> statusCounts) {
    return Container(
      padding: const EdgeInsets.all(ContextSpacing.lg),
      decoration: const BoxDecoration(
        color: ContextColors.neutralLight,
        border: Border(bottom: BorderSide(color: ContextColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterHeader(),
          const SizedBox(height: ContextSpacing.md),
          _buildFilterChips(allJobs, statusCounts),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Row(
      children: [
        const Icon(Icons.filter_list, color: ContextColors.textPrimary),
        const SizedBox(width: ContextSpacing.sm),
        Text(
          'Filter by Status',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: ContextColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(List<Job> allJobs, Map<ApplicationStatus, int> statusCounts) {
    return SingleChildScrollView(
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
            _buildCountBadge(count, color, isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBadge(int count, Color color, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
    );
  }

  Widget _buildNoFilteredResults() {
    return ErrorStateWidget(
      title: 'No ${_selectedFilter?.displayName ?? ''} Jobs',
      message: 'Try a different filter or add more applications',
      icon: _selectedFilter?.icon ?? Icons.search_off,
      backgroundColor: ContextColors.neutralLight,
      borderColor: ContextColors.border,
    );
  }

  Widget _buildFilteredJobsList(List<Job> filteredJobs) {
    return ListView.builder(
      padding: const EdgeInsets.all(ContextSpacing.lg),
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) {
        final job = filteredJobs[index];
        return TrackedJobListItem(
          job: job,
          onTap: () => _navigateToJobDetail(job),
        );
      },
    );
  }

  void _navigateToJobDetail(Job job) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => JobDetailScreen(job: job),
      ),
    );
  }
}
