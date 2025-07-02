import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_tracker_app/models/job.dart';
import 'package:job_tracker_app/theme/d3x_colors.dart';
import 'package:job_tracker_app/theme/d3x_spacing.dart';

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

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(D3XSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: job.company.image ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.contain),
                  ),
                ),
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: D3XColors.backgroundLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.business, color: D3XColors.textMuted),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: D3XColors.backgroundLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.business, color: D3XColors.textMuted),
                ),
              ),
              const SizedBox(width: D3XSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: textTheme.bodyLarge?.copyWith(
                        color: D3XColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: D3XSpacing.xs),
                    Text(
                      job.company.name,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: D3XColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
