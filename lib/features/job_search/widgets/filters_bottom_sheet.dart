import 'package:flutter/material.dart';
import 'package:job_tracker_app/api/api_service.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/utils/debouncer.dart';
import 'package:job_tracker_app/core/utils/throttler.dart';
import 'package:job_tracker_app/core/widgets/context_button.dart';
import 'package:job_tracker_app/data/models/search_filters.dart';
import 'package:job_tracker_app/data/models/location_suggestion.dart';
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
  final Debouncer _locationDebouncer =
      Debouncer(delay: const Duration(milliseconds: 400));
  final Throttler _salaryThrottler =
      Throttler(delay: const Duration(milliseconds: 300));

  List<LocationSuggestion> _availableLocations = [];

  LocationSuggestion? _selectedLocation;

  final List<String> _workplaceTypes = ['Remote', 'Hybrid', 'On-site'];
  final List<String> _commitmentTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
  ];
  final List<String> _seniorityLevels = [
    'Internship',
    'Entry level',
    'Associate',
    'Mid-Senior level',
    'Director',
    'Executive',
  ];
  final List<String> _frequencyOptions = ['Yearly', 'Monthly'];

  final Map<String, IconData> _perksOptions = {
    'Visa sponsorship': Icons.flight_takeoff_rounded,
    '401k matching': Icons.savings_rounded,
    '4-day work week': Icons.work_history_rounded,
    'Generous PTO': Icons.beach_access_rounded,
    'Parental leave': Icons.family_restroom_rounded,
    'Tuition reimbursement': Icons.school_rounded,
    'Health insurance': Icons.health_and_safety_rounded,
    'Remote work': Icons.home_work_rounded,
    'Flexible schedule': Icons.schedule_rounded,
    'Stock options': Icons.trending_up_rounded,
    'Gym membership': Icons.fitness_center_rounded,
    'Free meals': Icons.restaurant_rounded,
  };

  @override
  void initState() {
    super.initState();
    _filters = Provider.of<JobSearchProvider>(context, listen: false).filters;

    if (_filters.locationShort != null) {
      _selectedLocation = LocationSuggestion(
        label: _filters.locationShort!,
        value: _filters.locationShort!,
      );
    }
  }

  @override
  void dispose() {
    _locationDebouncer.dispose();
    _salaryThrottler.dispose();
    super.dispose();
  }

  Future<void> _loadLocations([String? query]) async {
    try {
      final locations = await _apiService.searchLocations(query: query);
      if (mounted) {
        setState(() {
          _availableLocations = locations;
        });
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  void _applyFilters() {
    Provider.of<JobSearchProvider>(context, listen: false)
        .updateFilters(_filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _filters = const SearchFilters();
      _selectedLocation = null;
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
        border: Border(
          top: BorderSide(color: ContextColors.border),
          left: BorderSide(color: ContextColors.border),
          right: BorderSide(color: ContextColors.border),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(ContextSpacing.lg),
            decoration: const BoxDecoration(
              color: ContextColors.accent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: textTheme.headlineMedium?.copyWith(
                    color: ContextColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: ContextColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                  _buildSection('Location', _buildLocationSection()),
                  _buildSection('Quick Apply', _buildQuickApplySection()),
                  _buildSection(
                      'Workplace Type',
                      _buildChipGroup(
                          _workplaceTypes,
                          _filters.workplaceTypes ?? [],
                          (selected) => setState(() => _filters =
                              _filters.copyWith(workplaceTypes: selected),),),),
                  _buildSection(
                      'Commitment',
                      _buildChipGroup(
                          _commitmentTypes,
                          _filters.commitmentTypes ?? [],
                          (selected) => setState(() => _filters =
                              _filters.copyWith(commitmentTypes: selected),),),),
                  _buildSection(
                      'Experience Level',
                      _buildChipGroup(
                          _seniorityLevels,
                          _filters.seniorityLevels ?? [],
                          (selected) => setState(() => _filters =
                              _filters.copyWith(seniorityLevels: selected),),),),
                  _buildSection('Benefits & Perks', _buildPerksSection()),
                  _buildSection('Salary Range', _buildSalarySection()),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(ContextSpacing.lg),
            decoration: const BoxDecoration(
              color: ContextColors.background,
              border: Border(top: BorderSide(color: ContextColors.border)),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: ContextSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ContextColors.textPrimary,
                ),
          ),
          const SizedBox(height: ContextSpacing.md),
          content,
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search for a location...',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          onChanged: (query) {
            if (query.isEmpty) {
              setState(() {
                _availableLocations = [];
                _selectedLocation = null;
                _filters = _filters.copyWith();
              });
              return;
            }
            _locationDebouncer(() => _loadLocations(query));
          },
        ),
        if (_selectedLocation != null) ...[
          const SizedBox(height: ContextSpacing.md),
          Container(
            padding: const EdgeInsets.all(ContextSpacing.md),
            decoration: const BoxDecoration(
              color: ContextColors.successLight,
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: ContextColors.success),
                const SizedBox(width: ContextSpacing.sm),
                Expanded(child: Text(_selectedLocation!.label)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() {
                    _selectedLocation = null;
                    _filters = _filters.copyWith();
                  }),
                ),
              ],
            ),
          ),
        ],
        if (_availableLocations.isNotEmpty && _selectedLocation == null) ...[
          const SizedBox(height: ContextSpacing.md),
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: ContextColors.neutralLight,
            ),
            child: ListView.builder(
              itemCount: _availableLocations.length,
              itemBuilder: (context, index) {
                final location = _availableLocations[index];
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(location.label),
                  onTap: () => setState(() {
                    _selectedLocation = location;
                    _filters = _filters.copyWith(
                      locationShort: location.shortCode,
                      locationLat: location.lat,
                      locationLon: location.lon,
                      region: 'anywhere_in_world',
                    );
                    _availableLocations = [];
                  }),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickApplySection() {
    return SwitchListTile(
      title: const Text('Quick Apply Only'),
      subtitle: const Text('Show only jobs with simple application forms'),
      value: _filters.quickApplyOnly,
      onChanged: (value) =>
          setState(() => _filters = _filters.copyWith(quickApplyOnly: value)),
      contentPadding: EdgeInsets.zero,
      activeColor: ContextColors.accent,
    );
  }

  Widget _buildChipGroup(List<String> options, List<String> selected,
      void Function(List<String>) onChanged,) {
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
          backgroundColor: ContextColors.neutralLight,
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
          avatar: Icon(icon, size: 18),
          label: Text(perk),
          selected: isSelected,
          onSelected: (value) {
            final newPerks = Set<String>.from(selectedPerks);
            if (value) {
              newPerks.add(perk);
            } else {
              newPerks.remove(perk);
            }
            setState(() => _filters = _filters.copyWith(perks: newPerks));
          },
          selectedColor: ContextColors.accent,
          backgroundColor: ContextColors.neutralLight,
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildSalarySection() {
    final currentMin = _filters.minPay ?? 0.0;
    final currentMax = _filters.maxPay ?? 400000.0;
    final frequency = _filters.frequency ?? 'Yearly';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Only show jobs with published salary'),
          value: _filters.restrictTransparent,
          onChanged: (value) => setState(
              () => _filters = _filters.copyWith(restrictTransparent: value),),
          contentPadding: EdgeInsets.zero,
          activeColor: ContextColors.info,
        ),
        const SizedBox(height: ContextSpacing.lg),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Frequency'),
          value: frequency,
          items: _frequencyOptions
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)),)
              .toList(),
          onChanged: (value) =>
              setState(() => _filters = _filters.copyWith(frequency: value)),
        ),
        const SizedBox(height: ContextSpacing.lg),
        Text(
          'Range: \$${currentMin.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} - \$${currentMax.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        RangeSlider(
          values: RangeValues(currentMin, currentMax),
          max: 400000.0,
          divisions: 80,
          labels: RangeLabels('\$${(currentMin / 1000).round()}k',
              '\$${(currentMax / 1000).round()}k',),
          onChanged: (values) => _salaryThrottler(() => setState(() =>
              _filters =
                  _filters.copyWith(minPay: values.start, maxPay: values.end),),),
          activeColor: ContextColors.accent,
        ),
      ],
    );
  }
}
