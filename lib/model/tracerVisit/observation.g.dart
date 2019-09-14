// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Observation _$ObservationFromJson(Map<String, dynamic> json) {
  return new Observation(
      json['SME'] == null
          ? null
          : new User.fromJson(json['SME'] as Map<String, dynamic>),
      json['comment'] as String,
      json['freeTextException'] as String,
      json['score'] as String,
      json['observationCategoryId'] as String,
      json['displayName'] as String,
      json['noExceptionsFound'] as bool);
}

abstract class _$ObservationSerializerMixin {
  User get sme;
  String get comment;
  String get freeTextException;
  String get score;
  String get observationCategoryId;
  String get displayName;
  bool get noExceptionsFound;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'SME': sme,
        'comment': comment,
        'freeTextException': freeTextException,
        'score': score,
        'observationCategoryId': observationCategoryId,
        'displayName': displayName,
        'noExceptionsFound': noExceptionsFound
      };
}
