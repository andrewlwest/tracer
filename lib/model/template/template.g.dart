// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Template _$TemplateFromJson(Map<String, dynamic> json) {
  return new Template(
      (json['observationGroups'] as List)
          ?.map((e) => e == null
              ? null
              : new ObservationGroup.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['version'] as String,
      (json['exceptions'] as Map<String, dynamic>)?.map((k, e) => new MapEntry(
          k,
          e == null
              ? null
              : new ObservationException.fromJson(e as Map<String, dynamic>))),
      (json['observationCategories'] as Map<String, dynamic>)?.map((k, e) =>
          new MapEntry(
              k,
              e == null
                  ? null
                  : new ObservationCategory.fromJson(
                      e as Map<String, dynamic>))));
}

abstract class _$TemplateSerializerMixin {
  List<ObservationGroup> get observationGroups;
  String get version;
  Map<String, ObservationException> get exceptions;
  Map<String, ObservationCategory> get observationCategories;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'observationGroups': observationGroups,
        'version': version,
        'exceptions': exceptions,
        'observationCategories': observationCategories
      };
}

ObservationGroup _$ObservationGroupFromJson(Map<String, dynamic> json) {
  return new ObservationGroup(
      json['groupTitle'] as String,
      (json['observationCategoryDefinitions'] as List)
          ?.map((e) => e == null
              ? null
              : new ObservationCategory.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

abstract class _$ObservationGroupSerializerMixin {
  String get groupTitle;
  List<ObservationCategory> get observationCategories;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'groupTitle': groupTitle,
        'observationCategoryDefinitions': observationCategories
      };
}

ObservationCategory _$ObservationCategoryFromJson(Map<String, dynamic> json) {
  return new ObservationCategory(
      json['observationCategoryId'] as String,
      json['displayName'] as String,
      (json['exceptionIds'] as List)?.map((e) => e as String)?.toList());
}

abstract class _$ObservationCategorySerializerMixin {
  String get observationCategoryId;
  String get displayName;
  List<String> get exceptionIds;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'observationCategoryId': observationCategoryId,
        'displayName': displayName,
        'exceptionIds': exceptionIds
      };
}

ObservationException _$ObservationExceptionFromJson(Map<String, dynamic> json) {
  return new ObservationException(
      json['exceptionId'] as String, json['text'] as String);
}

abstract class _$ObservationExceptionSerializerMixin {
  String get exceptionId;
  String get text;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'exceptionId': exceptionId, 'text': text};
}
