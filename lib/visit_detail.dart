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

import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/tracerVisit/observation.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';
import 'service/tracer_service.dart';
import 'model/tracerVisit/tracerVisit.dart';
import 'logExceptions.dart';


class VisitDetailPage extends StatefulWidget {
  static const String id = 'visit_detail_page_id';
  VisitDetailPage({@required this.visitId});

  final String visitId;

  @override
  _VisitDetailPageState createState() => _VisitDetailPageState(visitId: visitId);
}

class _VisitDetailPageState extends State<VisitDetailPage> {
  
  final String visitId;
  final TracerService svc = new TracerService();
  Template template;

  _VisitDetailPageState({this.visitId});

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    // load stuff here
  }

  Future<Map<String, dynamic>> fetchVisitData(String visitId) async { // you need to return a Future to the FutureBuilder
    Map<String, dynamic> returnMap = new Map<String, dynamic>();
    returnMap['template'] = await svc.getTemplate();
    returnMap['visit'] = await svc.getTracerVisit(visitId);
    return returnMap;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchVisitData(this.visitId),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? VisitDetailView(tracerVisit: snapshot.data['visit'], template: snapshot.data['template'])
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}


/*
class VisitDetailPage extends StatelessWidget {
  static const String id = 'visit_detail_page_id';
  VisitDetailPage({@required this.visitId});
  final String visitId;


  final TracerService svc = new TracerService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TracerVisit>(
      future: svc.getTracerVisit(this.visitId),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? VisitDetailView(tracervisit: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
*/

class VisitDetailView extends StatelessWidget {
  final TracerVisit tracerVisit;
  final Template template;

  const VisitDetailView({this.tracerVisit, this.template});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kTracersBlue500,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                semanticLabel: 'back',
              ),
              onPressed: () {
                print('Back');
                Navigator.pop(context);
              },
            ),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("ASSIGNED")),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("ALL")),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("FAVORITES")),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("EXCEPTIONS"))
              ],
            ),
            title: Text(tracerVisit.place.location),
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(
            //       Icons.search,
            //       semanticLabel: 'search',
            //     ),
            //     onPressed: () {
            //       print('Search button');
            //     },
            //   ),
            //   IconButton(
            //     icon: Icon(
            //       Icons.more_vert,
            //       semanticLabel: 'more',
            //     ),
            //     onPressed: () {
            //       print('More button');
            //     },
            //   ),
            // ],
          ),
          body: TabBarView(
            children: <Widget>[
              //ASSIGNED OBSERVATION CATEGORIES TAB PANE CONTENT
              ListView(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                //padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  ...template.observationGroups.map((observationGroup) {
                    return VisitDetailItemView(
                        visitId: tracerVisit.id,
                        observationGroup: observationGroup,
                        observations: tracerVisit.observations,
                        template: template);
                  }).toList(),
                ],
              ),

              //ALL TAB PANE CONTENT
              ListView(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                //padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  Text(
                    "//ALL LIST GOES HERE",
                  ),
                ],
              ),

              //FAV TAB PANE CONTENT
              ListView(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                //padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  Text(
                    "//FAVORITES LIST GOES HERE",
                  ),
                ],
              ),

              //EXCEPTIONS ONLY PANE CONTENT
              ListView(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                //padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  Text(
                    "//EXCEPTIONS ONLY",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class VisitDetailItemView extends StatelessWidget {
  final ObservationGroup observationGroup;
  final Map<String, Observation> observations;
  final Template template;
  final String visitId;

  const VisitDetailItemView({this.visitId, this.observationGroup, this.observations, this.template});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 18.0),
          Text(
            observationGroup.groupTitle,
            maxLines: 1,
            style: Theme.of(context).textTheme.subhead,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8.0),
          ...observationGroup.observationCategories.map((observationCategory) {
            return ObsCatListTileView(
              observationCategory: observationCategory,
              observation: observations[observationCategory.observationCategoryId],
              template: template,
              visitId: visitId
            );
          }).toList(),
        ],
      ),
    );
  }
}

class ObsCatListTileView extends StatelessWidget {

  final ObservationCategory observationCategory;
  final Observation observation;
  final String visitId;
  final Template template;

  const ObsCatListTileView({this.observationCategory, this.observation, this.visitId, this.template});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: () {
              print('Go to next page;');
              _onTapItem(
                  context: context,
                  observationCategoryId: observation.observationCategoryId,
                  visitId: visitId,
                  template: template);
            },
            leading: SizedBox(
              width: 40,
              height: 42,
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    // IF ASSIGNED IT WILL HAVE A PHOTO OR INITIALS
                    //backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
                    //child: Text('BH'),
                    //END IF ASSIGNED

                    //IF NOT ASSIGNED IT WILL BE JUST A ICON WITH A WHITE BACKGROUND
                    child: Icon(
                      FontAwesomeIcons.solidUserCircle,
                      size: 35,
                      color: kTracersGray300,
                    ),
                    backgroundColor: kTracersWhite,
                    //END IF NOT ASSIGNED
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                    alignment: Alignment.bottomCenter,
                    child: CircleAvatar(
                      maxRadius: 8,

                      //IF NOT YEY ASSESED FLAG ICON IS GRAY
                      backgroundColor: kTracersGray300,

                      //IF NO EXCEOPTIONS FOUND ICON IS BLUE
                      //backgroundColor: kTracersBlue500,

                      //IF EXCEPTIONS FOUND FLAG ICON IS RED
                      //backgroundColor: kTracersRed500,

                      child: Icon(
                        Icons.flag,
                        size: 12,
                        color: kTracersWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              observation.displayName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: Icon(
              //ICON IS GREEN CHECK IF COMPLIANT
              FontAwesomeIcons.solidCheckCircle,
              color: kTracersGreen500,

              //ICON IS YELLOW ! IF ADVISORY
              //FontAwesomeIcons.exclamationCircle,
              //color: kTracersYellow500,

              //ICON IS RED X IF NON COMPLIANT
              //FontAwesomeIcons.solidTimesCircle,
              //color: kTracersRed500,
              size: 16.0,
            ),
          ),
          Divider(
            height: 1.0,
            indent: 55.0,
            endIndent: 0,
          ),
        ],
      ),
    );
  }

  void _onTapItem({BuildContext context, String observationCategoryId, String visitId, Template template}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LogExceptions(
                visitId: visitId,
                observationCategoryId: observationCategoryId,
                template: template,
              )),
    );
  }
}
