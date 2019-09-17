import 'dart:async';
import 'dart:convert';

import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/tracerVisit/observation.dart';
import 'package:Tracer/model/tracerVisit/tracerVisit.dart';
import 'package:http/http.dart' as http;
import 'package:Tracer/constants.dart';
import 'package:Tracer/model/visitListItem.dart';
import 'package:Tracer/model/userListItem.dart';
import 'package:Tracer/model/place.dart';
import 'package:Tracer/model/user.dart';

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
    // remove this statement for performing auth
    //return true;

    Map<String, String> headers = {
      'OncallWeb-Mojo-Key': _buildParams()['oncallWebServiceKey'],
    };

    Map<String, String> body = {
      'PartnersUsername': login,
      'PartnersPassword': pass,
    };

    final response = await http.post(_buildParams()['oncallwebAuthEndPoint'],
        body: body, headers: headers);
    if (response.body.contains("AuthenticationSuccess")) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> savePropertyForVisit(
      String propertyName, String propertyValue, String visitId) async {
    var body = json.encode({
      "method": "setVisitProperty",
      "visitId": visitId,
      "propertyName": propertyName,
      "propertyValue": propertyValue
    });
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];
    return ('true' == success);
  }

  Future<bool> setObservationProperty(
      String propertyName,
      dynamic propertyValue,
      String visitId,
      String observationCategoryId) async {
    var body = json.encode({
      "method": "setObservationProperty",
      "visitId": visitId,
      "observationCategoryId": observationCategoryId,
      "propertyName": propertyName,
      "propertyValue": propertyValue
    });

    print(body);

    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];
    return ('true' == success);
  }

  Future<User> getUser(String login) async {
    var body = json.encode({"method": "getUsers"});
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

    if ('true' == success) {
      Map<String, dynamic> json =
          responseJson['tracerServiceResponse']['result'];
      if (json != null) {
        return User.fromJson(json);
      } else {
        return null;
      }
    } else {
      return null;
    }
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
        TracerVisit visit = TracerVisit.fromJson(visitJSONItems);
        return visit;
      }
      return null;
    } else {
      return null;
    }
  }

  Future<Template> getTemplate() async {
    var body = json.encode({"method": "getObservationsTemplate"});
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

    if ('true' == success) {
      Template template =
          Template.fromJson(responseJson['tracerServiceResponse']["result"]);

      Map<String, ObservationCategory> observationCategories =
          new Map<String, ObservationCategory>();
      for (ObservationGroup og in template.observationGroups) {
        for (ObservationCategory oc in og.observationCategories) {
          observationCategories[oc.observationCategoryId] = oc;
        }
      }
      template.observationCategories = observationCategories;
      return template;
    } else {
      return null;
    }
  }

  Future<Observation> getObservation(
      String visitId, String observationCategoryId) async {
    var body = json.encode({
      "method": "getObservation",
      "visitId": visitId,
      "observationCategoryId": observationCategoryId
    });

    print("body = " + body);
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

    if ('true' == success) {
      Observation observation = Observation.fromJson(
          responseJson['tracerServiceResponse']['result']
              ['observationCategories'][observationCategoryId]);
      return observation;
    } else {
      return null;
    }
  }

  /*
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
  */

  Future<List<VisitListItem>> getAllVisits({String filter = ''}) async {
    if (filter == '') {
      filter = 'all';
    }
    var body = json.encode({"method": "getTracerVisitList", "filter": filter});
    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

    print('in getAllVisits, filter = $filter and  success = $success');

    if ('true' == success) {
      List<VisitListItem> list = new List<VisitListItem>();
      List visitJSONItems = responseJson['tracerServiceResponse']["result"];

      if (visitJSONItems != null) {
        for (var item in visitJSONItems) {
          list.add(VisitListItem.fromJson(item));
        }
      }
      print("here");
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
      List placeList =
          responseJson['tracerServiceResponse']["result"]["places"];
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

  Future<VisitListItem> createVisit(
      DateTime dateTime, Place place, String summary, String visitType) async {
    var body = json.encode({
      "method": "createTracerVisit",
      "tracerVisit": {
        "visitDatetime": dateTime.toIso8601String(),
        "place": place,
        "summary": summary,
        "type": visitType
      }
    });
    print(body);

    final responseJson = await getTracerServiceResponse(body);
    String success = responseJson['tracerServiceResponse']['success'];

    if ('true' == success) {
      String newId = responseJson['tracerServiceResponse']['result']['id'];
      return VisitListItem(newId, place, summary, null, null, dateTime);
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
