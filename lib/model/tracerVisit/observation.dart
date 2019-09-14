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
  bool noExceptionsFound;

  Observation(this.sme, this.comment, this.freeTextException, this.score, this.observationCategoryId,
      this.displayName, this.noExceptionsFound);

  factory Observation.fromJson(Map<String, dynamic> json) =>
      _$ObservationFromJson(json);
}
