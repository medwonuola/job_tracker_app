part of 'job.dart';

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      applyUrl: json['applyUrl'] as String?,
      isRemote: json['is_remote'] as bool,
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
      location: JobLocation.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'applyUrl': instance.applyUrl,
      'is_remote': instance.isRemote,
      'company': instance.company.toJson(),
      'location': instance.location.toJson(),
      'status': _$ApplicationStatusEnumMap[instance.status]!,
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
