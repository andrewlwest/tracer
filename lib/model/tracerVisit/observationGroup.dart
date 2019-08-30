import 'package:json_annotation/json_annotation.dart';

part 'observationGroup.g.dart';

@JsonSerializable()
class ObservationGroup extends Object with _$ObservationGroupSerializerMixin {
  String groupTitle;
  List<String> observationIds;

  ObservationGroup(this.groupTitle, this.observationIds);

  factory ObservationGroup.fromJson(Map<String, dynamic> json) =>
      _$ObservationGroupFromJson(json);
}
