import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/constants/app_constants.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/theme/app_typography.dart';
import 'package:job_tracker_app/core/widgets/error_state_widget.dart';
import 'package:job_tracker_app/core/widgets/loading_state_widget.dart';
import 'package:job_tracker_app/data/models/job.dart';
import 'package:job_tracker_app/data/providers/job_search_provider.dart';
import 'package:job_tracker_app/features/job_detail/job_detail_screen.dart';
import 'package:job_tracker_app/features/job_search/widgets/job_list_item.dart';
import 'package:job_tracker_app/features/job_search/widgets/filters_bottom_sheet.dart';
import 'package:provider/provider.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<JobSearchProvider>().performSearch(query);
      _searchFocusNode.unfocus();
    }
  }

  void _showFilters() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FiltersBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchSection(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Job Search'),
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 2,
          color: AppColors.border,
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 2),
        ),
      ),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: AppSpacing.md),
          _buildActiveFiltersIndicator(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchTextField()),
        const SizedBox(width: AppSpacing.md),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildSearchTextField() {
    return SizedBox(
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 2.0),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: const InputDecoration(
            hintText: 'Search jobs (e.g. "Flutter Developer")',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
            ),
          ),
          onSubmitted: (_) => _performSearch(),
          textInputAction: TextInputAction.search,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Consumer<JobSearchProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 52,
          width: 52,
          child: Container(
            decoration: BoxDecoration(
              color: provider.hasActiveFilters
                  ? AppColors.accent
                  : AppColors.background,
              border: Border.all(
                color: provider.hasActiveFilters
                    ? AppColors.borderDark
                    : AppColors.border,
                width: 2.0,
              ),
            ),
            child: IconButton(
              onPressed: _showFilters,
              icon: Icon(
                Icons.tune_rounded,
                color: provider.hasActiveFilters
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveFiltersIndicator() {
    return Consumer<JobSearchProvider>(
      builder: (context, provider, child) {
        if (!provider.hasActiveFilters) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.accent.withAlpha(51),
            border: Border.all(color: AppColors.accent, width: 2),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.filter_alt_rounded,
                size: 16,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: AppSpacing.xs),
              const Text(
                'Filters applied',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: provider.clearFilters,
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Consumer<JobSearchProvider>(
      builder: (context, provider, child) {
        switch (provider.state) {
          case SearchState.loading:
            return LoadingStateWidget.search();

          case SearchState.error:
            return ErrorStateWidget.generic(
              customMessage: provider.errorMessage,
              onRetry: () => _performSearch(),
            );

          case SearchState.loaded:
            if (provider.jobs.isEmpty) {
              return ErrorStateWidget.noResults(
                customMessage: AppConstants.errorMessages['noResultsFound'],
              );
            }
            return _buildJobsList(provider);

          case SearchState.initial:
            return _buildInitialState();
        }
      },
    );
  }

  Widget _buildJobsList(JobSearchProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: provider.jobs.length,
      itemBuilder: (context, index) {
        final job = provider.jobs[index];
        return JobListItem(
          job: job,
          onTap: () => _navigateToJobDetail(job),
        );
      },
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.accent,
                border: Border.all(color: AppColors.borderDark, width: 2),
              ),
              child: const Icon(
                Icons.work_outline_rounded,
                color: AppColors.textPrimary,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Search for Jobs', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Enter keywords to find your next opportunity',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToJobDetail(Job job) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => JobDetailScreen(job: job),
      ),
    );
  }
}
