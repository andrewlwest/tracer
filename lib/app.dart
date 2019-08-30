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

import 'package:Tracer/login.dart';
import 'package:Tracer/visit_lists.dart';
import 'package:flutter/material.dart';

import 'addVisit.dart';
import 'ui/colors.dart';

class TracerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracer',
      home: VisitListPage(),
      //home: HomePage(),
      initialRoute: LoginPage.id,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        LoginPage.id: (context) => LoginPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        AddVisit.id: (context) => AddVisit(),
        //'/visitDetail': (context) => VisitDetailPage(),
      },
      onGenerateRoute: _getRoute,
      theme: _kTracersTheme, // New code
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    /*
    if (settings.name != '/login') {
      return null;
    }
    */

    /*

    return MaterialPageRoute<void>(
      settings: settings,
      //builder: (BuildContext context) => LogExceptions(),
      //builder: (BuildContext context) => AddVisit(),
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );

    */
  }
}

final Typography typography2018 = Typography(
  englishLike: Typography.englishLike2018,
  dense: Typography.dense2018,
  tall: Typography.tall2018,
);

final ThemeData _kTracersTheme = _buildTracersTheme();

ThemeData _buildTracersTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    typography: typography2018,
    accentColor: kTracersBlue900,
    primaryColor: kTracersBlue500,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: kTracersBlue500,
      textTheme: ButtonTextTheme.normal,
    ),
    scaffoldBackgroundColor: kTracersBackgroundWhite,
    cardColor: kTracersBackgroundWhite,
    textSelectionColor: kTracersBlue500,
    errorColor: kTracersRed500,
    textTheme: _buildTracersTextTheme(base.textTheme),
    primaryTextTheme: _buildTracersTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTracersTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTracersTextTheme(TextTheme base) {
  return base
      .copyWith(
        // headline: base.headline.copyWith(
        //   fontWeight: FontWeight.w500,
        // ),
        title: base.title.copyWith(fontSize: 18.0),
        subhead: TextStyle(color: kTracersBlue500, fontSize: 12),

        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
          //fontFamily: 'Rubik',
          //displayColor: kTracersBlue900,
          //bodyColor: kTracersBlue900,
          );
}
