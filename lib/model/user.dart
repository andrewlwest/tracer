import 'package:json_annotation/json_annotation.dart';

/// This allows the `site` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user.g.dart';

@JsonSerializable()
class User extends Object with _$UserSerializerMixin {

  User(this.username, this.name, this.department, this.roles);

  @JsonKey(disallowNullValue: true)
  @JsonKey(required: true)
  String username;

  @JsonKey(disallowNullValue: true)
  @JsonKey(required: true)
  String name;
  String department;
  List<String> roles;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String initials() {
    List<String> nameParts = name.split(",");
    return nameParts[1].trim().substring(0,1).toUpperCase() + nameParts[0].trim().substring(0,1).toUpperCase();
  }

  bool isAdmin() {
    return roles.contains('admin');
  }

  bool isSME() {
    return roles.contains('SME');
  }

  @override
  String toString() => "$name ($username) $department ['$roles]";
}
