import 'package:json_annotation/json_annotation.dart';
part 'summaryStatus.g.dart';

@JsonSerializable()
class SummaryStatus  extends Object with _$SummaryStatusSerializerMixin {
  String percentNonCompliant;
  String percentComplete;
  String percentAdvisory;
  String percentCompliant;
  
  SummaryStatus(this.percentNonCompliant, this.percentComplete, this.percentAdvisory, this.percentCompliant);
  
  factory SummaryStatus.fromJson(Map<String, dynamic> json) => _$SummaryStatusFromJson(json); 
}