// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitListItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitListItem _$VisitListItemFromJson(Map<String, dynamic> json) {
  return new VisitListItem(
      json['id'] as String,
      json['location'] as String,
      json['organization'] as String,
      json['site'] as String,
      json['summary'] as String,
      json['visitDateTime'] == null
          ? null
          : DateTime.parse(json['visitDateTime'] as String));
}

abstract class _$VisitListItemSerializerMixin {
  String get id;
  String get location;
  String get organization;
  String get site;
  String get summary;
  DateTime get visitDateTime;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'location': location,
        'organization': organization,
        'site': site,
        'summary': summary,
        'visitDateTime': visitDateTime?.toIso8601String()
      };
}
