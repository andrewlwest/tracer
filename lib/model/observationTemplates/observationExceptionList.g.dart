// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observationExceptionList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObservationExceptionList _$ObservationExceptionListFromJson(
    Map<String, dynamic> json) {
  return new ObservationExceptionList(
      json['observationId'] as String,
      json['displayName'] as String,
      (json['exceptionList'] as List)
          ?.map((e) => e == null
              ? null
              : new ObservationException.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

abstract class _$ObservationExceptionListSerializerMixin {
  String get observationId;
  String get displayName;
  List<ObservationException> get exceptionList;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'observationId': observationId,
        'displayName': displayName,
        'exceptionList': exceptionList
      };
}
