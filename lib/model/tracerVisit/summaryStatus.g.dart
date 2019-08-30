// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summaryStatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryStatus _$SummaryStatusFromJson(Map<String, dynamic> json) {
  return new SummaryStatus(
      json['percentNonCompliant'] as String,
      json['percentComplete'] as String,
      json['percentAdvisory'] as String,
      json['percentCompliant'] as String);
}

abstract class _$SummaryStatusSerializerMixin {
  String get percentNonCompliant;
  String get percentComplete;
  String get percentAdvisory;
  String get percentCompliant;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'percentNonCompliant': percentNonCompliant,
        'percentComplete': percentComplete,
        'percentAdvisory': percentAdvisory,
        'percentCompliant': percentCompliant
      };
}
