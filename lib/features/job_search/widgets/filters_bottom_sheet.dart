import 'package:flutter/material.dart';
import 'package:job_tracker_app/api/api_service.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/debouncer.dart';
import 'package:job_tracker_app/core/widgets/context_button.dart';
import 'package:job_tracker_app/data/models/search_filters.dart';
import 'package:job_tracker_app/data/providers/job_search_provider.dart';
import 'package:provider/provider.dart';

class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({super.key});

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  late SearchFilters _filters;
  final ApiService _apiService = ApiService();
  final Debouncer _departmentDebouncer = Debouncer(delay: const Duration(milliseconds: 250));
  final Debouncer _industryDebouncer = Debouncer(delay: const Duration(milliseconds: 250));
  
  List<String> _availableDepartments = [];
  List<String> _availableIndustries = [];
  bool _loadingDepartments = false;
  bool _loadingIndustries = false;

  final List<String> _workplaceTypes = ['Remote', 'Hybrid', 'On-site'];
  final List<String> _commitmentTypes = ['Full-time', 'Part-time', 'Contract', 'Internship'];
  final List<String> _seniorityLevels = ['Internship', 'Entry level', 'Associate', 'Mid-Senior level', 'Director', 'Executive'];
  final List<String> _sortOptions = ['Date', 'Relevance', 'Salary'];

  @override
  void initState() {
    super.initState();
    _filters = Provider.of<JobSearchProvider>(context, listen: false).filters;
    _loadDepartments();
    _loadIndustries();
  }

  @override
  void dispose() {
    _departmentDebouncer.dispose();
    _industryDebouncer.dispose();
    super.dispose();
  }

  Future<void> _loadDepartments([String? query]) async {
    setState(() => _loadingDepartments = true);
    try {
      final departments = await _apiService.getDepartments(query: query);
      if (mounted) {
        setState(() {
          _availableDepartments = departments;
          _loadingDepartments = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingDepartments = false);
      }
    }
  }

  Future<void> _loadIndustries([String? query]) async {
    setState(() => _loadingIndustries = true);
    try {
      final industries = await _apiService.getIndustries(query: query);
      if (mounted) {
        setState(() {
          _availableIndustries = industries;
          _loadingIndustries = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingIndustries = false);
      }
    }
  }

  void _applyFilters() {
    Provider.of<JobSearchProvider>(context, listen: false).updateFilters(_filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _filters = const SearchFilters();
    });
    Provider.of<JobSearchProvider>(context, listen: false).clearFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.9,
      decoration: const BoxDecoration(
        color: ContextColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: ContextColors.border, width: 2),
          left: BorderSide(color: ContextColors.border, width: 2),
          right: BorderSide(color: ContextColors.border, width: 2),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(ContextSpacing.lg),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ContextColors.border, width: 2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters', style: textTheme.headlineMedium),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(ContextSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Workplace Type',
                    _buildChipGroup(
                      _workplaceTypes,
                      _filters.workplaceTypes ?? [],
                      (selected) => setState(() {
                        _filters = _filters.copyWith(workplaceTypes: selected);
                      }),
                    ),
                  ),
                  _buildSection(
                    'Commitment',
                    _buildChipGroup(
                      _commitmentTypes,
                      _filters.commitmentTypes ?? [],
                      (selected) => setState(() {
                        _filters = _filters.copyWith(commitmentTypes: selected);
                      }),
                    ),
                  ),
                  _buildSection(
                    'Seniority Level',
                    _buildChipGroup(
                      _seniorityLevels,
                      _filters.seniorityLevels ?? [],
                      (selected) => setState(() {
                        _filters = _filters.copyWith(seniorityLevels: selected);
                      }),
                    ),
                  ),
                  _buildSection(
                    'Departments',
                    _buildAutocompleteSection(
                      _availableDepartments,
                      _filters.departments ?? [],
                      _loadingDepartments,
                      (query) {
                        _departmentDebouncer(() => _loadDepartments(query));
                      },
                      (selected) => setState(() {
                        _filters = _filters.copyWith(departments: selected);
                      }),
                    ),
                  ),
                  _buildSection(
                    'Industries',
                    _buildAutocompleteSection(
                      _availableIndustries,
                      _filters.industries ?? [],
                      _loadingIndustries,
                      (query) {
                        _industryDebouncer(() => _loadIndustries(query));
                      },
                      (selected) => setState(() {
                        _filters = _filters.copyWith(industries: selected);
                      }),
                    ),
                  ),
                  _buildSection(
                    'Salary Range',
                    _buildSalarySection(),
                  ),
                  _buildSection(
                    'Sort By',
                    _buildRadioGroup(
                      _sortOptions,
                      _filters.sortBy,
                      (value) => setState(() {
                        _filters = _filters.copyWith(sortBy: value);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(ContextSpacing.lg),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: ContextColors.border, width: 2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ContextButton(
                    label: 'Clear',
                    variant: ContextButtonVariant.outline,
                    onPressed: _clearFilters,
                  ),
                ),
                const SizedBox(width: ContextSpacing.md),
                Expanded(
                  flex: 2,
                  child: ContextButton(
                    label: 'Apply Filters',
                    onPressed: _applyFilters,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: ContextSpacing.sm),
        content,
        const SizedBox(height: ContextSpacing.lg),
      ],
    );
  }

  Widget _buildChipGroup(
    List<String> options,
    List<String> selected,
    void Function(List<String>) onChanged,
  ) {
    return Wrap(
      spacing: ContextSpacing.sm,
      runSpacing: ContextSpacing.sm,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (value) {
            final newSelected = List<String>.from(selected);
            if (value) {
              newSelected.add(option);
            } else {
              newSelected.remove(option);
            }
            onChanged(newSelected);
          },
          selectedColor: ContextColors.accent,
          backgroundColor: ContextColors.background,
          shape: const StadiumBorder(
            side: BorderSide(color: ContextColors.border, width: 2),
          ),
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildAutocompleteSection(
    List<String> available,
    List<String> selected,
    bool loading,
    void Function(String) onSearch,
    void Function(List<String>) onChanged,
  ) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            suffixIcon: loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
          ),
          onChanged: onSearch,
        ),
        const SizedBox(height: ContextSpacing.sm),
        if (selected.isNotEmpty)
          Wrap(
            spacing: ContextSpacing.sm,
            children: selected.map((item) {
              return Chip(
                label: Text(item),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  final newSelected = List<String>.from(selected);
                  newSelected.remove(item);
                  onChanged(newSelected);
                },
                backgroundColor: ContextColors.accent,
              );
            }).toList(),
          ),
        if (available.isNotEmpty)
          Container(
            height: 120,
            margin: const EdgeInsets.only(top: ContextSpacing.sm),
            decoration: BoxDecoration(
              border: Border.all(color: ContextColors.border, width: 2),
            ),
            child: ListView.builder(
              itemCount: available.length,
              itemBuilder: (context, index) {
                final item = available[index];
                final isSelected = selected.contains(item);
                return ListTile(
                  title: Text(item),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    final newSelected = List<String>.from(selected);
                    if (isSelected) {
                      newSelected.remove(item);
                    } else {
                      newSelected.add(item);
                    }
                    onChanged(newSelected);
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSalarySection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Min Salary',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final salary = int.tryParse(value);
                  setState(() {
                    _filters = _filters.copyWith(salaryMin: salary);
                  });
                },
              ),
            ),
            const SizedBox(width: ContextSpacing.md),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Max Salary',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final salary = int.tryParse(value);
                  setState(() {
                    _filters = _filters.copyWith(salaryMax: salary);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioGroup(
    List<String> options,
    String? selected,
    void Function(String?) onChanged,
  ) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selected,
          onChanged: onChanged,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}
