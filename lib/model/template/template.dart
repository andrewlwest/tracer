import 'package:json_annotation/json_annotation.dart';
part 'template.g.dart';

@JsonSerializable()
class Template extends Object with _$TemplateSerializerMixin {

  List<ObservationGroup> observationGroups;
  String version;
  Map<String, ObservationException> exceptions;
  Map<String, ObservationCategory> observationCategories;

  Template(this.observationGroups, this.version, this.exceptions, this.observationCategories);

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

}

@JsonSerializable()
class ObservationGroup extends Object with _$ObservationGroupSerializerMixin {

  String groupTitle;

  @JsonKey(name: 'observationCategoryDefinitions')
  List<ObservationCategory> observationCategories;

  ObservationGroup(this.groupTitle, this.observationCategories);

  factory ObservationGroup.fromJson(Map<String, dynamic> json) =>
      _$ObservationGroupFromJson(json);

}

@JsonSerializable()
class ObservationCategory extends Object with _$ObservationCategorySerializerMixin {

  String observationCategoryId;
  String displayName;
  List<String> exceptionIds;

  ObservationCategory(this.observationCategoryId,this.displayName,this.exceptionIds);

  factory ObservationCategory.fromJson(Map<String, dynamic> json) =>
      _$ObservationCategoryFromJson(json);

}

@JsonSerializable()
class ObservationException extends Object with _$ObservationExceptionSerializerMixin {
  String exceptionId;
  String text;

  ObservationException(this.exceptionId, this.text);

  factory ObservationException.fromJson(Map<String, dynamic> json) =>
      _$ObservationExceptionFromJson(json);
}