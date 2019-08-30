import 'package:json_annotation/json_annotation.dart';
part 'observation.g.dart';

@JsonSerializable()
class Observation extends Object with _$ObservationSerializerMixin {
  String freeTextException;
  String score;
  String observationId;
  String displayName;
  bool noExceptionsFound;

  Observation(this.freeTextException, this.score, this.observationId,
      this.displayName, this.noExceptionsFound);

  factory Observation.fromJson(Map<String, dynamic> json) =>
      _$ObservationFromJson(json);
}
