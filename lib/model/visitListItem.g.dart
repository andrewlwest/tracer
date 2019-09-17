// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitListItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitListItem _$VisitListItemFromJson(Map<String, dynamic> json) {
  return new VisitListItem(
      json['id'] as String,
      json['place'] == null
          ? null
          : new Place.fromJson(json['place'] as Map<String, dynamic>),
      json['summary'] as String,
      json['participants'] as String,
      json['todo'] as String,
      json['visitDatetime'] == null
          ? null
          : DateTime.parse(json['visitDatetime'] as String),
      json['type'] as String)
    ..summaryStats = json['summaryStats'] == null
        ? null
        : new SummaryStats.fromJson(
            json['summaryStats'] as Map<String, dynamic>);
}

abstract class _$VisitListItemSerializerMixin {
  String get id;
  Place get place;
  String get summary;
  String get participants;
  String get todo;
  DateTime get visitDatetime;
  SummaryStats get summaryStats;
  String get type;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'place': place,
        'summary': summary,
        'participants': participants,
        'todo': todo,
        'visitDatetime': visitDatetime?.toIso8601String(),
        'summaryStats': summaryStats,
        'type': type
      };
}

SummaryStats _$SummaryStatsFromJson(Map<String, dynamic> json) {
  return new SummaryStats()
    ..percentNonCompliant = json['percentNonCompliant'] as int
    ..percentComplete = json['percentComplete'] as int
    ..percentAdvisory = json['percentAdvisory'] as int
    ..percentCompliant = json['percentCompliant'] as int;
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
