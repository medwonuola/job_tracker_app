import 'package:flutter/material.dart';
import 'package:job_tracker_app/providers/application_tracker_provider.dart';
import 'package:job_tracker_app/screens/job_detail/job_detail_screen.dart';
import 'package:job_tracker_app/theme/d3x_spacing.dart';
import 'package:provider/provider.dart';
import 'widgets/tracked_job_list_item.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
      ),
      body: Consumer<ApplicationTrackerProvider>(
        builder: (context, provider, child) {
          if (!provider.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.trackedJobs.isEmpty) {
            return const Center(
              child: Text('No tracked applications yet.'),
            );
          }

          final jobs = provider.trackedJobs.values.toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: D3XSpacing.md),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return TrackedJobListItem(
                job: job,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(job: job),
                    ),
                  );
                },
                onStatusChanged: (newStatus) {
                  if (newStatus != null) {
                    provider.updateJobStatus(job.id, newStatus);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
