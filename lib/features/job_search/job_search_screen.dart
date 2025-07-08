import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/theme/app_typography.dart';
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
  final TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    if (_searchController.text.trim().isNotEmpty) {
      Provider.of<JobSearchProvider>(context, listen: false)
          .performSearch(_searchController.text);
      FocusScope.of(context).unfocus();
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(ContextSpacing.lg),
            decoration: const BoxDecoration(
              color: ContextColors.background,
              border: Border(
                bottom: BorderSide(color: ContextColors.border, width: 2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ContextColors.border,
                              width: 2.0,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
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
                            style: ContextTypography.bodyMd
                                .copyWith(color: ContextColors.textPrimary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: ContextSpacing.md),
                    Consumer<JobSearchProvider>(
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
                    ),
                  ],
                ),
                const SizedBox(height: ContextSpacing.md),
                Consumer<JobSearchProvider>(
                  builder: (context, provider, child) {
                    if (provider.hasActiveFilters) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ContextSpacing.md,
                          vertical: ContextSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: ContextColors.accent.withAlpha(51),
                          border: Border.all(
                            color: ContextColors.accent,
                            width: 2,
                          ),
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
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<JobSearchProvider>(
              builder: (context, provider, child) {
                switch (provider.state) {
                  case SearchState.loading:
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: ContextColors.accent,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: ContextSpacing.md),
                          Text(
                            'Searching for jobs...',
                            style: TextStyle(
                              color: ContextColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  case SearchState.error:
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(ContextSpacing.lg),
                        padding: const EdgeInsets.all(ContextSpacing.lg),
                        decoration: BoxDecoration(
                          color: ContextColors.warningLight,
                          border: Border.all(
                            color: ContextColors.warning,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: ContextColors.warning,
                              size: 48,
                            ),
                            const SizedBox(height: ContextSpacing.md),
                            Text(
                              'Search Error',
                              style: ContextTypography.h4.copyWith(
                                color: ContextColors.warning,
                              ),
                            ),
                            const SizedBox(height: ContextSpacing.sm),
                            Text(
                              provider.errorMessage,
                              textAlign: TextAlign.center,
                              style: ContextTypography.bodyMd.copyWith(
                                color: ContextColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  case SearchState.loaded:
                    if (provider.jobs.isEmpty) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.all(ContextSpacing.lg),
                          padding: const EdgeInsets.all(ContextSpacing.lg),
                          decoration: BoxDecoration(
                            color: ContextColors.neutralLight,
                            border: Border.all(
                              color: ContextColors.border,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                color: ContextColors.neutral,
                                size: 48,
                              ),
                              const SizedBox(height: ContextSpacing.md),
                              Text(
                                'No Jobs Found',
                                style: ContextTypography.h4.copyWith(
                                  color: ContextColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: ContextSpacing.sm),
                              const Text(
                                'Try adjusting your search terms or filters',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ContextColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(ContextSpacing.lg),
                      itemCount: provider.jobs.length,
                      itemBuilder: (context, index) {
                        final job = provider.jobs[index];
                        return JobListItem(
                          job: job,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => JobDetailScreen(job: job),
                              ),
                            );
                          },
                        );
                      },
                    );
                  case SearchState.initial:
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(ContextSpacing.lg),
                        padding: const EdgeInsets.all(ContextSpacing.xl),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ContextColors.border,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(ContextSpacing.lg),
                              decoration: BoxDecoration(
                                color: ContextColors.accent,
                                border: Border.all(
                                  color: ContextColors.borderDark,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.work_outline_rounded,
                                color: ContextColors.textPrimary,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: ContextSpacing.lg),
                            Text(
                              'Search for Jobs',
                              style: ContextTypography.h3,
                            ),
                            const SizedBox(height: ContextSpacing.sm),
                            const Text(
                              'Enter keywords to find your next opportunity',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ContextColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
