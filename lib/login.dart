// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//import 'dart:async';
import 'dart:io';

import 'package:Tracer/ui/colors.dart';
//import 'package:aws_client/lambda.dart';

import 'package:flutter/material.dart';

/*
import 'package:aws_client/aws_client.dart';
import 'package:http_client/console.dart';
import 'package:aws_client/src/credentials.dart';
*/

import 'package:Tracer/model/userListItem.dart';
import 'package:Tracer/model/user.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; 


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final TracerService svc = TracerService();
  List<UserListItem> userList = List<UserListItem>();


  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {

    userList = await svc.getAllUsers();

    print("here");
    /*
     messageService.subscribeNewMessage();
    _messages.addAll(await messageService.getAllMessages());
    if (mounted) {
      setState(() {
        // refresh
      });
    }
    */

  /*
      function_arn: ' 'arn:aws:lambda:us-east-1:913250585160:function:hello_whirled'
      endpoint: 'https://lambda.us-east-1.amazonaws.com'
      region: 'us-east-1'
      accessKeyId: 'AKIA5JIP2BJEF3BS6CFI'
      secretAccessKey: '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'
      */

/*
      var httpClient = new ConsoleClient();
      var credentials = new Credentials(accessKey: 'AKIA5JIP2BJEF3BS6CFI', secretKey: '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');
      var aws = new Aws(credentials: credentials, httpClient: httpClient);
      var lambda  = aws.lambda('us-east-1');

      await lambda.invoke('arn:aws:lambda:us-east-1:913250585160:function:hello_whirled', '{"method": "hello_whirled"}', invocationType: LambdaInvocationType.RequestResponse);
*/
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTracersBlue900,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/tracer-logo-ko.png'),
                SizedBox(height: 16.0),
              ],
            ),
            SizedBox(height: 120.0),
            // [Name]
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: kTracersWhite,
                labelText: 'Username',
              ),
            ),
            // spacer
            SizedBox(height: 12.0),
            // [Password]
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: kTracersWhite,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('LOG IN'),
                  textColor: kTracersWhite,
                  onPressed: () {

                    login(context);
                    

                    //Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> login(BuildContext context) async {
    
    String login = _usernameController.value.text;
    String pass = _passwordController.value.text;
    
    //bool success = await svc.login(login, pass);
    bool success = true;
    print("success = " + (success ? "true":"false"));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Iterable<UserListItem> filteredUserList = userList.where((user) => (user.username == login));
    for (UserListItem item in filteredUserList) {
    
    //prefs.setString(key, value)
      
      print('hello ' + item.name + ' dept:' + item.department);

    } 

    print('end');

    Navigator.pop(context);

  /*
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VisitDetailPage(visitId: visit.id)),
    );
  */
  
  }




}
