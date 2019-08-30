import 'package:json_annotation/json_annotation.dart';

part 'tracer_service_response.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class TracerServiceResponse extends Object
    with _$TracerServiceResponseSerializerMixin {
  TracerServiceResponse(
      this.errorCode, this.errorMessage, this.request, this.success);

  String errorCode;
  String errorMessage;
  Map<String, dynamic> request;
  String success;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory TracerServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$TracerServiceResponseFromJson(json);
}
