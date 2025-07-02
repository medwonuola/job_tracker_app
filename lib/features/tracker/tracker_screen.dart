import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/utils/extensions.dart';
import 'package:job_tracker_app/data/models/job.dart';
import 'package:job_tracker_app/data/providers/application_tracker_provider.dart';
import 'package:job_tracker_app/features/tracker/widgets/status_tab_view.dart';
import 'package:provider/provider.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ApplicationStatus.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Applications'),
          bottom: TabBar(
            isScrollable: true,
            tabs: ApplicationStatus.values
                .map((status) => Tab(text: status.displayName.toUpperCase()))
                .toList(),
          ),
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

            return TabBarView(
              children: ApplicationStatus.values.map((status) {
                final jobsForStatus = provider.trackedJobs.values
                    .where((job) => job.status == status)
                    .toList();
                return StatusTabView(
                  jobs: jobsForStatus,
                  status: status,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
