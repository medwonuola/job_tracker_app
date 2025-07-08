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
      backgroundColor: ContextColors.background,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 2,
          color: ContextColors.border,
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(ContextSpacing.lg),
      decoration: const BoxDecoration(
        color: ContextColors.background,
        border: Border(
          bottom: BorderSide(color: ContextColors.border, width: 2),
        ),
      ),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: ContextSpacing.md),
          _buildActiveFiltersIndicator(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchTextField()),
        const SizedBox(width: ContextSpacing.md),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildSearchTextField() {
    return SizedBox(
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ContextColors.border, width: 2.0),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: const InputDecoration(
            hintText: 'Search jobs (e.g. "Flutter Developer")',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ContextSpacing.md,
              vertical: ContextSpacing.md,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: ContextColors.textSecondary,
            ),
          ),
          onSubmitted: (_) => _performSearch(),
          textInputAction: TextInputAction.search,
          style: ContextTypography.bodyMd.copyWith(
            color: ContextColors.textPrimary,
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
                  ? ContextColors.accent
                  : ContextColors.background,
              border: Border.all(
                color: provider.hasActiveFilters
                    ? ContextColors.borderDark
                    : ContextColors.border,
                width: 2.0,
              ),
            ),
            child: IconButton(
              onPressed: _showFilters,
              icon: Icon(
                Icons.tune_rounded,
                color: provider.hasActiveFilters
                    ? ContextColors.textPrimary
                    : ContextColors.textSecondary,
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
            horizontal: ContextSpacing.md,
            vertical: ContextSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: ContextColors.accent.withAlpha(51),
            border: Border.all(color: ContextColors.accent, width: 2),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.filter_alt_rounded,
                size: 16,
                color: ContextColors.textPrimary,
              ),
              const SizedBox(width: ContextSpacing.xs),
              const Text(
                'Filters applied',
                style: TextStyle(
                  color: ContextColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: provider.clearFilters,
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: ContextColors.textPrimary,
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
      padding: const EdgeInsets.all(ContextSpacing.lg),
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
        margin: const EdgeInsets.all(ContextSpacing.lg),
        padding: const EdgeInsets.all(ContextSpacing.xl),
        decoration: BoxDecoration(
          border: Border.all(color: ContextColors.border, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(ContextSpacing.lg),
              decoration: BoxDecoration(
                color: ContextColors.accent,
                border: Border.all(color: ContextColors.borderDark, width: 2),
              ),
              child: const Icon(
                Icons.work_outline_rounded,
                color: ContextColors.textPrimary,
                size: 48,
              ),
            ),
            const SizedBox(height: ContextSpacing.lg),
            Text('Search for Jobs', style: ContextTypography.h3),
            const SizedBox(height: ContextSpacing.sm),
            const Text(
              'Enter keywords to find your next opportunity',
              textAlign: TextAlign.center,
              style: TextStyle(color: ContextColors.textSecondary),
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
