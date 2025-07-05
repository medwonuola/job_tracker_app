import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/url_launcher.dart';
import 'package:job_tracker_app/core/widgets/context_button.dart';
import 'package:job_tracker_app/data/models/job.dart';
import 'package:job_tracker_app/data/providers/application_tracker_provider.dart';
import 'package:job_tracker_app/features/job_detail/widgets/job_perks_row.dart';
import 'package:provider/provider.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;
  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final trackerProvider = Provider.of<ApplicationTrackerProvider>(context);
    final bool isTracked = trackerProvider.isJobTracked(job.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(job.company.name),
        actions: [
          IconButton(
            icon: Icon(
              isTracked ? Icons.bookmark : Icons.bookmark_border,
              color: ContextColors.textPrimary,
            ),
            onPressed: () {
              if (isTracked) {
                trackerProvider.untrackJob(job.id);
              } else {
                trackerProvider.trackJob(job);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ContextSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: textTheme.displaySmall,
            ),
            const SizedBox(height: ContextSpacing.sm),
            Text(
              job.company.name,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: ContextSpacing.sm),
            Text(
              job.location.formattedAddress,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: ContextSpacing.md),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                if (job.isRemote) const Chip(label: Text('Remote')),
                if (job.company.industry != null)
                  Chip(label: Text(job.company.industry!)),
              ],
            ),
            const SizedBox(height: ContextSpacing.lg),
            JobPerksRow(perks: job.perks),
            if (job.perks.isNotEmpty) const SizedBox(height: ContextSpacing.lg),
            const Divider(),
            const SizedBox(height: ContextSpacing.lg),
            Html(
              data: job.description,
              style: {
                'body': Style.fromTextStyle(textTheme.bodyLarge!),
                'h1, h2, h3, h4, h5, h6':
                    Style.fromTextStyle(textTheme.headlineMedium!),
                'p': Style.fromTextStyle(textTheme.bodyLarge!),
                'li': Style.fromTextStyle(
                  textTheme.bodyLarge!.copyWith(height: 1.8),
                ),
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: job.applyUrl != null && job.applyUrl!.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(ContextSpacing.md),
              child: ContextButton(
                label: 'Apply Now',
                onPressed: () => AppUrlLauncher.launch(job.applyUrl!),
              ),
            )
          : null,
    );
  }
}
