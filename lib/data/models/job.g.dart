// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      applyUrl: json['applyUrl'] as String?,
      isRemote: json['isRemote'] as bool? ?? false,
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
      location: JobLocation.fromJson(json['location'] as Map<String, dynamic>),
      perks:
          (json['perks'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      applicationFormEase: json['applicationFormEase'] as String?,
      status: json['status'] == null
          ? ApplicationStatus.saved
          : _statusFromJson(json['status'] as String?),
      createdAt: _dateTimeFromJson(json['createdAt'] as String?),
      lastStatusChange: _dateTimeFromJson(json['lastStatusChange'] as String?),
      statusHistory: (json['statusHistory'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'applyUrl': instance.applyUrl,
      'isRemote': instance.isRemote,
      'company': instance.company.toJson(),
      'location': instance.location.toJson(),
      'perks': instance.perks,
      'applicationFormEase': instance.applicationFormEase,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'lastStatusChange': _dateTimeToJson(instance.lastStatusChange),
      'statusHistory': instance.statusHistory,
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.saved: 'saved',
  ApplicationStatus.applied: 'applied',
  ApplicationStatus.interviewing: 'interviewing',
  ApplicationStatus.offered: 'offered',
  ApplicationStatus.rejected: 'rejected',
};

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      name: json['name'] as String,
      image: json['image'] as String?,
      industry: json['industry'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'industry': instance.industry,
      'website': instance.website,
    };

JobLocation _$JobLocationFromJson(Map<String, dynamic> json) => JobLocation(
      formattedAddress: json['formatted'] as String,
    );

Map<String, dynamic> _$JobLocationToJson(JobLocation instance) =>
    <String, dynamic>{
      'formatted': instance.formattedAddress,
    };
