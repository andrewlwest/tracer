import 'package:Tracer/model/place.dart';
import 'package:json_annotation/json_annotation.dart';


/// This allows the `VisitListItem` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'visitListItem.g.dart';

enum Category {
  all,
  today,
  upcoming,
  past,
}

/*
                "completionStatus": null,
                "summary": "Postman example, 2019-09-06 template",
                "participants": "Mike waz here. And all of us",
                "summaryStats": {
                    "percentNonCompliant": 0,
                    "percentComplete": 0,
                    "percentAdvisory": 0,
                    "percentCompliant": 0
                },
                "todo": "Honey do. Honey don't",
                "visitDatetime": "2019-08-28T15:00:00",
                "place": {
                    "placeId": "13",
                    "name": "Bulfinch Medical Group",
                    "site": "50 Staniford",
                    "location": "50 Staniford Street - 9th Floor",
                    "type": "Ambulatory"
                },
                "id": "b3e8e77b010147d888ccad43bb8bca59",
                "type": "comprehensive"
*/

// to generate json serializable helper class:
// flutter pub run build_runner build

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class VisitListItem extends Object with _$VisitListItemSerializerMixin {
  VisitListItem(this.id, this.place, this.summary, this.participants,
      this.todo, this.visitDatetime, this.type);

  String id;
  Place place;
  String summary;
  String participants;
  String todo;
  DateTime visitDatetime;
  SummaryStats summaryStats;
  String type;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory VisitListItem.fromJson(Map<String, dynamic> json) =>
      _$VisitListItemFromJson(json);

  @override
  String toString() => "$place (id=$id)";
}

@JsonSerializable()
class SummaryStats extends Object with _$SummaryStatsSerializerMixin {

  int percentNonCompliant;
  int percentComplete;
  int percentAdvisory;
  int percentCompliant;
  
  SummaryStats();

  factory SummaryStats.fromJson(Map<String, dynamic> json) => _$SummaryStatsFromJson(json);

}
