import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
//import 'package:http_client/http_client.dart' as http;
import 'dart:io';

import 'package:Tracer/constants.dart';
import 'package:Tracer/model/visitListItem.dart';
import 'package:Tracer/model/userListItem.dart';
import 'package:Tracer/model/site.dart';
import 'package:Tracer/model/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TracerService {
  static const Map<String, dynamic> _DEFAULT_PARAMS = <String, dynamic>{
    'endpoint': TRACER_SERVICE_ENDPOINT,
    'apiKey': TRACER_SERVICE_API_KEY,
    'oncallwebAuthEndPoint': ONCALLWEB_AUTH_ENDPOINT,
    'oncallWebServiceKey': ONCALLWEB_SERVICE_KEY
  };

  TracerService(); 

  Future<List<Site>> getSites(String organization) async {
    var body = json.encode({"method": "getLocations"});

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': _buildParams()['apiKey'],
    };

    final response = await http.post(_buildParams()['endpoint'],
        body: body, headers: headers);
    final responseJson = json.decode(response.body);
    String success = responseJson['tracerServiceResponse']["success"];

    if ('true' == success) {
      List<Site> list = new List<Site>();
      List siteItems = responseJson['tracerServiceResponse']["result"]['organization']['site'];

      if (siteItems != null) {
        for (var item in siteItems) {
          list.add(Site.fromJson(item));
        }
      }
      return list;
    } else {
      return null;
    }
  }


  Future<bool> login(String login, String pass) async {
    
    //var body = "PartnersUsername=" + login + "&PartnersPassword=" + pass;
    var body = "PartnersUsername=alw4&PartnersPassword=PaddleSup00";
    //print(body);

    Map<String, String> headers = {
      'Content-type': 'text/plain',
      'OncallWeb-Mojo-Key': _buildParams()['oncallWebServiceKey'],
    };

    final response = await http.post(_buildParams()['oncallwebAuthEndPoint'], body: body, headers: headers);
    //final responseJson = json.decode(response.body);

    print(response.body);
    return true;
    
  }

  Future<List<UserListItem>> getAllUsers() async {
    var body = json.encode({"method": "getUsers"});

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': _buildParams()['apiKey'],
    };

    final response = await http.post(_buildParams()['endpoint'],
        body: body, headers: headers);
    final responseJson = json.decode(response.body);

    print(responseJson);
    
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


  Future<dynamic> getTracerServiceResponse(dynamic body) async {

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'x-api-key': _buildParams()['apiKey'],
      };

      final response = await http.post(_buildParams()['endpoint'], body: body, headers: headers);
      final responseJson = json.decode(response.body);

      String success = responseJson['tracerServiceResponse']["success"];

      if ('true' == success) {
        return responseJson;
      } else {

        // look for error messaes or codes here

        throw("post to server falied!");
      }

  }
Future<List<VisitListItem>> getAllVisits() async {

    var body = json.encode({"method": "getTracerVisitList"});
    final responseJson = await getTracerServiceResponse(body);

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