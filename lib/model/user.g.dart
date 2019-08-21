// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return new User(json['login'] as String, json['name'] as String);
}

abstract class _$UserSerializerMixin {
  String get login;
  String get name;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'login': login, 'name': name};
}
