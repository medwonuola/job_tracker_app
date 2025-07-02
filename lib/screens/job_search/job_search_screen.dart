import 'package:flutter/material.dart';
import 'package:job_tracker_app/providers/job_search_provider.dart';
import 'package:job_tracker_app/screens/job_detail/job_detail_screen.dart';
import 'package:job_tracker_app/theme/d3x_colors.dart';
import 'package:job_tracker_app/theme/d3x_spacing.dart';
import 'package:provider/provider.dart';
import 'widgets/job_list_item.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    Provider.of<JobSearchProvider>(context, listen: false)
        .performSearch(_searchController.text);
    FocusScope.of(context).unfocus();
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
        title: const Text('Find Your Next Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: D3XSpacing.md),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'e.g., "Flutter Developer"',
                suffixIcon: IconButton(
                  icon:
                      const Icon(Icons.search, color: D3XColors.brandSecondary),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: D3XSpacing.lg),
            Expanded(
              child: Consumer<JobSearchProvider>(
                builder: (context, provider, child) {
                  switch (provider.state) {
                    case SearchState.loading:
                      return const Center(
                          child: CircularProgressIndicator(
                              color: D3XColors.brandPrimary));
                    case SearchState.error:
                      return Center(
                          child: Text('Error: ${provider.errorMessage}'));
                    case SearchState.loaded:
                      if (provider.jobs.isEmpty) {
                        return const Center(
                            child: Text('No jobs found. Try another search.'));
                      }
                      return ListView.builder(
                        itemCount: provider.jobs.length,
                        itemBuilder: (context, index) {
                          final job = provider.jobs[index];
                          return JobListItem(
                            job: job,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JobDetailScreen(job: job),
                                ),
                              );
                            },
                          );
                        },
                      );
                    case SearchState.initial:
                    default:
                      return const Center(
                          child: Text('Search for jobs to get started.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
