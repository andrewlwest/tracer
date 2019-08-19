import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `site` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'site.g.dart';

@JsonSerializable()
class Site extends Object with _$SiteSerializerMixin {


  Site(this.organization, this.name, this.locations);

  String organization;
  String name;
  List<String> locations;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);

  @override
  String toString() => "$name (locations=$locations)";


}
