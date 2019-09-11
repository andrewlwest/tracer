// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return new User(
      json['username'] as String,
      json['name'] as String,
      json['department'] as String,
      (json['roles'] as List)?.map((e) => e as String)?.toList());
}

abstract class _$UserSerializerMixin {
  String get username;
  String get name;
  String get department;
  List<String> get roles;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'name': name,
        'department': department,
        'roles': roles
      };
}
