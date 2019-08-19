import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'userListItem.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class UserListItem extends Object with _$UserListItemSerializerMixin {
  UserListItem({
    @required this.name,
    @required this.login,
    @required this.department,
  })  : assert(name != null),
        assert(login != null);

  final String name;
  final String login;
  final String department;

   /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory UserListItem.fromJson(Map<String, dynamic> json) => _$UserListItemFromJson(json);

}
