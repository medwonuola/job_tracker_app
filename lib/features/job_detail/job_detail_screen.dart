import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:job_tracker_app/core/constants/app_constants.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/url_launcher.dart';
import 'package:job_tracker_app/core/widgets/app_button.dart';
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
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomActionBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(job.company.name),
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      actions: [_buildBookmarkButton(context)],
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return Consumer<ApplicationTrackerProvider>(
      builder: (context, provider, child) {
        final isTracked = provider.isJobTracked(job.id);
        
        return IconButton(
          icon: Icon(
            isTracked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: isTracked ? AppColors.accent : AppColors.textSecondary,
          ),
          onPressed: () => _toggleJobTracking(context, provider, isTracked),
        );
      },
    );
  }

  void _toggleJobTracking(
    BuildContext context,
    ApplicationTrackerProvider provider,
    bool isTracked,
  ) {
    if (isTracked) {
      provider.untrackJob(job.id);
    } else {
      provider.trackJob(job);
    }
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJobHeader(context),
          _buildJobContent(context),
        ],
      ),
    );
  }

  Widget _buildJobHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.neutralLight,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompanyLogoAndDetails(context),
          const SizedBox(height: AppSpacing.xl),
          _buildJobTags(),
        ],
      ),
    );
  }

  Widget _buildCompanyLogoAndDetails(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanyLogo(),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (job.isQuickApply) ...[
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: QuickApplyBadge(showText: true),
                ),
              ],
              Text(
                job.title,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                job.company.name,
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildLocationInfo(textTheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: AppConstants.largeLogoSize.toDouble(),
      height: AppConstants.largeLogoSize.toDouble(),
      color: AppColors.background,
      child: CachedNetworkImage(
        imageUrl: job.company.image ?? '',
        imageBuilder: (context, imageProvider) => Image(
          image: imageProvider,
          fit: BoxFit.contain,
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

  Widget _buildLocationInfo(TextTheme textTheme) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            job.location.formattedAddress,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobTags() {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        if (job.isRemote) _buildInfoChip('Remote Work', AppColors.success),
        if (job.company.industry != null)
          _buildInfoChip(job.company.industry!, AppColors.info),
      ],
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(color: color.withAlpha(25)),
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

  Widget _buildJobContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (job.perks.isNotEmpty) ...[
            JobPerksRow(perks: job.perks),
            const SizedBox(height: AppSpacing.xxl),
          ],
          Text(
            'Job Description',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildJobDescription(textTheme),
        ],
      ),
    );
  }

  Widget _buildJobDescription(TextTheme textTheme) {
    return Html(
      data: job.description,
      style: {
        'body': Style.fromTextStyle(
          textTheme.bodyLarge!.copyWith(
            height: 1.6,
            color: AppColors.textPrimary,
          ),
        ),
        'h1, h2, h3, h4, h5, h6': Style.fromTextStyle(
          textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        'p': Style.fromTextStyle(
          textTheme.bodyLarge!.copyWith(
            height: 1.6,
            color: AppColors.textPrimary,
          ),
        ),
      },
    );
  }

  Widget? _buildBottomActionBar(BuildContext context) {
    if (job.applyUrl == null || job.applyUrl!.isEmpty) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (job.isQuickApply) _buildQuickApplyBanner(context),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Apply for this Job',
              icon: Icons.open_in_new_rounded,
              variant: AppButtonVariant.success,
              onPressed: () => _applyForJob(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickApplyBanner(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(color: AppColors.accent.withAlpha(51)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.flash_on_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Quick & Easy Application',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _applyForJob() {
    if (job.applyUrl != null) {
      AppUrlLauncher.launch(job.applyUrl!);
    }
  }
}
