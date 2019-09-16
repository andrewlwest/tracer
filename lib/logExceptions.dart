import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/tracerVisit/observation.dart';
import 'package:Tracer/model/user.dart';
import 'package:Tracer/model/userListItem.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class LogExceptions extends StatefulWidget {

  final String observationCategoryId;
  final Template template;
  final String visitId;

  LogExceptions({this.visitId, this.observationCategoryId, this.template});

  @override
  _LogExceptionsState createState() => _LogExceptionsState(
      visitId: visitId, template: template, observationCategoryId: observationCategoryId);
}


class _LogExceptionsState extends State<LogExceptions> {
  final String observationCategoryId;
  final Template template;
  final String visitId;

  String dropdownValue = 'MGH';
  final TracerService svc = new TracerService();

  _LogExceptionsState({this.visitId, this.observationCategoryId, this.template});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Observation>(
      future: svc.getObservation(visitId, observationCategoryId),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? LogExceptionsView(
                observation: snapshot.data,
                visitId: visitId,
                template: template)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class LogExceptionsView extends StatefulWidget {
  final Observation observation;
  final String visitId;
  final Template template;

  UserListItem selectedUserListItem;

  LogExceptionsView(
      {Key key,
      this.observation,
      this.visitId,
      this.template,
      this.selectedUserListItem})
      : super(key: key);

  _LogExceptionsViewState createState() =>
      _LogExceptionsViewState(observation,visitId,template,selectedUserListItem);
}

class _LogExceptionsViewState extends State<LogExceptionsView> {

  final Observation observation;
  final String visitId;
  final Template template;
  UserListItem selectedUserListItem;

  bool assigned;

  final _commentsController = TextEditingController();

  TracerService svc = TracerService();

  GlobalKey<AutoCompleteTextFieldState<UserListItem>> key = new GlobalKey();
  AutoCompleteTextField<UserListItem> searchTextField;
  TextEditingController controller = new TextEditingController();

  _LogExceptionsViewState(this.observation,this.visitId,this.template,this.selectedUserListItem);

  @override
  void initState() {
    assigned = (observation != null && observation.sme != null && observation.sme.name != null);
    super.initState();
  }

  void smeSelected(UserListItem user) async {
    bool success = await svc.setObservationProperty("SME", user.toJson(), visitId, observation.observationCategoryId);
    setState(() {
      selectedUserListItem = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ObservationException> selectedExceptions;

    void addSelectedException(ExceptionDataSelected data) {
      if (selectedExceptions != null) {
        int index = selectedExceptions.indexOf(data.observationException);
        if (index == -1) {
          if (data.selected) {
            selectedExceptions.add(data.observationException);
          }
        } else {
          if (!data.selected) {
            selectedExceptions.removeAt(index);
          }
        }
      } else {
        if (data.selected) {
          selectedExceptions = [data.observationException];
        }
      }
      print('How many exceptions selected: ' +
          (selectedExceptions.length).toString());
    }

    UserListItem assignedUser = null;
    if (selectedUserListItem != null) {
      assignedUser = selectedUserListItem;
    } else if (observation != null && observation.sme != null && observation.sme.name != null) {
      assignedUser = UserListItem(department: observation.sme.department, name: observation.sme.name, username: observation.sme.username);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTracersBlue500,
        title: Text(widget.observation.displayName),
      ),
      body: SafeArea(
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              _scoreButtons(observation),

              SizedBox(height: 16.0),

              Text(
                "Subject Matter Expert",
                maxLines: 1,
                style: Theme.of(context).textTheme.subhead,
              ),

              //SUBJECT MATTER EXPERT
              assignedUser != null ? _SmeListTitle(assignedUser) : Padding(
                padding: const EdgeInsets.all(0.0),
                child: FutureBuilder<List<UserListItem>>(
                    future: svc.getAllUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);

                      return snapshot.hasData
                          ? AutoCompleteTextField<UserListItem>(
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
                controller: _commentsController,
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

              //EXCEPTIONS SEARCH BOX
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Search",
                    //hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              ...template.observationCategories[observation.observationCategoryId].exceptionIds
                  .map((exceptionId) {
                return ExceptionView(
                  observationException: template.exceptions[exceptionId],
                  callback: (data) {
                    addSelectedException(data);
                  },
                );
              }).toList(),
            ]),
      ),
    );
  }
}

class ExceptionView extends StatefulWidget {
  final ObservationException observationException;
  final Function callback;

  ExceptionView({this.observationException, this.callback});

  _ExceptionViewState createState() => _ExceptionViewState();
}

class _ExceptionViewState extends State<ExceptionView> {
  bool _checkbox_value = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // STYLE LIST USING CheckboxListTile
          CheckboxListTile(
            value: _checkbox_value,
            dense: true,
            title: Text(widget.observationException.text),
            onChanged: (bool value) {
              setState(() {
                _checkbox_value = value;
                var data = ExceptionDataSelected(
                    observationException: widget.observationException,
                    selected: value);
                widget.callback(data);
              });
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
Widget _SmeListTitle(UserListItem sme) {

  List<String> nameParts = sme.name.split(",");
  String initials = nameParts[1].trim().substring(0,1).toUpperCase() + nameParts[0].trim().substring(0,1).toUpperCase();

  return ListTile(
    dense: true,
    contentPadding: EdgeInsets.all(0),
    leading: SizedBox(
      width: 40,
      height: 42,
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: kTracersGray300,
            child: Text(initials) 
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


//SCORE BUTTONS WIDGET
_scoreButtons(Observation observation) {

  String score = observation.score;

  return Padding(
  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      IconButton(
        icon: Icon(FontAwesomeIcons.ban),
        color: (score == "notApplicable") ? kTracersGray100 : kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('NOT APPLICABLE'); // notApplicable
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.circle),
        color: (score == "notAssessed") ? kTracersGray100 : kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('DID NOT ASSESS'); // notAssessed
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.solidCheckCircle),
        color: (score == "compliant") ? kTracersGreen500 : kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('COMPLIANT'); // compliant
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.exclamationCircle),
        color: (score == "advisory") ? kTracersYellow500 : kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('ADVISORY'); // advisory
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.solidTimesCircle),
        color: (score == "nonCompliant") ? kTracersRed500 : kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('NON_COMPLIANT'); // nonCompliant
        },
      ),
    ],
  ),
);
}
