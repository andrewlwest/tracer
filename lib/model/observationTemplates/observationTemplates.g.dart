// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observationTemplates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObservationTemplates _$ObservationTemplatesFromJson(Map<String, dynamic> json) {
  return new ObservationTemplates(
      (json['observationGroups'] as List)
          ?.map((e) => e == null
              ? null
              : new ObservationGroups.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['observationDefinitions'] as Map<String, dynamic>)?.map((k, e) =>
          new MapEntry(
              k,
              e == null
                  ? null
                  : new ObservationExceptionList.fromJson(
                      e as Map<String, dynamic>))));
}

abstract class _$ObservationTemplatesSerializerMixin {
  List<ObservationGroups> get observationGroups;
  Map<String, ObservationExceptionList> get observationDefinitions;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'observationGroups': observationGroups,
        'observationDefinitions': observationDefinitions
      };
}
