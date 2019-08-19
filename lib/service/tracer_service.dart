import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
//import 'package:http_client/http_client.dart' as http;
import 'dart:io';

import 'package:Tracer/constants.dart';
import 'package:Tracer/model/visitListItem.dart';
import 'package:Tracer/model/userListItem.dart';

import 'package:Tracer/service/tracer_service_response.dart';

class TracerService {

  static const Map<String, dynamic> _DEFAULT_PARAMS = <String, dynamic> {
    'endpoint': TRACER_SERVICE_ENDPOINT,
    'apiKey': TRACER_SERVICE_API_KEY
  };

  TracerService() {

  }

  Future<List<UserListItem>> getAllUsers() async {

    var body = json.encode({"method": "getUsers"});

    Map<String,String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
      'x-api-key': _buildParams()['apiKey'],
    };

    final response = await http.post(_buildParams()['endpoint'], body: body, headers: headers);
    final responseJson = json.decode(response.body);
    String success = responseJson['tracerServiceResponse']["success"];

    if ('true' == success) {
      List<UserListItem> list = new List<UserListItem>();
      List userItems = responseJson['tracerServiceResponse']["result"]['users'];

      if (userItems != null) {
        for (var item in userItems) {
          list.add(UserListItem.fromJson(item));
        }
      }
      return list;
    } else {
      return null;
    }
  }

  Future<List<VisitListItem>> getAllVisits() async {

    var body = json.encode({"method": "getTracerVisitList"});

    Map<String,String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
      'x-api-key': _buildParams()['apiKey'],
    };

    final response = await http.post(_buildParams()['endpoint'], body: body, headers: headers);
    final responseJson = json.decode(response.body);
    String success = responseJson['tracerServiceResponse']["success"];

    if ('true' == success) {
      List<VisitListItem> list = new List<VisitListItem>();
      List visitJSONItems = responseJson['tracerServiceResponse']["result"];

      if (visitJSONItems != null) {
        for (var item in visitJSONItems) {
          list.add(VisitListItem.fromJson(item));
        }
      }
      return list;
    } else {
      return null;
    }

    /* --- App Sync 
    String jsonString = await APP_SYNC_CHANNEL.invokeMethod(QUERY_GET_ALL_MESSAGES, _buildParams());
    List<dynamic> values = json.decode(jsonString);
    return values.map((value) => Message.fromJson(value)).toList();
    */
  }

  Map<String, dynamic> _buildParams({Map<String, dynamic> otherParams}) {
    final params = new Map<String, dynamic>.from(_DEFAULT_PARAMS);
    if (otherParams != null) {
      params.addAll(otherParams);
    }
    return params;
  }
  
}