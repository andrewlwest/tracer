// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['username', 'name']);
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
  Map<String, dynamic> toJson() {
    var val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('username', username);
    writeNotNull('name', name);
    val['department'] = department;
    val['roles'] = roles;
    return val;
  }
}
