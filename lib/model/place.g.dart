// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return new Place(
      json['placeId'] as String,
      json['name'] as String,
      json['site'] as String,
      json['location'] as String,
      json['type'] as String);
}

abstract class _$PlaceSerializerMixin {
  String get placeId;
  String get name;
  String get site;
  String get location;
  String get type;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'placeId': placeId,
        'name': name,
        'site': site,
        'location': location,
        'type': type
      };
}
