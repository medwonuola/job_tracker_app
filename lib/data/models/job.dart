import 'package:json_annotation/json_annotation.dart';

part 'job.g.dart';

enum ApplicationStatus { saved, applied, interviewing, offered, rejected }

ApplicationStatus _statusFromJson(String? status) {
  return ApplicationStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => ApplicationStatus.saved,
  );
}

DateTime _dateTimeFromJson(String? dateTime) {
  if (dateTime == null) return DateTime.now();
  return DateTime.tryParse(dateTime) ?? DateTime.now();
}

String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();

@JsonSerializable(explicitToJson: true)
class Job {
  final String id;
  final String title;
  final String description;
  final String? applyUrl;
  @JsonKey(defaultValue: false)
  final bool isRemote;
  final Company company;
  final JobLocation location;
  @JsonKey(defaultValue: <String>[])
  final List<String> perks;
  final String? applicationFormEase;

  @JsonKey(fromJson: _statusFromJson, defaultValue: ApplicationStatus.saved)
  ApplicationStatus status;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime createdAt;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime lastStatusChange;

  @JsonKey(defaultValue: <String, String>{})
  Map<String, String> statusHistory;

  Job({
    required this.id,
    required this.title,
    required this.description,
    this.applyUrl,
    required this.isRemote,
    required this.company,
    required this.location,
    this.perks = const <String>[],
    this.applicationFormEase,
    this.status = ApplicationStatus.saved,
    DateTime? createdAt,
    DateTime? lastStatusChange,
    this.statusHistory = const <String, String>{},
  }) : createdAt = createdAt ?? DateTime.now(),
       lastStatusChange = lastStatusChange ?? DateTime.now();

  bool get isQuickApply => applicationFormEase == 'Simple';

  void updateStatus(ApplicationStatus newStatus) {
    final now = DateTime.now();
    statusHistory[now.toIso8601String()] = newStatus.name;
    status = newStatus;
    lastStatusChange = now;
  }

  int getDaysInStatus(ApplicationStatus targetStatus) {
    final history = statusHistory.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    DateTime? statusStartTime;
    DateTime? statusEndTime;
    
    for (int i = 0; i < history.length; i++) {
      if (ApplicationStatus.values.firstWhere((e) => e.name == history[i].value) == targetStatus) {
        statusStartTime = DateTime.parse(history[i].key);
        statusEndTime = i < history.length - 1 
          ? DateTime.parse(history[i + 1].key)
          : (status == targetStatus ? DateTime.now() : null);
        break;
      }
    }
    
    if (statusStartTime == null) return 0;
    statusEndTime ??= DateTime.now();
    
    return statusEndTime.difference(statusStartTime).inDays;
  }

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
