import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `VisitListItem` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'visitListItem.g.dart';

enum Category { all, today, upcoming, past, }

/*
				"id": "2e859082b1f8430c8805082d79d265f8",
				"location": "Echo Lab Blake 2",
				"organization": "The General Hospital Corporation",
				"site": "MGH",
				"summary": "My karma ran over your dogma.",
				"visitDatetime": "2019-08-09T10:00:00-04:00"
*/

// to generate json serializable helper class: 
// flutter pub run build_runner build

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class VisitListItem extends Object with _$VisitListItemSerializerMixin {

  VisitListItem(this.id, this.location, this.organization, this.site, this.summary, this.visitDateTime);

  String id;
  String location;
  String organization;
  String site;
  String summary;
  DateTime visitDateTime;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory VisitListItem.fromJson(Map<String, dynamic> json) => _$VisitListItemFromJson(json);

  @override
  String toString() => "$location (id=$id)";

}