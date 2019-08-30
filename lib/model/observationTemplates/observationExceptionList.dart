import 'package:json_annotation/json_annotation.dart';
import 'observationException.dart';
part 'observationExceptionList.g.dart';

@JsonSerializable()
class ObservationExceptionList extends Object
    with _$ObservationExceptionListSerializerMixin {
  String observationId;
  String displayName;
  List<ObservationException> exceptionList;

  ObservationExceptionList(
      this.observationId, this.displayName, this.exceptionList);

  factory ObservationExceptionList.fromJson(Map<String, dynamic> json) =>
      _$ObservationExceptionListFromJson(json);
}
