import 'dart:async';
import 'dart:convert';

import 'package:Tracer/model/tracerVisit/tracerVisit.dart';
import 'package:http/http.dart' as http;
import 'package:Tracer/constants.dart';
import 'package:Tracer/model/visitListItem.dart';
import 'package:Tracer/model/userListItem.dart';
import 'package:Tracer/model/place.dart';

import 'package:Tracer/model/observationTemplates/observationTemplates.dart';

class TracerService {
  static const Map<String, dynamic> _DEFAULT_PARAMS = <String, dynamic>{
    'endpoint': TRACER_SERVICE_ENDPOINT,
    'apiKey': TRACER_SERVICE_API_KEY,
    'oncallwebAuthEndPoint': ONCALLWEB_AUTH_ENDPOINT,
    'oncallWebServiceKey': ONCALLWEB_SERVICE_KEY
  };

  TracerService();

  Future<dynamic> getTracerServiceResponse(dynamic body) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': _buildParams()['apiKey'],
    };

    final response = await http.post(_buildParams()['endpoint'],
        body: body, headers: headers);
    final responseJson = json.decode(response.body);
    String success = responseJson['tracerServiceResponse']['success'];

    if ('true' == success) {
      return responseJson;
    } else {
      throw ("post to server falied!");
    }
  }

  Future<bool> login(String login, String pass) async {

    Map<String, String> headers = {
      'OncallWeb-Mojo-Key': _buildParams()['oncallWebServiceKey'],
    };

    Map<String, String> body = {
      'PartnersUsername': login,
      'PartnersPassword': pass,
    };

    //var body = "PartnersUsername=" + login + "&PartnersPassword=" + pass;
    print("TracerService: login: body = " + body.toString());

    final response = await http.post(_buildParams()['oncallwebAuthEndPoint'], body: body, headers: headers);

    print(response.body);
    return true;
  }

  Future<List<UserListItem>> getAllUsers() async {
    var body = json.encode({"method": "getUsers"});
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

    if ('true' == success) {
      List<UserListItem> list = new List<UserListItem>();
      List userItems = responseJson['tracerServiceResponse']['result']['users'];

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

  Future<TracerVisit> getTracerVisit(String visitId) async {
    var body = json.encode({
      "method": "getTracerVisit",
      "tracerVisit": {"id": visitId}
    });
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

    if ('true' == success) {
      Map<String, dynamic> visitJSONItems =
          responseJson['tracerServiceResponse']["result"];

      if (visitJSONItems != null) {
        TracerVisit list = TracerVisit.fromJson(visitJSONItems);
        return list;
      }
      return null;
    } else {
      return null;
    }
  }

  Future<ObservationTemplates> getObservationTemplates() async {
    var body = json.encode({"method": "getObservationsTemplate"});
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

    if ('true' == success) {
      Map<String, dynamic> visitJSONItems =
          responseJson['tracerServiceResponse']["result"];

      if (visitJSONItems != null) {
        ObservationTemplates list =
            ObservationTemplates.fromJson(visitJSONItems);
        return list;
      }
      return null;
    } else {
      return null;
    }
  }

  Future<List<VisitListItem>> getAllVisits() async {
    var body = json.encode({"method": "getTracerVisitList", "filter": "all"});
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

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
  }

  Future<List<Place>> getPlaces() async {
    var body = json.encode({"method": "getPlaces"});
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

    if ('true' == success) {
      List placeList = responseJson['tracerServiceResponse']["result"]["places"];
      List<Place> returnList = new List<Place>();

      if (placeList != null) {
        for (var place in placeList) {
          returnList.add(Place.fromJson(place));
        }
      } 
      return returnList;
    } else {
      return null;
    }
  }

  Map<String, dynamic> _buildParams({Map<String, dynamic> otherParams}) {
    final params = new Map<String, dynamic>.from(_DEFAULT_PARAMS);
    if (otherParams != null) {
      params.addAll(otherParams);
    }
    return params;
  }
}
