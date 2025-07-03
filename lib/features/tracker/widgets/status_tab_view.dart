import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/data/models/job.dart';
import 'package:job_tracker_app/features/job_detail/job_detail_screen.dart';
import 'package:job_tracker_app/features/tracker/widgets/tracked_job_list_item.dart';

class StatusTabView extends StatelessWidget {
  final List<Job> jobs;
  final ApplicationStatus status;

  const StatusTabView({
    super.key,
    required this.jobs,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return Center(
        child: Text('No jobs in this category.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(ContextSpacing.md),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return TrackedJobListItem(
          job: job,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => JobDetailScreen(job: job),
              ),
            );
          },
        );
      },
    );
  }
}
