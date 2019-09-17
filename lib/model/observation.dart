import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'observation.g.dart';

@JsonSerializable()
class Observation extends Object with _$ObservationSerializerMixin {
  
  @JsonKey(name: 'SME')
  User sme;

  String comment;
  String freeTextException;
  String score;
  String observationCategoryId;
  String displayName;
  
  @JsonKey(defaultValue: true)
  bool noExceptionsFound;

  // holding place for all exceptions
  @JsonKey(ignore: true)
  Map<String, ObservationException> exceptions;

  @JsonKey(ignore: true)
  String visitId;

  Observation(this.sme, this.comment, this.freeTextException, this.score, this.observationCategoryId,
      this.displayName, this.noExceptionsFound);

  factory Observation.fromJson(Map<String, dynamic> json) =>
      _$ObservationFromJson(json);
}
