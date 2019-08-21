// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userListItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserListItem _$UserListItemFromJson(Map<String, dynamic> json) {
  return new UserListItem(
      name: json['name'] as String,
      username: json['username'] as String,
      department: json['department'] as String);
}

abstract class _$UserListItemSerializerMixin {
  String get name;
  String get username;
  String get department;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'username': username,
        'department': department
      };
}
