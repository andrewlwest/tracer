import 'package:json_annotation/json_annotation.dart';
import 'observation.dart';

part 'observationGroup.g.dart';

@JsonSerializable()
class ObservationGroup  extends Object with _$ObservationGroupSerializerMixin {
  String groupTitle;
  List <Observation> observations; 
  
  ObservationGroup(this.groupTitle, this.observations);
  
  factory ObservationGroup.fromJson(Map<String, dynamic> json) => _$ObservationGroupFromJson(json);

}