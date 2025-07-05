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

    return Stack(
      children: [
        BorderedCard(
          onTap: onTap,
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: job.company.image ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.contain),
                  ),
                ),
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 50,
                  color: ContextColors.background,
                  child: const Icon(
                    Icons.business,
                    color: ContextColors.textSecondary,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 50,
                  color: ContextColors.background,
                  child: const Icon(
                    Icons.business,
                    color: ContextColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: ContextSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: textTheme.labelLarge
                          ?.copyWith(color: ContextColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: ContextSpacing.xs),
                    Text(
                      job.company.name,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (job.isQuickApply)
          Positioned(
            top: ContextSpacing.sm,
            right: ContextSpacing.sm,
            child: const QuickApplyBadge(size: 20.0),
          ),
      ],
    );
  }
}
