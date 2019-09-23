import 'package:Tracer/application/router.dart';
import 'package:Tracer/model/place.dart';
import 'package:Tracer/model/tracerVisit.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:Tracer/ui/date_picker.dart' as datePicker;
import 'package:Tracer/ui/time_picker.dart' as timePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreateVisitPage extends StatefulWidget {
  static const String id = 'create_edit_visit_page';
  final TracerVisit visit;
  CreateVisitPage({this.visit});

  @override
  _CreateVisitPageState createState() => _CreateVisitPageState(visit: visit);
}

class _CreateVisitPageState extends State<CreateVisitPage> {
  final TracerVisit visit;

  _CreateVisitPageState({this.visit});
  // used for traversing the context
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _summaryController = TextEditingController();
  String _pageTitle = 'Add Visit';
  // fields to hold form data
  String _date = "Date";
  String _time = "Time";
  String _visitType;
  Place _selectedPlace;

  DateTime _visitDateTime;
  timePicker.TimeOfDay _visitTimeOfDay;
  TracerService svc = TracerService();
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }


  void _init() async {
    if (visit != null) {
      _pageTitle = 'Edit Visit';
      _visitTimeOfDay = new timePicker.TimeOfDay(hour: 12, minute: 0);
      _visitDateTime = visit.visitDatetime;
      _visitType = visit.type;
      _selectedPlace = visit.place;
      _summaryController.text = visit.summary;
      _date = new DateFormat('EEE, MMM d').format(_visitDateTime);
      _time = new DateFormat("h:mm a").format(_visitDateTime);
    } else {
      _pageTitle = 'Add Visit';
      _visitTimeOfDay = null; //new timePicker.TimeOfDay(hour: 12, minute: 0);
      _visitDateTime = null; //DateTime.now();
    }
  }

  void _save(BuildContext context) async {
    print("save pressed");
    var errorMessage = "";

    // validate form and present snack bar with errors
    if (_visitTimeOfDay == null) {
      errorMessage = "Visit Time is required";
    } 
    if (_visitDateTime == null) {
      errorMessage += errorMessage == null ? "" : "\n" + "Visit Date is required";
    } 
    if (_selectedPlace == null) {
      errorMessage +=  errorMessage == null ? "" : "\n" + "Place is required";
    }
    if (_visitType == null) {
      errorMessage +=  errorMessage == null ? "" : "\n" + "Visit type is required";
    }

    if (errorMessage != null && errorMessage.isNotEmpty) {
      final snackBar = SnackBar(content: Text(errorMessage));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {

      DateTime dateTime = new DateTime(
      _visitDateTime.year,
      _visitDateTime.month,
      _visitDateTime.day,
      _visitTimeOfDay.hour,
      _visitTimeOfDay.minute,
      0,
      0,
      0);

      if (visit != null) {
        String visitId = await svc.updateVisit(
            visitId: visit.id,
            dateTime: dateTime,
            place: _selectedPlace,
            summary: _summaryController.text,
            visitType: _visitType);
        print('visit updated with id = ' + visitId);
        Navigator.pop(context, visitId);
      } else {
        var newId = await svc.createVisit(
            dateTime, _selectedPlace, _summaryController.text, _visitType);
        //Navigator.pop(context, visitListItem);
        print('Created a new visit with id = ' + newId);
        Navigator.pop(context, newId);
      }
    }
  }

  void placeSelected(Place place) {
    setState(() {
      _selectedPlace = place;
    });
  }

  List<Place> _searchedPlaces;

  List<Place> filterData(List<Place> places, String pattern) {
    _searchedPlaces = places
        .where((item) => (item.name + item.location)
            .toLowerCase()
            .contains(pattern.toLowerCase()))
        .toList()
          ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return _searchedPlaces;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_pageTitle),
        backgroundColor: kTracersBlue500,
        leading: IconButton(
          tooltip: 'Cancel',
          icon: Icon(
            Icons.close,
            semanticLabel: 'cancel',
          ),
          onPressed: () {
            print('Cancel button');
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            disabledColor: Colors.blueGrey,
            onPressed: () {
              _save(context);
            },
            child: Text("Save"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      OutlineButton(
                        borderSide: BorderSide(
                          color: kTracersGray900, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: .5, //width of the border
                        ),
                        onPressed: () async {
                          DateTime dateTime = await datePicker.showDatePicker(
                            context: context,
                            firstDate: DateTime.now().subtract(Duration(days: 365)),//DateTime(2018, 01, 01),
                            initialDate: _visitDateTime == null ? DateTime.now() : _visitDateTime,
                            lastDate: DateTime.now().add(Duration(days: 365)),//DateTime(2022, 01, 01),
                            initialDatePickerMode:
                                datePicker.DatePickerMode.day,
                          );

                          if (dateTime != null) {
                            //_date = new DateFormat.yMd().format(dateTime);

                            _date =
                                new DateFormat('EEE, MMM d').format(dateTime);
                            _visitDateTime = dateTime;
                            setState(() {});
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                " $_date",
                                style: TextStyle(
                                    color: kTracersGray500, fontSize: 13.0),
                              ),
                              Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: kTracersGray50,
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      )
                    ],
                  )),
                  SizedBox(width: 12.0),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      OutlineButton(
                        borderSide: BorderSide(
                          color: kTracersGray900, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: .5, //width of the border
                        ),
                        onPressed: () async {
                          timePicker.TimeOfDay timeOfDay =
                              await timePicker.showTimePicker(
                            context: context,
                            initialTime: _visitTimeOfDay == null ? new timePicker.TimeOfDay(hour: 12, minute: 0) : _visitTimeOfDay,
                          );

                          if (timeOfDay != null) {
                            _time = timeOfDay.toString();
                            _visitTimeOfDay = timeOfDay;
                            setState(() {});
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                " $_time",
                                style: TextStyle(
                                    color: kTracersGray500, fontSize: 13.0),
                              ),
                              Icon(
                                Icons.access_time,
                                size: 16.0,
                                color: kTracersGray50,
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      )
                    ],
                  ))
                ],
              ),
              SizedBox(height: 12.0),
              _selectedPlace == null
                  ? Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: FutureBuilder<List<Place>>(
                          future: (new TracerService().getPlaces()),
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
                                                    'Search by Name, Location or Address',
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
                                        subtitle: Text(suggestion.location,
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: kTracersGray500)),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      setState(() => placeSelected(suggestion));
                                    },
                                  )
                                : Center(child: LinearProgressIndicator());
                          }),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border(
                            top: BorderSide(width: 1.0, color: kTracersGray400),
                            left:
                                BorderSide(width: 1.0, color: kTracersGray400),
                            right:
                                BorderSide(width: 1.0, color: kTracersGray400),
                            bottom:
                                BorderSide(width: 1.0, color: kTracersGray400),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, right: 8.0, top: 10.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: kTracersGray500,
                                    size: 24.0,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_selectedPlace.name,
                                        maxLines: 2,
                                        style: TextStyle(fontSize: 14.0)),
                                    SizedBox(height: 4.0),
                                    Text(_selectedPlace.location,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: kTracersGray500)),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.close),
                                  color: kTracersGray500,
                                  onPressed: () {
                                    setState(() {
                                      _selectedPlace = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                      
              SizedBox(height: 12.0),

              TextFormField(
                maxLines: 3,
                textInputAction: TextInputAction.done,
                controller: _summaryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: kTracersWhite,
                  labelText: 'Summary',
                ),
              ),
              SizedBox(height: 12.0),
              DropdownButtonFormField<String>(
                value: _visitType,
                onChanged: (String newValue) {
                  setState(() {
                    _visitType = newValue;
                  });
                },
                items: <String>['Comprehensive', 'Followup']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: kTracersWhite,
                  labelText: 'Visit Type',
                ),
              ),
            ]),
      ),
    );
  }
}
