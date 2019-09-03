import 'package:Tracer/model/observationTemplates/observationException.dart';
import 'package:Tracer/model/observationTemplates/observationTemplates.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';

class LogExceptions extends StatefulWidget {
  final String observationId;
  final String observationName;
  LogExceptions({this.observationId, this.observationName});
  @override
  _LogExceptionsState createState() => _LogExceptionsState(
      observationId: observationId, observationName: observationName);
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

class _LogExceptionsState extends State<LogExceptions> {
  final String observationId;
  final String observationName;
  String dropdownValue = 'MGH';
  final TracerService svc = new TracerService();

  _LogExceptionsState({this.observationId, this.observationName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ObservationTemplates>(
      future: svc.getObservationTemplates(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? LogExceptionsView(
                observationTemplates: snapshot.data,
                observationId: observationId,
                observationName: observationName)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class LogExceptionsView extends StatefulWidget {
  final ObservationTemplates observationTemplates;
  final String observationId;
  final String observationName;

  LogExceptionsView(
      {Key key,
      this.observationTemplates,
      this.observationId,
      this.observationName})
      : super(key: key);

  _LogExceptionsViewState createState() =>
      _LogExceptionsViewState(observationTemplates);
}

class _LogExceptionsViewState extends State<LogExceptionsView> {
  final ObservationTemplates observationTemplates;
  final _commentsController = TextEditingController();
  _LogExceptionsViewState(this.observationTemplates);

  @override
  Widget build(BuildContext context) {
    List<ObservationException> selectedExceptions;

    void addSelectedException(ObservationException observationException) {
      if (selectedExceptions != null) {
        int index = selectedExceptions.indexOf(observationException);
        if (index == -1) {
          selectedExceptions.add(observationException);
        }
      } else {
        selectedExceptions = [observationException];
      }
      print('How many exceptions selected: ' +
          (selectedExceptions.length).toString());
    }

    ;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTracersBlue500,
        title: Text(widget.observationName),
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
              ...observationTemplates
                  .observationDefinitions[widget.observationId].exceptionList
                  .map((observationException) {
                return ExceptionView(
                  observationException: observationException,
                  callback: (value) {
                    addSelectedException(value);
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
                if (value) {
                  widget.callback(widget.observationException);
                }
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
