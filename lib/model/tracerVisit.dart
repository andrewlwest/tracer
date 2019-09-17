import 'package:Tracer/model/place.dart';
import 'package:Tracer/model/template/template.dart';
import 'package:json_annotation/json_annotation.dart';
import 'observation.dart';

part 'tracerVisit.g.dart';

@JsonSerializable()
class TracerVisit extends Object with _$TracerVisitSerializerMixin {

  String id;
  Place place;
  String summary;
  String participants;
  String todo;
  DateTime visitDatetime;
  SummaryStats summaryStats;
  String completionStatus;

  @JsonKey(name: 'observationCategories')
  Map<String, Observation> observations;
  
  Map<String, ObservationException> exceptions;
  
  @JsonKey(name: 'template_version')
  String templateVersion;
  String type;

  TracerVisit(
    this.id,
    this.place,
    this.summary,
    this.summaryStats,
    this.todo,
    this.participants,
    this.completionStatus,
    this.observations,
    this.exceptions,
    this.templateVersion,
    this.type);

  factory TracerVisit.fromJson(Map<String, dynamic> json) =>
      _$TracerVisitFromJson(json);
}

@JsonSerializable()
class SummaryStats  extends Object with _$SummaryStatsSerializerMixin {
    int percentNonCompliant;
    int percentComplete;
    int percentAdvisory;
    int percentCompliant;
  
  SummaryStats(this.percentNonCompliant, this.percentComplete, this.percentAdvisory, this.percentCompliant);
  
  factory SummaryStats.fromJson(Map<String, dynamic> json) => _$SummaryStatsFromJson(json); 
}