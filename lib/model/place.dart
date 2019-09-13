import 'package:json_annotation/json_annotation.dart';

/// This allows the `site` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'place.g.dart';

@JsonSerializable()
class Place extends Object with _$PlaceSerializerMixin {
  Place(this.placeId, this.name, this.site, this.location, this.type);

  String placeId;
  String name;
  String site;
  String location;
  String type;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  @override
  String toString() =>
      "id=$placeId name=$name site=$site location=$location type=$type";
}
