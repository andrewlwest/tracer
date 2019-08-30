// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracerVisit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TracerVisit _$TracerVisitFromJson(Map<String, dynamic> json) {
  return new TracerVisit(
      json['summary'] as String,
      json['location'] as String,
      json['summaryStatus'] == null
          ? null
          : new SummaryStatus.fromJson(
              json['summaryStatus'] as Map<String, dynamic>),
      json['todo'] as String,
      json['participants'] as String,
      json['site'] as String,
      json['completionStatus'] as String,
      (json['observationGroups'] as List)
          ?.map((e) => e == null
              ? null
              : new ObservationGroup.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

abstract class _$TracerVisitSerializerMixin {
  String get summary;
  String get location;
  String get todo;
  String get participants;
  String get site;
  String get completionStatus;
  List<ObservationGroup> get observationGroups;
  SummaryStatus get summaryStatus;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'summary': summary,
        'location': location,
        'todo': todo,
        'participants': participants,
        'site': site,
        'completionStatus': completionStatus,
        'observationGroups': observationGroups,
        'summaryStatus': summaryStatus
      };
}
