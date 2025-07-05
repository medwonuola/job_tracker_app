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
        title: const Text('Context Job Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(ContextSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'e.g., "Flutter Developer"',
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: ContextColors.textSecondary,
                        ),
                        onPressed: _performSearch,
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                    textInputAction: TextInputAction.search,
                    style: ContextTypography.bodyMd
                        .copyWith(color: ContextColors.textPrimary),
                  ),
                ),
                const SizedBox(width: ContextSpacing.sm),
                Consumer<JobSearchProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      onPressed: _showFilters,
                      icon: Icon(
                        Icons.tune,
                        color: provider.hasActiveFilters
                            ? ContextColors.accent
                            : ContextColors.textSecondary,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: provider.hasActiveFilters
                            ? ContextColors.accent.withAlpha(38)
                            : null,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: ContextColors.border,
                            width: 2.0,
                          ),
                        ),
                      ),
                    );
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
                      child: CircularProgressIndicator(
                        color: ContextColors.textPrimary,
                      ),
                    );
                  case SearchState.error:
                    return Center(
                      child: Text('Error: ${provider.errorMessage}'),
                    );
                  case SearchState.loaded:
                    if (provider.jobs.isEmpty) {
                      return const Center(
                        child: Text('No jobs found. Try another search.'),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ContextSpacing.md,
                      ),
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
                    return const Center(
                      child: Text('Search for jobs to get started.'),
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
