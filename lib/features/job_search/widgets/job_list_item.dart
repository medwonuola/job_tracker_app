import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/widgets/bordered_card.dart';
import 'package:job_tracker_app/core/widgets/quick_apply_badge.dart';
import 'package:job_tracker_app/data/models/job.dart';

class JobListItem extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobListItem({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BorderedCard(
      onTap: onTap,
      padding: const EdgeInsets.all(ContextSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row - Company Logo, Title, Quick Apply
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Logo - Made larger and more prominent
              Container(
                width: 72,
                height: 72,
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
                    padding: const EdgeInsets.all(8),
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
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
              const SizedBox(width: ContextSpacing.lg),
              // Job Info - Expanded to use available space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Quick Apply Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: textTheme.headlineSmall?.copyWith(
                              color: ContextColors.textPrimary,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (job.isQuickApply) ...[
                          const SizedBox(width: ContextSpacing.sm),
                          const QuickApplyBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: ContextSpacing.sm),
                    // Company Name with Enhanced Styling
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ContextSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ContextColors.accent.withAlpha(25),
                        border: Border.all(
                          color: ContextColors.accent.withAlpha(76),
                        ),
                      ),
                      child: Text(
                        job.company.name,
                        style: textTheme.titleMedium?.copyWith(
                          color: ContextColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: ContextSpacing.lg),

          // Job Details Section
          Container(
            padding: const EdgeInsets.all(ContextSpacing.md),
            decoration: BoxDecoration(
              color: ContextColors.neutralLight,
              border: Border.all(
                color: ContextColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location and Remote Status
                Row(
                  children: [
                    const Icon(
                      Icons.location_city_rounded,
                      size: 18,
                      color: ContextColors.textSecondary,
                    ),
                    const SizedBox(width: ContextSpacing.xs),
                    Expanded(
                      child: Text(
                        job.location.formattedAddress,
                        style: textTheme.bodyLarge?.copyWith(
                          color: ContextColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (job.isRemote) ...[
                      const SizedBox(width: ContextSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ContextSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: ContextColors.success,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.home_work_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'REMOTE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                // Industry and Company Info
                if (job.company.industry != null) ...[
                  const SizedBox(height: ContextSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        Icons.category_rounded,
                        size: 16,
                        color: ContextColors.textSecondary,
                      ),
                      const SizedBox(width: ContextSpacing.xs),
                      Expanded(
                        child: Text(
                          job.company.industry!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: ContextColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Benefits and Perks Section
          if (job.perks.isNotEmpty) ...[
            const SizedBox(height: ContextSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ContextSpacing.md),
              decoration: BoxDecoration(
                color: ContextColors.accent.withAlpha(25),
                border: Border.all(
                  color: ContextColors.accent.withAlpha(76),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: ContextColors.textPrimary,
                      ),
                      const SizedBox(width: ContextSpacing.xs),
                      Text(
                        'Benefits & Perks',
                        style: textTheme.bodyMedium?.copyWith(
                          color: ContextColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ContextSpacing.sm),
                  Wrap(
                    spacing: ContextSpacing.sm,
                    runSpacing: ContextSpacing.xs,
                    children: [
                      ...job.perks.take(4).map((perk) => _buildPerkTag(perk)),
                      if (job.perks.length > 4)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ContextSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: const BoxDecoration(
                            color: ContextColors.textPrimary,
                          ),
                          child: Text(
                            '+${job.perks.length - 4} more',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: ContextColors.background,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Footer Section - Call to Action
          const SizedBox(height: ContextSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: ContextSpacing.md,
              vertical: ContextSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: ContextColors.borderDark,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'View Job Details',
                  style: textTheme.bodyMedium?.copyWith(
                    color: ContextColors.background,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: ContextColors.background,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerkTag(String perk) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ContextSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: ContextColors.background,
        border: Border.all(
          color: ContextColors.border,
        ),
      ),
      child: Text(
        perk,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: ContextColors.textSecondary,
        ),
      ),
    );
  }
}
