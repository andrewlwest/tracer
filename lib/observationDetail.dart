import 'package:Tracer/application/appData.dart';
import 'package:Tracer/model/observation.dart';
import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/user.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:Tracer/ui/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
                observation: snapshot.data, visitId: visitId)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ObservationDetailView extends StatefulWidget {
  final Observation observation;
  final String visitId;

  ObservationDetailView({Key key, this.observation, this.visitId})
      : super(key: key);

  _ObservationDetailViewState createState() =>
      _ObservationDetailViewState(observation, visitId);
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

  _ObservationDetailViewState(this.observation, this.visitId);

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

    _assignedUser = observation != null &&
            observation.sme != null &&
            observation.sme.name != null
        ? observation.sme
        : null;
    super.initState();
  }

  void _updateComments() async {
    bool success = await svc.setObservationProperty("comment",
        _commentsController.text, visitId, observation.observationCategoryId);
    if (success) {
      print('saved observation comment');
    } else {
      print('could not save observation comment');
    }
  }

  void _updateFreeTextException() async {
    bool success = await svc.setObservationProperty(
        "freeTextException",
        _freeTextExceptionController.text,
        visitId,
        observation.observationCategoryId);
    if (success) {
      print('saved free text exception');
    } else {
      print('could not save free text exception');
    }
  }

  void smeSelected(User user) async {
    bool success = await svc.setObservationProperty(
        "SME", user.toJson(), visitId, observation.observationCategoryId);
    if (success) {
      setState(() {
        _assignedUser = user;
      });
    } else {
      print('observation detail page: could not set sme');
    }
  }

  List<User> _searchedUsers;

  List<User> filterData(List<User> users, String pattern) {
    _searchedUsers = users
        .where((item) => (item.name)
            .toLowerCase()
            .contains(pattern.toLowerCase()))
        .toList()
          ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return _searchedUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: kTracersBlue500,
        title: Text(widget.observation.displayName),
      ),
      body: SafeArea(
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              ScoreButtons(visitId: visitId, observation: observation),
              //_scoreButtons(observation, visitId),

              SizedBox(height: 1.0),

              Text(
                "Subject Matter Expert",
                maxLines: 1,
                style: TextStyle(fontSize: 12.0, color: kTracersBlue500),
              ),

              SizedBox(height: 8.0),
              
              //SUBJECT MATTER EXPERT
              _assignedUser != null
                  ? //smeListTitle(_assignedUser)
                  ListTile(
    dense: true,
    contentPadding: EdgeInsets.all(0),
    leading: SizedBox(
      width: 40,
      height: 42,
      child: Stack(
        children: <Widget>[
          CircleAvatar(
              backgroundColor: kTracersBlue900, child: Text(_assignedUser.initials())),
        ],
      ),
    ),
    title: Text(
      _assignedUser.name,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
    subtitle: Text(_assignedUser.department),
    trailing: IconButton(
      icon: Icon(Icons.close),
      color: kTracersGray500,
      onPressed: () {
        setState(() {
          _assignedUser = null;
        });
      },
    ),
  )
                  : Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: 
                      FutureBuilder<List<User>>(
                          future: (new TracerService().getAllUsers()),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? TypeAheadField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            decoration: InputDecoration(
                                                suffixIcon: Icon(Icons.search),
                                                //prefixIcon: Icon(Icons.search),
                                                labelText:
                                                    'Search by User Name',
                                                border: OutlineInputBorder())),
                                    suggestionsCallback: (pattern) async {
                                      return filterData(snapshot.data, pattern);
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(
                                          suggestion.name,
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        subtitle: Text(suggestion.department,
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: kTracersGray500)),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      setState(() => smeSelected(suggestion));
                                    },
                                  )
                                : Center(child: LinearProgressIndicator());
                          })
                      ,
                    ),

              SizedBox(height: 12.0),

              //COMMENTS BOX
              TextFormField(
                minLines: 1,
                maxLines: 3,
                focusNode: _commentsFocusNode,
                controller: _commentsController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: kTracersWhite,
                  labelText: 'Comments (Optional)',
                ),
                style: new TextStyle(
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 16.0),

              Text(
                "Exceptions",
                maxLines: 1,
                style: TextStyle(fontSize: 12.0, color: kTracersBlue500),
              ),
              SizedBox(height: 8.0),

              // extra exxception for the no exceptions found functionality
              ExceptionView(
                observationException: ObservationException("no_exceptions_found", "No Exceptions Found"),
                isSelected: observation.noExceptionsFound,
                visitId: visitId,
                observationCategoryId: observation.observationCategoryId,
              ),

              ...appData
                  .template
                  .observationCategories[observation.observationCategoryId]
                  .exceptionIds
                  .map((exceptionId) {
                return ExceptionView(
                  observationException:
                      appData.template.exceptions[exceptionId],
                  isSelected: observation.exceptions[exceptionId] != null,
                  visitId: visitId,
                  observationCategoryId: observation.observationCategoryId,
                  /*
                  callback: (exception, isSelected) {
                    updateException(exception, isSelected);
                  },
                  */
                );
              }).toList(),
              //free text exception
              Container(
                decoration: new BoxDecoration(
        color: kTracersRed100
      ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10, bottom: 10),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    focusNode: _freeTextFocusNode,
                    controller: _freeTextExceptionController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: false,
                      labelText:
                          'Other Exceptions',
                    ),
                    style: new TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
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
  final String observationCategoryId;
  final String visitId;

  ExceptionView(
      {this.observationException,
      this.isSelected,
      this.callback,
      this.observationCategoryId,
      this.visitId});

  _ExceptionViewState createState() =>
      _ExceptionViewState(observationException, isSelected, callback, observationCategoryId, visitId);
}

class _ExceptionViewState extends State<ExceptionView> {
  final ObservationException observationException;
  final bool isSelected;
  final Function callback;
  final String observationCategoryId;
  final String visitId;

  TracerService svc = TracerService();
  bool _checkboxValue = false;

  _ExceptionViewState(
      this.observationException, this.isSelected, this.callback, this.observationCategoryId, this.visitId);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _checkboxValue = isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: observationException.exceptionId == "no_exceptions_found" ? kTracersGreen100 : kTracersRed100
      ),
      child: Column(
        children: <Widget>[
          // STYLE LIST USING CheckboxListTile
          CheckboxListTile(

            activeColor: observationException.exceptionId == "no_exceptions_found" ? kTracersGreen500 : kTracersRed500,
            value: _checkboxValue,
            dense: true,
            title: Text(observationException.text),
            onChanged: (bool value) async {
              setState(() {
                _checkboxValue = value;
              });

              // handle no exceptions found item
              if (observationException.exceptionId == "no_exceptions_found") {
                bool success = await svc.setObservationProperty("noExceptionsFound", value, visitId, observationCategoryId);
                
                if (!success) {
                  final snackBar =
                      SnackBar(content: Text('Could not save no exceptions found'));
                  _scaffoldKey.currentState.showSnackBar(snackBar);

                  setState(() {
                    _checkboxValue = !value;
                  });
                }

              } else {
                bool success = await svc.updateObservationException(
                  visitId, observationException, value);

                if (!success) {
                  final snackBar =
                      SnackBar(content: Text('could not save exception'));
                  _scaffoldKey.currentState.showSnackBar(snackBar);

                  setState(() {
                    _checkboxValue = !value;
                  });
                }
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


Future<bool> setObservationScore(
    Observation observation, String score, String visitId) async {
  TracerService svc = TracerService();
  bool success = await svc.setObservationProperty(
      "score", score, visitId, observation.observationCategoryId);
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
            tooltip: 'Not Applicable',
            icon: Icon(FontAwesomeIcons.ban),
            color:
                (_score == "notApplicable") ? kTracersBlue900 : kTracersGray300,
            iconSize: 24,
            onPressed: () async {
              setState(() {
                _score = "notApplicable";
              });
              bool success = await setObservationScore(
                  observation, "notApplicable", visitId);
              print('NOT APPLICABLE'); // notApplicable
            },
          ),
          IconButton(
            tooltip: 'Not Assessed',
            icon: Icon(FontAwesomeIcons.circle),
            color:
                (_score == "notAssessed") ? kTracersBlue900 : kTracersGray300,
            iconSize: 24,
            onPressed: () async {
              setState(() {
                _score = "notAssessed";
              });
              bool success = await setObservationScore(
                  observation, "notAssessed", visitId);
              print('DID NOT ASSESS'); // notAssessed
            },
          ),
          IconButton(
            tooltip: 'Compliant',
            icon: Icon(FontAwesomeIcons.solidCheckCircle),
            color: (_score == "compliant") ? kTracersGreen500 : kTracersGray300,
            iconSize: 24,
            onPressed: () async {
              setState(() {
                _score = "compliant";
              });
              bool success =
                  await setObservationScore(observation, "compliant", visitId);
              setState(() {
                _score = "compliant";
              });
              print('COMPLIANT'); // compliant
            },
          ),
          IconButton(
            tooltip: 'Advisory',
            icon: Icon(FontAwesomeIcons.exclamationCircle),
            color: (_score == "advisory") ? kTracersYellow500 : kTracersGray300,
            iconSize: 24,
            onPressed: () async {
              setState(() {
                _score = "advisory";
              });
              bool success =
                  await setObservationScore(observation, "advisory", visitId);
              print('ADVISORY'); // advisory
            },
          ),
          IconButton(
            tooltip: 'Non Compliant',
            icon: Icon(FontAwesomeIcons.solidTimesCircle),
            color:
                (_score == "nonCompliant") ? kTracersRed500 : kTracersGray300,
            iconSize: 24,
            onPressed: () async {
              setState(() {
                _score = "nonCompliant";
              });
              bool success = await setObservationScore(
                  observation, "nonCompliant", visitId);
              print('NON_COMPLIANT'); // nonCompliant
            },
          ),
        ],
      ),
    );
  }
}
