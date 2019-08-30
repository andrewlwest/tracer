import 'package:json_annotation/json_annotation.dart';

part 'observationGroups.g.dart';

@JsonSerializable()
class ObservationGroups extends Object with _$ObservationGroupsSerializerMixin {
  String groupTitle;
  List<String> observationIds;

  ObservationGroups(this.groupTitle, this.observationIds);

  factory ObservationGroups.fromJson(Map<String, dynamic> json) =>
      _$ObservationGroupsFromJson(json);
}
