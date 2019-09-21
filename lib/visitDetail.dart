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
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VisitDetailPageArguments {
  final String visitId;
  final String visitPlaceName;
  VisitDetailPageArguments(this.visitId, this.visitPlaceName);
}

class VisitDetailPage extends StatefulWidget {
  static const String id = 'visit_detail_page';
  VisitDetailPage({@required this.visitId, @required this.visitPlaceName});

  final String visitId;
  final String visitPlaceName;

  @override
  _VisitDetailPageState createState() =>
      _VisitDetailPageState(visitId: visitId, visitPlaceName: visitPlaceName);
}

class _VisitDetailPageState extends State<VisitDetailPage> {
  final String visitId;
  final String visitPlaceName;

  Future<TracerVisit> _listFuture;

  final TracerService svc = new TracerService();

  _VisitDetailPageState({this.visitId, this.visitPlaceName});

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    print('in _init');
    // load stuff here
    _listFuture = svc.getTracerVisit(visitId);
  }

  void refreshList() async {
    print('in refreshList');
    // reload
    setState(() {
      _listFuture = svc.getTracerVisit(visitId);
    });
  }

  Future<TracerVisit> fetchVisitData(String visitId) async {
    // you need to return a Future to the FutureBuilder
    var visit = await svc.getTracerVisit(visitId);
    return visit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(visitPlaceName),
      ),
      body: SafeArea(
          child: FutureBuilder<TracerVisit>(
        future: _listFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? VisitObservationsList(
                  snapshot.data,
                  () {
                    refreshList();
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}

class VisitObservationsList extends StatefulWidget {
  final Function callback;
  final TracerVisit visit;

  VisitObservationsList(this.visit, this.callback);

  _VisitObservationsListState createState() =>
      _VisitObservationsListState(visit: visit, callback: callback);
}

class _VisitObservationsListState extends State<VisitObservationsList> {
  final Function callback;
  final TracerVisit visit;
  //final TracerService svc = new TracerService();

  _VisitObservationsListState({this.visit, this.callback});

  // pull to refresh
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // pull down
  void _onRefresh() async {
    await callback();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    print('here');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appData.template.observationGroups.length,
      itemBuilder: (context, index) {
        final item = appData.template.observationGroups[index];
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.groupTitle,
                  maxLines: 1,
                  style: TextStyle(fontSize: 12.0, color: kTracersBlue500),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8.0),
                ...item.observationCategories.map((observationCategory) {
                  return ObsCatListTileView(
                      observationCategory: observationCategory,
                      observation: visit.observations[
                          observationCategory.observationCategoryId],
                      visitId: visit.id);
                }).toList(),
                SizedBox(height:20.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

// observation groups
class ObservationGroupView extends StatelessWidget {
  final Function callback;
  final ObservationGroup observationGroup;
  final TracerVisit visit;

  const ObservationGroupView(
      {this.visit, this.observationGroup, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            observationGroup.groupTitle,
            maxLines: 1,
            style: TextStyle(fontSize: 12.0, color: kTracersBlue500),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8.0),
          ...observationGroup.observationCategories.map((observationCategory) {
            return ObsCatListTileView(
                observationCategory: observationCategory,
                observation: visit
                    .observations[observationCategory.observationCategoryId],
                visitId: visit.id);
          }).toList(),
          SizedBox(height: 22.0),
        ],
      ),
    );
  }
}

Widget _observationAssignmentStatus(Observation observation) {
  if (observation != null &&
      observation.sme != null &&
      observation.sme.name != null) {
    List<String> nameParts = observation.sme.name.split(",");
    String initials = nameParts[1].trim().substring(0, 1).toUpperCase() +
        nameParts[0].trim().substring(0, 1).toUpperCase();

    return CircleAvatar(
      backgroundColor: kTracersBlue900,
      child: Text(initials),
    );
  } else {
    return CircleAvatar(
      child: Icon(
        FontAwesomeIcons.solidUserCircle,
        size: 40,
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
        size: 16.0,
      );
    } else if (observation.score == "advisory") {
      return Icon(
        FontAwesomeIcons.exclamationCircle,
        color: kTracersYellow500,
        size: 16.0,
      );
    } else if (observation.score == "nonCompliant") {
      return Icon(
        FontAwesomeIcons.solidTimesCircle,
        color: kTracersRed500,
        size: 16.0,
      );
    } else if (observation.score == "notApplicable") {
      return Icon(
        FontAwesomeIcons.ban,
        color: kTracersGray500,
        size: 16.0,
      );
    } else if (observation.score == "notAssessed") {
      return Icon(
        FontAwesomeIcons.circle,
        color: kTracersGray500,
        size: 16.0,
      );
    } else {
      return Icon(
        FontAwesomeIcons.questionCircle,
        color: kTracersGray300,
        size: 16.0,
      );
    }
  } else {
    return SizedBox(height: 8.0);
  }
}

class ObsCatListTileView extends StatelessWidget {
  final ObservationCategory observationCategory;
  final Observation observation;
  final String visitId;
  final Function callback;

  const ObsCatListTileView(
      {this.observationCategory, this.observation, this.visitId, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: () async {

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ObservationDetailPage(
                          visitId: visitId,
                          observationCategoryId:
                              observationCategory.observationCategoryId,
                        )),
              );

              print('result is $result');

              // why doesn't this work?
              //callback();
            },

            
            leading: SizedBox(
              width: 40,
              height: 42,
              child: Stack(
                children: <Widget>[
                  _observationAssignmentStatus(observation),
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                    alignment: Alignment.bottomCenter,
                    child: _observationExceptionStatus(observation),
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
