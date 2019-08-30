// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observationGroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObservationGroup _$ObservationGroupFromJson(Map<String, dynamic> json) {
  return new ObservationGroup(json['groupTitle'] as String,
      (json['observationIds'] as List)?.map((e) => e as String)?.toList());
}

abstract class _$ObservationGroupSerializerMixin {
  String get groupTitle;
  List<String> get observationIds;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'groupTitle': groupTitle,
        'observationIds': observationIds
      };
}
