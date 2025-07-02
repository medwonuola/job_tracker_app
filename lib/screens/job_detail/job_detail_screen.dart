import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:job_tracker_app/models/job.dart';
import 'package:job_tracker_app/providers/application_tracker_provider.dart';
import 'package:job_tracker_app/theme/d3x_colors.dart';
import 'package:job_tracker_app/theme/d3x_spacing.dart';
import 'package:job_tracker_app/utils/url_launcher.dart';
import 'package:job_tracker_app/widgets/d3x_button.dart';
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(D3XSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: textTheme.headlineMedium
                  ?.copyWith(color: D3XColors.textPrimary),
            ),
            const SizedBox(height: D3XSpacing.sm),
            Text(
              job.company.name,
              style: textTheme.bodyLarge?.copyWith(color: D3XColors.textMuted),
            ),
            const SizedBox(height: D3XSpacing.sm),
            Wrap(
              spacing: 8.0,
              children: [
                if (job.isRemote) const Chip(label: Text('Remote')),
                if (job.company.industry != null)
                  Chip(label: Text(job.company.industry!)),
              ],
            ),
            const SizedBox(height: D3XSpacing.lg),
            const Divider(color: D3XColors.backgroundLight),
            const SizedBox(height: D3XSpacing.lg),
            Html(
              data: job.description,
              style: {
                "body": Style(
                  fontSize: FontSize(textTheme.bodyMedium!.fontSize!),
                  color: textTheme.bodyMedium!.color,
                  lineHeight: LineHeight(textTheme.bodyMedium!.height!),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "h4": Style(
                  fontSize: FontSize(textTheme.bodyLarge!.fontSize!),
                  color: D3XColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                "p": Style(
                  fontSize: FontSize(textTheme.bodyMedium!.fontSize!),
                  color: textTheme.bodyMedium!.color,
                  lineHeight: LineHeight(textTheme.bodyMedium!.height!),
                ),
                "li": Style(
                  lineHeight: LineHeight(textTheme.bodyMedium!.height!),
                  listStylePosition: ListStylePosition.outside,
                ),
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(D3XSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: D3XButton(
                variant: isTracked
                    ? D3XButtonVariant.outline
                    : D3XButtonVariant.primary,
                label: isTracked ? 'Untrack' : 'Track',
                onPressed: () {
                  if (isTracked) {
                    trackerProvider.untrackJob(job.id);
                  } else {
                    trackerProvider.trackJob(job);
                  }
                },
              ),
            ),
            if (job.applyUrl != null && job.applyUrl!.isNotEmpty) ...[
              const SizedBox(width: D3XSpacing.md),
              Expanded(
                child: D3XButton(
                  variant: D3XButtonVariant.primary,
                  label: 'Apply Now',
                  onPressed: () => AppUrlLauncher.launch(job.applyUrl!),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
