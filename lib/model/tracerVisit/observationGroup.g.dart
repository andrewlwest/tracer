// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observationGroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObservationGroup _$ObservationGroupFromJson(Map<String, dynamic> json) {
  return new ObservationGroup(
      json['groupTitle'] as String,
      (json['observations'] as List)
          ?.map((e) => e == null
              ? null
              : new Observation.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

abstract class _$ObservationGroupSerializerMixin {
  String get groupTitle;
  List<Observation> get observations;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'groupTitle': groupTitle, 'observations': observations};
}
