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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: ContextColors.neutralLight,
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
                    size: 24,
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.business,
                    color: ContextColors.neutral,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: ContextSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: textTheme.labelLarge?.copyWith(
                              color: ContextColors.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (job.isQuickApply) ...[
                          const SizedBox(width: ContextSpacing.sm),
                          const QuickApplyBadge(size: 20.0),
                        ],
                      ],
                    ),
                    const SizedBox(height: ContextSpacing.xs),
                    Text(
                      job.company.name,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: ContextSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: ContextColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            job.location.formattedAddress,
                            style: textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (job.perks.isNotEmpty || job.isRemote || job.company.industry != null) ...[
            const SizedBox(height: ContextSpacing.md),
            Wrap(
              spacing: ContextSpacing.xs,
              runSpacing: ContextSpacing.xs,
              children: [
                if (job.isRemote)
                  _buildTag('Remote', ContextColors.success),
                if (job.company.industry != null)
                  _buildTag(job.company.industry!, ContextColors.info),
                ...job.perks.take(2).map((perk) => _buildTag(perk, ContextColors.neutral)),
                if (job.perks.length > 2)
                  _buildTag('+${job.perks.length - 2} more', ContextColors.accent),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ContextSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(
          color: color.withAlpha(76),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color == ContextColors.accent 
              ? ContextColors.textPrimary 
              : color,
        ),
      ),
    );
  }
}
