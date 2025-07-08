import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/constants/app_constants.dart';
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(textTheme),
          const SizedBox(height: AppSpacing.lg),
          _buildJobDetails(textTheme),
          if (job.perks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _buildPerksSection(textTheme),
          ],
          const SizedBox(height: AppSpacing.md),
          _buildFooter(textTheme),
        ],
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanyLogo(),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleRow(textTheme),
              const SizedBox(height: AppSpacing.sm),
              _buildCompanyBadge(textTheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: AppConstants.logoSize.toDouble(),
      height: AppConstants.logoSize.toDouble(),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: CachedNetworkImage(
        imageUrl: job.company.image ?? '',
        imageBuilder: (context, imageProvider) => Container(
          padding: const EdgeInsets.all(8),
          child: Image(image: imageProvider, fit: BoxFit.contain),
        ),
        placeholder: (context, url) => const Icon(
          Icons.domain_rounded,
          color: AppColors.neutral,
          size: 32,
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.domain_rounded,
          color: AppColors.neutral,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildTitleRow(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            job.title,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (job.isQuickApply) ...[
          const SizedBox(width: AppSpacing.sm),
          const QuickApplyBadge(),
        ],
      ],
    );
  }

  Widget _buildCompanyBadge(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(25),
        border: Border.all(color: AppColors.accent.withAlpha(76)),
      ),
      child: Text(
        job.company.name,
        style: textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildJobDetails(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationRow(textTheme),
          if (job.company.industry != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildIndustryRow(textTheme),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationRow(TextTheme textTheme) {
    return Row(
      children: [
        const Icon(
          Icons.location_city_rounded,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            job.location.formattedAddress,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (job.isRemote) ...[
          const SizedBox(width: AppSpacing.sm),
          _buildRemoteBadge(),
        ],
      ],
    );
  }

  Widget _buildRemoteBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: const BoxDecoration(color: AppColors.success),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.home_work_rounded, size: 14, color: Colors.white),
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
    );
  }

  Widget _buildIndustryRow(TextTheme textTheme) {
    return Row(
      children: [
        const Icon(
          Icons.category_rounded,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            job.company.industry!,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPerksSection(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(25),
        border: Border.all(color: AppColors.accent.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerksHeader(textTheme),
          const SizedBox(height: AppSpacing.sm),
          _buildPerksList(),
        ],
      ),
    );
  }

  Widget _buildPerksHeader(TextTheme textTheme) {
    return Row(
      children: [
        const Icon(
          Icons.star_rounded,
          size: 16,
          color: AppColors.textPrimary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          'Benefits & Perks',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildPerksList() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        ...job.perks.take(AppConstants.maxDisplayedPerks).map(_buildPerkTag),
        if (job.perks.length > AppConstants.maxDisplayedPerks)
          _buildMorePerksTag(),
      ],
    );
  }

  Widget _buildPerkTag(String perk) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        perk,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMorePerksTag() {
    final remainingCount = job.perks.length - AppConstants.maxDisplayedPerks;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: const BoxDecoration(color: AppColors.textPrimary),
      child: Text(
        '+$remainingCount more',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.background,
        ),
      ),
    );
  }

  Widget _buildFooter(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(color: AppColors.borderDark),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'View Job Details',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 18,
            color: AppColors.background,
          ),
        ],
      ),
    );
  }
}
