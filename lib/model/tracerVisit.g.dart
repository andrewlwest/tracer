// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracerVisit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TracerVisit _$TracerVisitFromJson(Map<String, dynamic> json) {
  return new TracerVisit(
      json['id'] as String,
      json['place'] == null
          ? null
          : new Place.fromJson(json['place'] as Map<String, dynamic>),
      json['summary'] as String,
      json['summaryStats'] == null
          ? null
          : new SummaryStats.fromJson(
              json['summaryStats'] as Map<String, dynamic>),
      json['todo'] as String,
      json['participants'] as String,
      json['completionStatus'] as String,
      (json['observationCategories'] as Map<String, dynamic>)?.map((k, e) =>
          new MapEntry(
              k,
              e == null
                  ? null
                  : new Observation.fromJson(e as Map<String, dynamic>))),
      (json['exceptions'] as Map<String, dynamic>)?.map((k, e) => new MapEntry(
          k,
          e == null
              ? null
              : new ObservationException.fromJson(e as Map<String, dynamic>))),
      json['template_version'] as String,
      json['type'] as String)
    ..visitDatetime = json['visitDatetime'] == null
        ? null
        : DateTime.parse(json['visitDatetime'] as String);
}

abstract class _$TracerVisitSerializerMixin {
  String get id;
  Place get place;
  String get summary;
  String get participants;
  String get todo;
  DateTime get visitDatetime;
  SummaryStats get summaryStats;
  String get completionStatus;
  Map<String, Observation> get observations;
  Map<String, ObservationException> get exceptions;
  String get templateVersion;
  String get type;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'place': place,
        'summary': summary,
        'participants': participants,
        'todo': todo,
        'visitDatetime': visitDatetime?.toIso8601String(),
        'summaryStats': summaryStats,
        'completionStatus': completionStatus,
        'observationCategories': observations,
        'exceptions': exceptions,
        'template_version': templateVersion,
        'type': type
      };
}

SummaryStats _$SummaryStatsFromJson(Map<String, dynamic> json) {
  return new SummaryStats(
      json['percentNonCompliant'] as int,
      json['percentComplete'] as int,
      json['percentAdvisory'] as int,
      json['percentCompliant'] as int);
}

abstract class _$SummaryStatsSerializerMixin {
  int get percentNonCompliant;
  int get percentComplete;
  int get percentAdvisory;
  int get percentCompliant;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'percentNonCompliant': percentNonCompliant,
        'percentComplete': percentComplete,
        'percentAdvisory': percentAdvisory,
        'percentCompliant': percentCompliant
      };
}
