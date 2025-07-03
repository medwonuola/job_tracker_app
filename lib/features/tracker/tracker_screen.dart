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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
      ),
      body: Consumer<ApplicationTrackerProvider>(
        builder: (context, provider, child) {
          if (!provider.isLoaded) {
            return const Center(
              child:
                  CircularProgressIndicator(color: ContextColors.textPrimary),
            );
          }

          if (provider.trackedJobs.isEmpty) {
            return const Center(
              child: Text('No tracked applications yet.'),
            );
          }

          final allJobs = provider.trackedJobs.values.toList();
          final filteredJobs = _selectedFilter == null
              ? allJobs
              : allJobs.where((job) => job.status == _selectedFilter).toList();

          final filterOptions = [null, ...ApplicationStatus.values];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  ContextSpacing.md,
                  ContextSpacing.sm,
                  ContextSpacing.md,
                  ContextSpacing.md,
                ),
                child: Wrap(
                  spacing: ContextSpacing.sm,
                  runSpacing: ContextSpacing.sm,
                  children: filterOptions.map((status) {
                    final isSelected = _selectedFilter == status;
                    return ChoiceChip(
                      label: Text(status?.displayName ?? 'All'),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedFilter = status;
                        });
                      },
                      labelStyle: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? ContextColors.textPrimary
                            : ContextColors.textSecondary,
                      ),
                      selectedColor: ContextColors.accent,
                      backgroundColor: ContextColors.background,
                      shape: const StadiumBorder(
                        side: BorderSide(color: ContextColors.border, width: 2),
                      ),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: filteredJobs.isEmpty
                    ? const Center(
                        child: Text('No jobs in this category.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(ContextSpacing.md),
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];
                          return TrackedJobListItem(
                            job: job,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
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
}
