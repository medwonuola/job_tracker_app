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
        return AppColors.neutral;
      case ApplicationStatus.applied:
        return AppColors.info;
      case ApplicationStatus.interviewing:
        return AppColors.warning;
      case ApplicationStatus.offered:
        return AppColors.success;
      case ApplicationStatus.rejected:
        return AppColors.warning;
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
          const SizedBox(height: AppSpacing.md),
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
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildJobInfo(textTheme)),
        _buildStatusMenu(context),
      ],
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: AppConstants.companyLogoSize.toDouble(),
      height: AppConstants.companyLogoSize.toDouble(),
      color: AppColors.neutralLight,
      child: CachedNetworkImage(
        imageUrl: job.company.image ?? '',
        imageBuilder: (context, imageProvider) => Image(
          image: imageProvider,
          fit: BoxFit.contain,
        ),
        placeholder: (context, url) => const Icon(
          Icons.domain_rounded,
          color: AppColors.neutral,
          size: 20,
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.domain_rounded,
          color: AppColors.neutral,
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
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          job.company.name,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Added ${DateFormatter.getTimeAgo(job.createdAt)}',
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
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
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
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
            color: AppColors.textSecondary,
          ),
        );
      },
    );
  }

  Widget _buildStatusContainer(TextTheme textTheme, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(color: statusColor.withAlpha(25)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(job.status.icon, size: 16, color: statusColor),
          const SizedBox(width: AppSpacing.xs),
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
