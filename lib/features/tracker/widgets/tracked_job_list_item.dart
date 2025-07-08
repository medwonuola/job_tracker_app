import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/extensions.dart';
import 'package:job_tracker_app/core/widgets/bordered_card.dart';
import 'package:job_tracker_app/data/models/job.dart';
import 'package:job_tracker_app/data/providers/application_tracker_provider.dart';
import 'package:provider/provider.dart';

class TrackedJobListItem extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const TrackedJobListItem({
    super.key,
    required this.job,
    required this.onTap,
  });

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return ContextColors.neutral;
      case ApplicationStatus.applied:
        return ContextColors.info;
      case ApplicationStatus.interviewing:
        return ContextColors.warning;
      case ApplicationStatus.offered:
        return ContextColors.success;
      case ApplicationStatus.rejected:
        return ContextColors.warning;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider =
        Provider.of<ApplicationTrackerProvider>(context, listen: false);
    final statusColor = _getStatusColor(job.status);

    return BorderedCard(
      onTap: onTap,
      borderColor: statusColor.withAlpha(76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
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
                    size: 20,
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.business,
                    color: ContextColors.neutral,
                    size: 20,
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
                      style: textTheme.labelLarge?.copyWith(
                        color: ContextColors.textPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: ContextSpacing.xs),
                    Text(
                      job.company.name,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: ContextSpacing.xs),
                    Text(
                      'Added ${_getTimeAgo(job.createdAt)}',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<ApplicationStatus>(
                onSelected: (ApplicationStatus newStatus) {
                  provider.updateJobStatus(job.id, newStatus);
                },
                itemBuilder: (BuildContext context) {
                  return ApplicationStatus.values.map((ApplicationStatus s) {
                    final isCurrentStatus = s == job.status;
                    final statusColor = _getStatusColor(s);
                    
                    return PopupMenuItem<ApplicationStatus>(
                      value: s,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: ContextSpacing.xs,
                        ),
                        decoration: isCurrentStatus ? BoxDecoration(
                          color: statusColor.withAlpha(25),
                          border: Border.all(
                            color: statusColor.withAlpha(76),
                            width: 1,
                          ),
                        ) : null,
                        child: Row(
                          children: [
                            Icon(
                              s.icon,
                              color: isCurrentStatus ? statusColor : ContextColors.textSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: ContextSpacing.sm),
                            Text(
                              s.displayName,
                              style: TextStyle(
                                color: isCurrentStatus ? statusColor : ContextColors.textPrimary,
                                fontWeight: isCurrentStatus ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList();
                },
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ContextColors.background,
                    border: Border.all(
                      color: ContextColors.border,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: ContextColors.textSecondary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ContextSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ContextSpacing.md,
              vertical: ContextSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25),
              border: Border.all(
                color: statusColor.withAlpha(76),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  job.status.icon,
                  size: 16,
                  color: statusColor,
                ),
                const SizedBox(width: ContextSpacing.xs),
                Text(
                  job.status.displayName,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  'Updated ${_getTimeAgo(job.lastStatusChange)}',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
