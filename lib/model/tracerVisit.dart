import 'package:Tracer/model/observation.dart';
import 'package:Tracer/model/place.dart';
import 'package:Tracer/model/template/template.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracerVisit.g.dart';

@JsonSerializable()
class TracerVisit extends Object with _$TracerVisitSerializerMixin {
  String id;
  Place place;
  String summary;
  String todo;  
  String participants;
  DateTime visitDatetime;
  SummaryStats summaryStats;
  String completionStatus;
  String type;

  @JsonKey(name: 'observationCategories')
  Map<String, Observation> observations;
  
  Map<String, ObservationException> exceptions;
  
  @JsonKey(name: 'template_version')
  String templateVersion;

  TracerVisit(
    this.id,
    this.place,
    this.summary,
    this.todo,
    this.participants,
    this.visitDatetime,
    this.summaryStats,
    this.completionStatus,
    this.type,
    this.observations,
    this.exceptions,
    this.templateVersion
    );

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