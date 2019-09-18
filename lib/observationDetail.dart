import 'package:Tracer/application/appData.dart';
import 'package:Tracer/model/observation.dart';
import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/user.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:Tracer/ui/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class ObservationDetailPageArguments {
  final String visitId;
  final String observationCategoryId;
  ObservationDetailPageArguments(this.visitId, this.observationCategoryId);
}

class ObservationDetailPage extends StatefulWidget {
  static const String id = 'observation_detail_page';
  final String observationCategoryId;
  final String visitId;

  ObservationDetailPage({this.visitId, this.observationCategoryId});

  @override
  _ObservationDetailPageState createState() => _ObservationDetailPageState(
      visitId: visitId, observationCategoryId: observationCategoryId);
}

class _ObservationDetailPageState extends State<ObservationDetailPage> {
  final String observationCategoryId;
  final String visitId;
  final TracerService svc = new TracerService();

  _ObservationDetailPageState({this.visitId, this.observationCategoryId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Observation>(
      future: svc.getObservation(visitId, observationCategoryId),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? ObservationDetailView(
                observation: snapshot.data,
                visitId: visitId)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ObservationDetailView extends StatefulWidget {
  final Observation observation;
  final String visitId;

  ObservationDetailView(
      {Key key,
      this.observation,
      this.visitId})
      : super(key: key);

  _ObservationDetailViewState createState() =>
      _ObservationDetailViewState(observation,visitId);
}

class _ObservationDetailViewState extends State<ObservationDetailView> {
  final Observation observation;
  final String visitId;
  
  User _assignedUser;
  final _commentsController = TextEditingController();
  final _freeTextExceptionController = TextEditingController();

  final _commentsFocusNode = new FocusNode();
  final _freeTextFocusNode = new FocusNode();

  TracerService svc = TracerService();

  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();
  AutoCompleteTextField<User> searchTextField;
  TextEditingController controller = new TextEditingController();

  _ObservationDetailViewState(this.observation,this.visitId);

  @override
  void initState() {
    _commentsController.text = observation.comment;
    _commentsFocusNode.addListener(() {
       if (!_commentsFocusNode.hasFocus) {
          _updateComments();
       }
    });

    _freeTextExceptionController.text = observation.freeTextException;
    _freeTextFocusNode.addListener(() {
       if (!_freeTextFocusNode.hasFocus) {
          _updateFreeTextException();
       }
    });

    _assignedUser = observation != null && observation.sme != null && observation.sme.name != null ? observation.sme : null;
    super.initState();
  }

  void _updateComments() async {
    bool success = await svc.setObservationProperty("comment", _commentsController.text, visitId, observation.observationCategoryId);
    if (success) {
      print('saved observation comment');
    } else {
      print('could not save observation comment');
    }
  }

  void _updateFreeTextException() async {
    bool success = await svc.setObservationProperty("freeTextException", _freeTextExceptionController.text, visitId, observation.observationCategoryId);
    if (success) {
      print('saved free text exception');
    } else {
      print('could not save free text exception');
    }
  }


  void smeSelected(User user) async {
    bool success = await svc.setObservationProperty("SME", user.toJson(), visitId, observation.observationCategoryId);
    if (success) {
      setState(() {
        _assignedUser = user;
      });
    } else {
      print('observation detail page: could not set sme');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTracersBlue500,
        title: Text(widget.observation.displayName),
      ),
      body: SafeArea(
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              ScoreButtons(visitId: visitId,observation: observation),
              //_scoreButtons(observation, visitId),

              SizedBox(height: 16.0),

              Text(
                "Subject Matter Expert",
                maxLines: 1,
                style: Theme.of(context).textTheme.subhead,
              ),

              //SUBJECT MATTER EXPERT
              _assignedUser != null ? smeListTitle(_assignedUser) : Padding(
                padding: const EdgeInsets.all(0.0),
                child: FutureBuilder<List<User>>(
                    future: svc.getAllUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);

                      return snapshot.hasData
                          ? AutoCompleteTextField<User>(
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              decoration: new InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      setState(() {
                                        controller.value = null;
                                      });
                                    },
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 30.0, 10.0, 20.0),
                                  filled: true,
                                  hintText: 'Search For User',
                                  hintStyle: TextStyle(color: Colors.grey)),
                              itemSubmitted: (item) {
                                setState(() => smeSelected(item));
                              },
                              clearOnSubmit: true,
                              key: key,
                              suggestions: snapshot.data,
                              itemBuilder: (context, item) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15.0),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item.department,
                                      ),
                                    )
                                  ],
                                );
                              },
                              itemSorter: (a, b) {
                                return a.name.compareTo(b.name);
                              },
                              itemFilter: (item, query) {
                                return item.name.toLowerCase()
                                    .contains(query.toLowerCase());
                              })
                          : Center(child: LinearProgressIndicator());
                    }),
              ),

              SizedBox(height: 12.0),

              //COMMENTS BOX
              TextFormField(
                maxLines: 3,
                focusNode: _commentsFocusNode,
                controller: _commentsController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  filled: true,
                  fillColor: kTracersGray100,
                  labelText: 'Comments (Optional)',
                ),
              ),
              SizedBox(height: 16.0),

              Text(
                "Exceptions",
                maxLines: 1,
                style: Theme.of(context).textTheme.subhead,
              ),
              SizedBox(height: 8.0),

              ...appData.template.observationCategories[observation.observationCategoryId].exceptionIds
                  .map((exceptionId) {
                return ExceptionView(
                  observationException: appData.template.exceptions[exceptionId],
                  isSelected: observation.exceptions[exceptionId] != null,
                  visitId: visitId,
                  /*
                  callback: (exception, isSelected) {
                    updateException(exception, isSelected);
                  },
                  */
                );
              }).toList(),
              
              //free text exception 
              TextFormField(
                maxLines: 3,
                focusNode: _freeTextFocusNode,
                controller: _freeTextExceptionController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  filled: true,
                  fillColor: kTracersGray100,
                  labelText: 'Free Text Exceptions (Optional), enter description here',
                ),
              ),
              SizedBox(height: 16.0),
            ]),
      ),
    );
  }





}

class ExceptionView extends StatefulWidget {
  final ObservationException observationException;
  final bool isSelected;
  final Function callback;
  final String visitId;

  ExceptionView({this.observationException, this.isSelected, this.callback, this.visitId});

  _ExceptionViewState createState() => _ExceptionViewState(observationException,isSelected,callback,visitId);
}

class _ExceptionViewState extends State<ExceptionView> {
  final ObservationException observationException;
  final bool isSelected;
  final Function callback;
  final String visitId;

  TracerService svc = TracerService();
  bool _checkboxValue = false;
  
  _ExceptionViewState(this.observationException, this.isSelected, this.callback, this.visitId);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _checkboxValue = isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // STYLE LIST USING CheckboxListTile
          CheckboxListTile(
            value: _checkboxValue,
            dense: true,
            title: Text(observationException.text),
            onChanged: (bool value) async {

              setState(() {
                _checkboxValue = value;
              });

              bool success = await svc.updateObservationException(visitId, observationException, value);

              if (!success) {
                final snackBar = SnackBar(content: Text('login failed, try again'));
                _scaffoldKey.currentState.showSnackBar(snackBar);

                setState(() {
                  _checkboxValue = !value;
                });
              }
            },
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}

class ExceptionDataSelected {
  ObservationException observationException;
  bool selected;
  ExceptionDataSelected({this.observationException, this.selected});
}

//SUBJECT MATTER EXPERT WIDGET
Widget smeListTitle(User sme) {

  return ListTile(
    dense: true,
    contentPadding: EdgeInsets.all(0),
    leading: SizedBox(
      width: 40,
      height: 42,
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: kTracersBlue900,
            child: Text(sme.initials()) 
          ),
        ],
      ),
    ),
    title: Text(
      sme.name,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
    subtitle: Text(sme.department),
    trailing: Icon(
      //ICON IS GREEN CHECK IF COMPLIANT
      FontAwesomeIcons.ellipsisV,
      size: 16.0,
    ),
  );
}

Future<bool> setObservationScore(Observation observation, String score, String visitId) async {
  TracerService svc = TracerService();
  bool success = await svc.setObservationProperty("score", score, visitId, observation.observationCategoryId);
  return success;
}

//SCORE BUTTONS WIDGET
class ScoreButtons extends StatefulWidget {
  final Observation observation;
  final String visitId;
  
  ScoreButtons({this.visitId, this.observation});
  _ScoreButtonsState createState() => _ScoreButtonsState(observation, visitId);
}

class _ScoreButtonsState extends State<ScoreButtons> {
  final Observation observation;
  final String visitId;
  String _score;

  _ScoreButtonsState(this.observation, this.visitId);

  @override
  void initState() {
    _score = observation.score;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.ban),
            color: (_score == "notApplicable") ? kTracersGray500 : kTracersGray300,
            iconSize: 24,
            onPressed: () async {
              setState(() {
                _score = "notApplicable";
              });
              bool success = await setObservationScore(observation, "notApplicable", visitId);
              print('NOT APPLICABLE'); // notApplicable
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.circle),
            color: (_score == "notAssessed") ? kTracersGray500 : kTracersGray300,
            iconSize: 24,
            onPressed: () async{
              setState(() {
                _score = "notAssessed";
              });              
              bool success = await setObservationScore(observation, "notAssessed", visitId);
              print('DID NOT ASSESS'); // notAssessed
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.solidCheckCircle),
            color: (_score == "compliant") ? kTracersGreen500 : kTracersGray300,
            iconSize: 24,
            onPressed: () async {
              setState(() {
                _score = "compliant";
              });
              bool success = await setObservationScore(observation, "compliant", visitId);
              setState(() {
                _score = "compliant";
              });
              print('COMPLIANT'); // compliant
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.exclamationCircle),
            color: (_score == "advisory") ? kTracersYellow500 : kTracersGray300,
            iconSize: 24,
            onPressed: () async {
              setState(() {
                _score = "advisory";
              });              
              bool success = await setObservationScore(observation, "advisory", visitId);
              print('ADVISORY'); // advisory
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.solidTimesCircle),
            color: (_score == "nonCompliant") ? kTracersRed500 : kTracersGray300,
            iconSize: 24,
            onPressed: () async {
              setState(() {
                _score = "nonCompliant";
              });              
              bool success = await setObservationScore(observation, "nonCompliant", visitId);
              print('NON_COMPLIANT'); // nonCompliant
            },
          ),
        ],
      ),
    );
  }
}
