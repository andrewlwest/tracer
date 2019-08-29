import 'package:json_annotation/json_annotation.dart';
part 'observation.g.dart';

@JsonSerializable()
class Observation  extends Object with _$ObservationSerializerMixin {
  String observationId;
  String displayName; 
  
  Observation(this.observationId, this.displayName);
  
  factory Observation.fromJson(Map<String, dynamic> json) => _$ObservationFromJson(json);

}