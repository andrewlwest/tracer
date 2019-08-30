import 'package:json_annotation/json_annotation.dart';

part 'observationException.g.dart';

@JsonSerializable()
class ObservationException extends Object
    with _$ObservationExceptionSerializerMixin {
  String exceptionId;
  String text;

  ObservationException(this.exceptionId, this.text);

  factory ObservationException.fromJson(Map<String, dynamic> json) =>
      _$ObservationExceptionFromJson(json);
}
