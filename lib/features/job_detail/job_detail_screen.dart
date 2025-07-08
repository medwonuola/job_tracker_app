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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            color: ContextColors.border,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isTracked ? ContextColors.accent : ContextColors.background,
              border: Border.all(
                color: isTracked ? ContextColors.borderDark : ContextColors.border,
                width: 2,
              ),
            ),
            child: IconButton(
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ContextSpacing.lg),
              decoration: const BoxDecoration(
                color: ContextColors.neutralLight,
                border: Border(
                  bottom: BorderSide(color: ContextColors.border, width: 2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: ContextColors.background,
                          border: Border.all(
                            color: ContextColors.border,
                            width: 2,
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: job.company.image ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const Icon(
                            Icons.business,
                            color: ContextColors.neutral,
                            size: 32,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.business,
                            color: ContextColors.neutral,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: ContextSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (job.isQuickApply)
                              Container(
                                margin: const EdgeInsets.only(bottom: ContextSpacing.sm),
                                child: const QuickApplyBadge(showText: true),
                              ),
                            Text(
                              job.title,
                              style: textTheme.displaySmall?.copyWith(
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: ContextSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: ContextSpacing.sm,
                                vertical: ContextSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: ContextColors.accent,
                                border: Border.all(
                                  color: ContextColors.borderDark,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                job.company.name,
                                style: textTheme.titleLarge?.copyWith(
                                  color: ContextColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: ContextSpacing.sm),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: ContextColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    job.location.formattedAddress,
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ContextSpacing.lg),
                  Wrap(
                    spacing: ContextSpacing.sm,
                    runSpacing: ContextSpacing.sm,
                    children: [
                      if (job.isRemote)
                        _buildInfoChip('Remote', Icons.home, ContextColors.success),
                      if (job.company.industry != null)
                        _buildInfoChip(job.company.industry!, Icons.business, ContextColors.info),
                      if (job.company.website != null)
                        _buildInfoChip('Website', Icons.language, ContextColors.neutral),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(ContextSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JobPerksRow(perks: job.perks),
                  if (job.perks.isNotEmpty) const SizedBox(height: ContextSpacing.xl),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(ContextSpacing.md),
                    decoration: BoxDecoration(
                      color: ContextColors.neutralLight,
                      border: Border.all(
                        color: ContextColors.border,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          color: ContextColors.textPrimary,
                        ),
                        const SizedBox(width: ContextSpacing.sm),
                        Text(
                          'Job Description',
                          style: textTheme.labelLarge?.copyWith(
                            color: ContextColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(ContextSpacing.lg),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ContextColors.border,
                        width: 2,
                      ),
                    ),
                    child: Html(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: job.applyUrl != null && job.applyUrl!.isNotEmpty
          ? Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: ContextColors.border, width: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(ContextSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (job.isQuickApply)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(ContextSpacing.md),
                        margin: const EdgeInsets.only(bottom: ContextSpacing.md),
                        decoration: BoxDecoration(
                          color: ContextColors.accent.withAlpha(51),
                          border: Border.all(
                            color: ContextColors.accent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.flash_on,
                              color: ContextColors.textPrimary,
                              size: 20,
                            ),
                            const SizedBox(width: ContextSpacing.sm),
                            Text(
                              'This company uses a short application form',
                              style: textTheme.bodyMedium?.copyWith(
                                color: ContextColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ContextButton(
                      label: 'Apply Now',
                      icon: Icons.open_in_new,
                      variant: ContextButtonVariant.success,
                      onPressed: () => AppUrlLauncher.launch(job.applyUrl!),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ContextSpacing.sm,
        vertical: ContextSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(
          color: color.withAlpha(76),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: ContextSpacing.xs),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
