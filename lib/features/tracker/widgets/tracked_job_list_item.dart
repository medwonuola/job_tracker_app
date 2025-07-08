import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/constants/app_constants.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/date_formatter.dart';
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

  static Color _getStatusColor(ApplicationStatus status) {
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final statusColor = _getStatusColor(job.status);

    return BorderedCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, textTheme),
          const SizedBox(height: ContextSpacing.md),
          _buildStatusContainer(textTheme, statusColor),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanyLogo(),
        const SizedBox(width: ContextSpacing.md),
        Expanded(child: _buildJobInfo(textTheme)),
        _buildStatusMenu(context),
      ],
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: AppConstants.companyLogoSize.toDouble(),
      height: AppConstants.companyLogoSize.toDouble(),
      color: ContextColors.neutralLight,
      child: CachedNetworkImage(
        imageUrl: job.company.image ?? '',
        imageBuilder: (context, imageProvider) => Image(
          image: imageProvider,
          fit: BoxFit.contain,
        ),
        placeholder: (context, url) => const Icon(
          Icons.domain_rounded,
          color: ContextColors.neutral,
          size: 20,
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.domain_rounded,
          color: ContextColors.neutral,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildJobInfo(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.title,
          style: textTheme.titleMedium?.copyWith(
            color: ContextColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: ContextSpacing.xs),
        Text(
          job.company.name,
          style: textTheme.bodyMedium?.copyWith(
            color: ContextColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: ContextSpacing.xs),
        Text(
          'Added ${DateFormatter.getTimeAgo(job.createdAt)}',
          style: textTheme.bodySmall?.copyWith(
            color: ContextColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusMenu(BuildContext context) {
    return Consumer<ApplicationTrackerProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<ApplicationStatus>(
          onSelected: (newStatus) => provider.updateJobStatus(job.id, newStatus),
          itemBuilder: (context) => ApplicationStatus.values.map((status) {
            final isCurrentStatus = status == job.status;
            return PopupMenuItem<ApplicationStatus>(
              value: status,
              child: Row(
                children: [
                  Icon(
                    status.icon,
                    color: isCurrentStatus 
                        ? _getStatusColor(status) 
                        : ContextColors.textSecondary,
                  ),
                  const SizedBox(width: ContextSpacing.sm),
                  Text(
                    status.displayName,
                    style: TextStyle(
                      fontWeight: isCurrentStatus 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          icon: const Icon(
            Icons.more_vert_rounded,
            color: ContextColors.textSecondary,
          ),
        );
      },
    );
  }

  Widget _buildStatusContainer(TextTheme textTheme, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ContextSpacing.md,
        vertical: ContextSpacing.sm,
      ),
      decoration: BoxDecoration(color: statusColor.withAlpha(25)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(job.status.icon, size: 16, color: statusColor),
          const SizedBox(width: ContextSpacing.xs),
          Text(
            job.status.displayName,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
