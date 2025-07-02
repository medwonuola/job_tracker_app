import 'package:json_annotation/json_annotation.dart';

part 'job.g.dart';

enum ApplicationStatus { saved, applied, interviewing, offered, rejected }

@JsonSerializable(explicitToJson: true)
class Job {
  final String id;
  final String title;
  final String description;
  final String? applyUrl;
  final bool isRemote;
  final Company company;
  final JobLocation location;

  @JsonKey(includeFromJson: false, includeToJson: true)
  ApplicationStatus status;

  Job({
    required this.id,
    required this.title,
    required this.description,
    this.applyUrl,
    required this.isRemote,
    required this.company,
    required this.location,
    this.status = ApplicationStatus.saved,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);
}

@JsonSerializable()
class Company {
  final String name;
  final String? image;
  final String? industry;
  final String? website;

  Company({
    required this.name,
    this.image,
    this.industry,
    this.website,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

@JsonSerializable()
class JobLocation {
  @JsonKey(name: 'formatted')
  final String formattedAddress;

  JobLocation({required this.formattedAddress});

  factory JobLocation.fromJson(Map<String, dynamic> json) =>
      _$JobLocationFromJson(json);
  Map<String, dynamic> toJson() => _$JobLocationToJson(this);
}
