// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observationGroups.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObservationGroups _$ObservationGroupsFromJson(Map<String, dynamic> json) {
  return new ObservationGroups(json['groupTitle'] as String,
      (json['observationIds'] as List)?.map((e) => e as String)?.toList());
}

abstract class _$ObservationGroupsSerializerMixin {
  String get groupTitle;
  List<String> get observationIds;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'groupTitle': groupTitle,
        'observationIds': observationIds
      };
}
