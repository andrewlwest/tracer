
import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/tracerVisit/observation.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';

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

  LogExceptionsView(
      {Key key,
      this.observation,
      this.visitId,
      this.template})
      : super(key: key);

  _LogExceptionsViewState createState() =>
      _LogExceptionsViewState(observation,visitId,template);
}

class _LogExceptionsViewState extends State<LogExceptionsView> {

  final Observation observation;
  final String visitId;
  final Template template;

  final _commentsController = TextEditingController();
  _LogExceptionsViewState(this.observation,this.visitId,this.template);

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTracersBlue500,
        title: Text(widget.observation.displayName),
      ),
      body: SafeArea(
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              scoreButtons,

              SizedBox(height: 16.0),

              Text(
                "Subject Matter Expert",
                maxLines: 1,
                style: Theme.of(context).textTheme.subhead,
              ),

              //SUBJECT MATTER LIST
              sMEListTile,

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
final sMEListTile = new ListTile(
  dense: true,
  contentPadding: EdgeInsets.all(0),
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
      ],
    ),
  ),
  title: Text(
    'Branch Hines',
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  ),
  subtitle: Text('Pharmacy'),
  trailing: Icon(
    //ICON IS GREEN CHECK IF COMPLIANT
    FontAwesomeIcons.ellipsisV,
    size: 16.0,
  ),
);

//SCORE BUTTONS WIDGET
final scoreButtons = new Padding(
  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      IconButton(
        icon: Icon(FontAwesomeIcons.ban),
        color: kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('NOT APPLICABLE');
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.circle),
        color: kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('DID NOT ASSESS');
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.solidCheckCircle),
        color: kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('COMPLIANT');
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.exclamationCircle),
        color: kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('ADVISORY');
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.solidTimesCircle),
        color: kTracersGray300,
        iconSize: 24,
        onPressed: () {
          print('NON_COMPLIANT');
        },
      ),
    ],
  ),
);

