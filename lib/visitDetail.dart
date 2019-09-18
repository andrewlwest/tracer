import 'package:Tracer/application/appData.dart';
import 'package:Tracer/model/observation.dart';
import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/tracerVisit.dart';
import 'package:Tracer/observationDetail.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:Tracer/ui/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class VisitDetailPageArguments {
  final String visitId;
  VisitDetailPageArguments(this.visitId);
}

class VisitDetailPage extends StatefulWidget {
  static const String id = 'visit_detail_page';
  VisitDetailPage({@required this.visitId});

  final String visitId;

  @override
  _VisitDetailPageState createState() => _VisitDetailPageState(visitId: visitId);
}

class _VisitDetailPageState extends State<VisitDetailPage> {
  
  final String visitId;
  final TracerService svc = new TracerService();

  _VisitDetailPageState({this.visitId});

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    // load stuff here
  }

  Future<TracerVisit> fetchVisitData(String visitId) async { // you need to return a Future to the FutureBuilder
    var visit = await svc.getTracerVisit(visitId);
    return visit;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TracerVisit>(
      future: fetchVisitData(this.visitId),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? VisitDetailView(snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class VisitDetailView extends StatelessWidget {
  final TracerVisit tracerVisit;

  const VisitDetailView(this.tracerVisit);

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

            /*
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
            */
            title: Text(tracerVisit.place.name),
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
                  ...appData.template.observationGroups.map((observationGroup) {
                    return VisitDetailItemView(
                        visit: tracerVisit,
                        observationGroup: observationGroup);
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

// observation groups
class VisitDetailItemView extends StatelessWidget {
  final ObservationGroup observationGroup;
  final TracerVisit visit;

  const VisitDetailItemView({this.visit, this.observationGroup});

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
              observation: visit.observations[observationCategory.observationCategoryId],
              visitId: visit.id
            );
          }).toList(),
        ],
      ),
    );
  }
}

Widget _observationAssignmentStatus(Observation observation) {
  if (observation != null && observation.sme != null && observation.sme.name != null) {

    List<String> nameParts= observation.sme.name.split(",");
    String initials = nameParts[1].trim().substring(0,1).toUpperCase() + nameParts[0].trim().substring(0,1).toUpperCase();

    return CircleAvatar(
      backgroundColor: kTracersBlue900,
      child: Text(initials),
    );
  } else {
    return CircleAvatar(
      child: Icon(
        FontAwesomeIcons.solidUserCircle,
        size: 35,
        color: kTracersGray300,
      ),
      backgroundColor: kTracersWhite,
    );
  }
}

Widget _observationExceptionStatus(Observation observation) {
  if (observation == null || observation.score == null) {
      return CircleAvatar(
        maxRadius: 8,
        backgroundColor: kTracersGray300,
        child: Icon(
          Icons.flag,
          size: 12,
          color: kTracersWhite,
        ),
      );
  } else if (observation.noExceptionsFound) {
      return CircleAvatar(
        maxRadius: 8,
        backgroundColor: kTracersBlue500,
        child: Icon(
          Icons.flag,
          size: 12,
          color: kTracersWhite,
        ),
      );
  } else {
      return CircleAvatar(
        maxRadius: 8,
        backgroundColor: kTracersRed500,
        child: Icon(
          Icons.flag,
          size: 12,
          color: kTracersWhite,
        ),
      );
  }
}

Widget _observationScoreIcon(Observation observation) {

  if (observation != null && observation.score != null) {
    if (observation.score == "compliant") {
      return Icon(
        FontAwesomeIcons.solidCheckCircle,
        color: kTracersGreen500,
        size: 16.0,);
    } else if (observation.score == "advisory") {
      return Icon(
        FontAwesomeIcons.exclamationCircle,
        color: kTracersYellow500,
        size: 16.0,);
    } else if (observation.score == "nonCompliant") {
      return Icon(
        FontAwesomeIcons.solidTimesCircle,
        color: kTracersRed500,
        size: 16.0,);
    } else if (observation.score == "notApplicable") {
      return Icon(
        FontAwesomeIcons.ban,
        color: kTracersGray500,
        size: 16.0,);
    } else if (observation.score == "notAssessed") {
      return Icon(
        FontAwesomeIcons.circle,
        color: kTracersGray500,
        size: 16.0,);
    } else {
      return Icon(
        FontAwesomeIcons.questionCircle,
        color: kTracersGray300,
        size: 16.0,);
    }
  } else {
    return SizedBox(height: 8.0);
  }
}


class ObsCatListTileView extends StatelessWidget {

  final ObservationCategory observationCategory;
  final Observation observation;
  final String visitId;

  const ObsCatListTileView({this.observationCategory, this.observation, this.visitId});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ObservationDetailPage(
                      visitId: visitId,
                      observationCategoryId: observationCategory.observationCategoryId,
              )),
    );
              /*
              print('Go to next page;');
              _onTapItem(
                  context: context,
                  observationCategoryId: observationCategory.observationCategoryId,
                  visitId: observation.visitId);
              */
            },
            leading: SizedBox(
              width: 40,
              height: 42,
              child: Stack(
                children: <Widget>[
                  _observationAssignmentStatus(observation),

                  /*
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
                  */

                  Container(
                    padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                    alignment: Alignment.bottomCenter,
                    child: _observationExceptionStatus(observation),
                    /*
                    CircleAvatar(
                      maxRadius: 8,

                      //IF NOT YEY ASSESED FLAG ICON IS GRAY
                      //backgroundColor: kTracersGray300,

                      //IF NO EXCEOPTIONS FOUND ICON IS BLUE
                      backgroundColor: kTracersBlue500,

                      //IF EXCEPTIONS FOUND FLAG ICON IS RED
                      //backgroundColor: kTracersRed500,

                      child: Icon(
                        Icons.flag,
                        size: 12,
                        color: kTracersWhite,
                      ),
                    ),
                    */

                  ),

                ],
              ),
            ),
            title: Text(
              observation.displayName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: _observationScoreIcon(observation),
            
            /*
            Icon(
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
            */
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

}
