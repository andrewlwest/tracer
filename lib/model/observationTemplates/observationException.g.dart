// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observationException.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
