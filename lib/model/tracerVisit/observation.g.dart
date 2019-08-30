// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Observation _$ObservationFromJson(Map<String, dynamic> json) {
  return new Observation(
      json['freeTextException'] as String,
      json['score'] as String,
      json['observationId'] as String,
      json['displayName'] as String,
      json['noExceptionsFound'] as bool);
}

abstract class _$ObservationSerializerMixin {
  String get freeTextException;
  String get score;
  String get observationId;
  String get displayName;
  bool get noExceptionsFound;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'freeTextException': freeTextException,
        'score': score,
        'observationId': observationId,
        'displayName': displayName,
        'noExceptionsFound': noExceptionsFound
      };
}
