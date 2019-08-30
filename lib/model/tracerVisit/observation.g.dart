// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Observation _$ObservationFromJson(Map<String, dynamic> json) {
  return new Observation(
      json['observationId'] as String, json['displayName'] as String);
}

abstract class _$ObservationSerializerMixin {
  String get observationId;
  String get displayName;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'observationId': observationId,
        'displayName': displayName
      };
}
