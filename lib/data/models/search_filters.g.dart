// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFilters _$SearchFiltersFromJson(Map<String, dynamic> json) =>
    SearchFilters(
      locationShort: json['locationShort'] as String?,
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLon: (json['locationLon'] as num?)?.toDouble(),
      region: json['region'] as String?,
      workplaceTypes: (json['workplaceTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      commitmentTypes: (json['commitmentTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      seniorityLevels: (json['seniorityLevels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      departments: (json['departments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      industries: (json['industries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      salaryMin: (json['salaryMin'] as num?)?.toInt(),
      salaryMax: (json['salaryMax'] as num?)?.toInt(),
      salaryCurrency: json['salaryCurrency'] as String?,
      salaryFrequency: json['salaryFrequency'] as String?,
      sortBy: json['sortBy'] as String?,
      size: (json['size'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      restrictTransparent: json['restrictTransparent'] as bool? ?? false,
      minPay: (json['minPay'] as num?)?.toDouble(),
      maxPay: (json['maxPay'] as num?)?.toDouble(),
      frequency: json['frequency'] as String?,
      perks: (json['perks'] as List<dynamic>?)?.map((e) => e as String).toSet(),
      quickApplyOnly: json['quickApplyOnly'] as bool? ?? false,
    );

Map<String, dynamic> _$SearchFiltersToJson(SearchFilters instance) =>
    <String, dynamic>{
      'locationShort': instance.locationShort,
      'locationLat': instance.locationLat,
      'locationLon': instance.locationLon,
      'region': instance.region,
      'workplaceTypes': instance.workplaceTypes,
      'commitmentTypes': instance.commitmentTypes,
      'seniorityLevels': instance.seniorityLevels,
      'departments': instance.departments,
      'industries': instance.industries,
      'salaryMin': instance.salaryMin,
      'salaryMax': instance.salaryMax,
      'salaryCurrency': instance.salaryCurrency,
      'salaryFrequency': instance.salaryFrequency,
      'sortBy': instance.sortBy,
      'size': instance.size,
      'page': instance.page,
      'restrictTransparent': instance.restrictTransparent,
      'minPay': instance.minPay,
      'maxPay': instance.maxPay,
      'frequency': instance.frequency,
      'perks': instance.perks?.toList(),
      'quickApplyOnly': instance.quickApplyOnly,
    };
