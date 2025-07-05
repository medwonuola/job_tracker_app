import 'package:flutter/material.dart';
import 'package:job_tracker_app/api/api_service.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/debouncer.dart';
import 'package:job_tracker_app/core/utils/throttler.dart';
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
  final Throttler _salaryThrottler = Throttler(delay: const Duration(milliseconds: 300));
  
  List<String> _availableDepartments = [];
  List<String> _availableIndustries = [];
  bool _loadingDepartments = false;
  bool _loadingIndustries = false;

  final List<String> _workplaceTypes = ['Remote', 'Hybrid', 'On-site'];
  final List<String> _commitmentTypes = ['Full-time', 'Part-time', 'Contract', 'Internship'];
  final List<String> _seniorityLevels = ['Internship', 'Entry level', 'Associate', 'Mid-Senior level', 'Director', 'Executive'];
  final List<String> _sortOptions = ['Date', 'Relevance', 'Salary'];
  final List<String> _frequencyOptions = ['Yearly', 'Monthly'];
  
  final Map<String, IconData> _perksOptions = {
    'Visa sponsorship': Icons.language,
    '401k matching': Icons.savings,
    '4-day work week': Icons.work_history,
    'Generous PTO': Icons.beach_access,
    'Parental leave': Icons.family_restroom,
    'Tuition reimbursement': Icons.school,
    'Health insurance': Icons.health_and_safety,
    'Remote work': Icons.home,
    'Flexible schedule': Icons.schedule,
    'Stock options': Icons.trending_up,
    'Gym membership': Icons.fitness_center,
    'Free meals': Icons.restaurant,
  };

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
    _salaryThrottler.dispose();
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
                    'Benefits & Perks',
                    _buildPerksSection(),
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
                    'Salary Transparency',
                    _buildTransparentSalarySection(),
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

  Widget _buildPerksSection() {
    final selectedPerks = _filters.perks ?? <String>{};
    
    return Wrap(
      spacing: ContextSpacing.sm,
      runSpacing: ContextSpacing.sm,
      children: _perksOptions.entries.map((entry) {
        final perk = entry.key;
        final icon = entry.value;
        final isSelected = selectedPerks.contains(perk);
        
        return FilterChip(
          avatar: Icon(
            icon,
            size: 18,
            color: isSelected ? ContextColors.textPrimary : ContextColors.textSecondary,
          ),
          label: Text(perk),
          selected: isSelected,
          onSelected: (value) {
            final newPerks = Set<String>.from(selectedPerks);
            if (value) {
              newPerks.add(perk);
            } else {
              newPerks.remove(perk);
            }
            setState(() {
              _filters = _filters.copyWith(perks: newPerks);
            });
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

  Widget _buildTransparentSalarySection() {
    final currentMin = _filters.minPay ?? 0.0;
    final currentMax = _filters.maxPay ?? 400000.0;
    final frequency = _filters.frequency ?? 'Yearly';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Only show jobs with published salary'),
          value: _filters.restrictTransparent,
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(restrictTransparent: value);
            });
          },
          contentPadding: EdgeInsets.zero,
          activeColor: ContextColors.accent,
        ),
        const SizedBox(height: ContextSpacing.md),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Frequency',
          ),
          value: frequency,
          items: _frequencyOptions.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _filters = _filters.copyWith(frequency: newValue);
              });
            }
          },
        ),
        const SizedBox(height: ContextSpacing.md),
        Text(
          'Salary Range: \$${currentMin.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} - \$${currentMax.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: ContextSpacing.sm),
        RangeSlider(
          values: RangeValues(currentMin, currentMax),
          min: 0.0,
          max: 400000.0,
          divisions: 80,
          labels: RangeLabels(
            '\$${(currentMin / 1000).round()}k',
            '\$${(currentMax / 1000).round()}k',
          ),
          onChanged: (RangeValues values) {
            _salaryThrottler(() {
              final minVal = values.start;
              final maxVal = values.end;
              
              final correctedMin = minVal <= maxVal ? minVal : maxVal;
              final correctedMax = minVal <= maxVal ? maxVal : minVal;
              
              setState(() {
                _filters = _filters.copyWith(
                  minPay: correctedMin,
                  maxPay: correctedMax,
                );
              });
            });
          },
          activeColor: ContextColors.accent,
          inactiveColor: ContextColors.border,
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
