// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracer_service_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TracerServiceResponse _$TracerServiceResponseFromJson(
    Map<String, dynamic> json) {
  return new TracerServiceResponse(
      json['errorCode'] as String,
      json['errorMessage'] as String,
      json['request'] as Map<String, dynamic>,
      json['success'] as String);
}

abstract class _$TracerServiceResponseSerializerMixin {
  String get errorCode;
  String get errorMessage;
  Map<String, dynamic> get request;
  String get success;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'request': request,
        'success': success
      };
}
