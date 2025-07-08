import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/url_launcher.dart';
import 'package:job_tracker_app/core/widgets/context_button.dart';
import 'package:job_tracker_app/core/widgets/quick_apply_badge.dart';
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
        backgroundColor: ContextColors.background,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              isTracked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isTracked ? ContextColors.accent : ContextColors.textSecondary,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: ContextColors.neutralLight,
              padding: const EdgeInsets.all(ContextSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        color: ContextColors.background,
                        child: CachedNetworkImage(
                          imageUrl: job.company.image ?? '',
                          imageBuilder: (context, imageProvider) => Image(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                          placeholder: (context, url) => const Icon(
                            Icons.domain_rounded,
                            color: ContextColors.neutral,
                            size: 32,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.domain_rounded,
                            color: ContextColors.neutral,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: ContextSpacing.xl),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (job.isQuickApply)
                              Padding(
                                padding: const EdgeInsets.only(bottom: ContextSpacing.md),
                                child: const QuickApplyBadge(showText: true),
                              ),
                            Text(
                              job.title,
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: ContextColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: ContextSpacing.sm),
                            Text(
                              job.company.name,
                              style: textTheme.titleLarge?.copyWith(
                                color: ContextColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: ContextSpacing.sm),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: ContextColors.textSecondary,
                                ),
                                const SizedBox(width: ContextSpacing.xs),
                                Expanded(
                                  child: Text(
                                    job.location.formattedAddress,
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: ContextColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ContextSpacing.xl),
                  Wrap(
                    spacing: ContextSpacing.md,
                    runSpacing: ContextSpacing.sm,
                    children: [
                      if (job.isRemote)
                        _buildInfoChip('Remote Work', ContextColors.success),
                      if (job.company.industry != null)
                        _buildInfoChip(job.company.industry!, ContextColors.info),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(ContextSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (job.perks.isNotEmpty) ...[
                    JobPerksRow(perks: job.perks),
                    const SizedBox(height: ContextSpacing.xxl),
                  ],
                  Text(
                    'Job Description',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: ContextColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: ContextSpacing.lg),
                  Html(
                    data: job.description,
                    style: {
                      'body': Style.fromTextStyle(
                        textTheme.bodyLarge!.copyWith(
                          height: 1.6,
                          color: ContextColors.textPrimary,
                        ),
                      ),
                      'h1, h2, h3, h4, h5, h6': Style.fromTextStyle(
                        textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ContextColors.textPrimary,
                        ),
                      ),
                      'p': Style.fromTextStyle(
                        textTheme.bodyLarge!.copyWith(
                          height: 1.6,
                          color: ContextColors.textPrimary,
                        ),
                      ),
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: job.applyUrl != null && job.applyUrl!.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(ContextSpacing.xl),
              decoration: const BoxDecoration(
                color: ContextColors.background,
                border: Border(
                  top: BorderSide(color: ContextColors.border),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (job.isQuickApply)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(ContextSpacing.md),
                      margin: const EdgeInsets.only(bottom: ContextSpacing.lg),
                      decoration: BoxDecoration(
                        color: ContextColors.accent.withAlpha(51),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.flash_on_rounded,
                            color: ContextColors.textPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: ContextSpacing.sm),
                          Text(
                            'Quick & Easy Application',
                            style: textTheme.bodyMedium?.copyWith(
                              color: ContextColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ContextButton(
                      label: 'Apply for this Job',
                      icon: Icons.open_in_new_rounded,
                      variant: ContextButtonVariant.success,
                      onPressed: () => AppUrlLauncher.launch(job.applyUrl!),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ContextSpacing.md,
        vertical: ContextSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
