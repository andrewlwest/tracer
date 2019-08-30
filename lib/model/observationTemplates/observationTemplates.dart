import 'package:json_annotation/json_annotation.dart';
import 'observationGroups.dart';
import 'observationExceptionList.dart';

part 'observationTemplates.g.dart';

@JsonSerializable()
class ObservationTemplates extends Object
    with _$ObservationTemplatesSerializerMixin {
  List<ObservationGroups> observationGroups;
  Map<String, ObservationExceptionList> observationDefinitions;

  ObservationTemplates(this.observationGroups, this.observationDefinitions);

  factory ObservationTemplates.fromJson(Map<String, dynamic> json) =>
      _$ObservationTemplatesFromJson(json);
}
