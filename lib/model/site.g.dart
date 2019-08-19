// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Site _$SiteFromJson(Map<String, dynamic> json) {
  return new Site(json['organization'] as String, json['name'] as String,
      (json['locations'] as List)?.map((e) => e as String)?.toList());
}

abstract class _$SiteSerializerMixin {
  String get organization;
  String get name;
  List<String> get locations;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'organization': organization,
        'name': name,
        'locations': locations
      };
}
