import 'package:json_annotation/json_annotation.dart';
import 'summaryStatus.dart';
import 'observationGroup.dart';
part 'tracerVisit.g.dart';

@JsonSerializable()
class TracerVisit extends Object with _$TracerVisitSerializerMixin {

  String summary;
  String location; 
  String todo;
  String participants;
  String site;
  String completionStatus;
  List<ObservationGroup> observationGroups;
  SummaryStatus summaryStatus;

  TracerVisit(this.summary, this.location, this.summaryStatus, this.todo, this.participants, this.site, this.completionStatus, this.observationGroups);
  
  factory TracerVisit.fromJson(Map<String, dynamic> json) => _$TracerVisitFromJson(json);

}