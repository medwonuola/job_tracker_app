import 'package:json_annotation/json_annotation.dart';

part 'search_filters.g.dart';

@JsonSerializable()
class SearchFilters {
  final String? locationShort;
  final double? locationLat;
  final double? locationLon;
  final String? region;
  final List<String>? workplaceTypes;
  final List<String>? commitmentTypes;
  final List<String>? seniorityLevels;
  final List<String>? departments;
  final List<String>? industries;
  final int? salaryMin;
  final int? salaryMax;
  final String? salaryCurrency;
  final String? salaryFrequency;
  final String? sortBy;
  final int? size;
  final int? page;
  final bool restrictTransparent;
  final double? minPay;
  final double? maxPay;
  final String? frequency;
  final Set<String>? perks;
  final bool quickApplyOnly;

  const SearchFilters({
    this.locationShort,
    this.locationLat,
    this.locationLon,
    this.region,
    this.workplaceTypes,
    this.commitmentTypes,
    this.seniorityLevels,
    this.departments,
    this.industries,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.salaryFrequency,
    this.sortBy,
    this.size,
    this.page,
    this.restrictTransparent = false,
    this.minPay,
    this.maxPay,
    this.frequency,
    this.perks,
    this.quickApplyOnly = false,
  });

  factory SearchFilters.fromJson(Map<String, dynamic> json) =>
      _$SearchFiltersFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFiltersToJson(this);

  SearchFilters copyWith({
    String? locationShort,
    double? locationLat,
    double? locationLon,
    String? region,
    List<String>? workplaceTypes,
    List<String>? commitmentTypes,
    List<String>? seniorityLevels,
    List<String>? departments,
    List<String>? industries,
    int? salaryMin,
    int? salaryMax,
    String? salaryCurrency,
    String? salaryFrequency,
    String? sortBy,
    int? size,
    int? page,
    bool? restrictTransparent,
    double? minPay,
    double? maxPay,
    String? frequency,
    Set<String>? perks,
    bool? quickApplyOnly,
  }) {
    return SearchFilters(
      locationShort: locationShort ?? this.locationShort,
      locationLat: locationLat ?? this.locationLat,
      locationLon: locationLon ?? this.locationLon,
      region: region ?? this.region,
      workplaceTypes: workplaceTypes ?? this.workplaceTypes,
      commitmentTypes: commitmentTypes ?? this.commitmentTypes,
      seniorityLevels: seniorityLevels ?? this.seniorityLevels,
      departments: departments ?? this.departments,
      industries: industries ?? this.industries,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      salaryCurrency: salaryCurrency ?? this.salaryCurrency,
      salaryFrequency: salaryFrequency ?? this.salaryFrequency,
      sortBy: sortBy ?? this.sortBy,
      size: size ?? this.size,
      page: page ?? this.page,
      restrictTransparent: restrictTransparent ?? this.restrictTransparent,
      minPay: minPay ?? this.minPay,
      maxPay: maxPay ?? this.maxPay,
      frequency: frequency ?? this.frequency,
      perks: perks ?? this.perks,
      quickApplyOnly: quickApplyOnly ?? this.quickApplyOnly,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {};

    if (locationShort != null) params['locationShort'] = locationShort;
    if (locationLat != null) params['locationLat'] = locationLat.toString();
    if (locationLon != null) params['locationLon'] = locationLon.toString();
    if (region != null) params['region'] = region;
    if (workplaceTypes?.isNotEmpty ?? false) {
      params['workplaceTypes'] = workplaceTypes!.join(',');
    }
    if (commitmentTypes?.isNotEmpty ?? false) {
      params['commitmentTypes'] = commitmentTypes!.join(',');
    }
    if (seniorityLevels?.isNotEmpty ?? false) {
      params['seniorityLevels'] = seniorityLevels!.join(',');
    }
    if (departments?.isNotEmpty ?? false) {
      params['departments'] = departments!.join(',');
    }
    if (industries?.isNotEmpty ?? false) {
      params['industries'] = industries!.join(',');
    }
    if (salaryMin != null) params['salaryMin'] = salaryMin.toString();
    if (salaryMax != null) params['salaryMax'] = salaryMax.toString();
    if (salaryCurrency != null) params['salaryCurrency'] = salaryCurrency;
    if (salaryFrequency != null) params['salaryFrequency'] = salaryFrequency;
    if (sortBy != null) params['sortBy'] = sortBy;
    if (size != null) params['size'] = size.toString();
    if (page != null) params['page'] = page.toString();
    
    if (restrictTransparent) {
      params['restrictJobsToTransparentSalaries'] = 'true';
    }
    if (minPay != null) {
      params['minCompensationLowEnd'] = minPay!.round().toString();
    }
    if (maxPay != null) {
      params['maxCompensationHighEnd'] = maxPay!.round().toString();
    }
    if (frequency != null) params['calcFrequency'] = frequency;
    if (perks?.isNotEmpty ?? false) {
      params['benefitsAndPerks'] = perks!.join(',');
    }
    if (quickApplyOnly) {
      params['applicationFormEase'] = 'Simple';
    }

    return params;
  }

  bool get isEmpty {
    return locationShort == null &&
        locationLat == null &&
        locationLon == null &&
        region == null &&
        (workplaceTypes?.isEmpty ?? true) &&
        (commitmentTypes?.isEmpty ?? true) &&
        (seniorityLevels?.isEmpty ?? true) &&
        (departments?.isEmpty ?? true) &&
        (industries?.isEmpty ?? true) &&
        salaryMin == null &&
        salaryMax == null &&
        salaryCurrency == null &&
        salaryFrequency == null &&
        sortBy == null &&
        !restrictTransparent &&
        minPay == null &&
        maxPay == null &&
        frequency == null &&
        (perks?.isEmpty ?? true) &&
        !quickApplyOnly;
  }
}
