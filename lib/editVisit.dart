import 'package:Tracer/model/place.dart';
import 'package:Tracer/model/tracerVisit.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:Tracer/ui/date_picker.dart' as datePicker;
import 'package:Tracer/ui/time_picker.dart' as timePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service/tracer_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class EditVisitPage extends StatefulWidget {
  static const String id = 'edit_visit_screen';
  final TracerVisit visit;

  EditVisitPage({this.visit});

  @override
  _EditVisitPageState createState() => _EditVisitPageState(visit: visit);
}

class _EditVisitPageState extends State<EditVisitPage> {
  final TracerVisit visit;

  _EditVisitPageState({this.visit});

  // used for traversing the context
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _summaryController = TextEditingController();

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
    _visitTimeOfDay = new timePicker.TimeOfDay(hour: 12, minute: 0);
    _visitDateTime = visit.visitDatetime;
    _visitType = visit.type;
    _selectedPlace = visit.place;
    _summaryController.text = visit.summary;
    _date = new DateFormat('EEE, MMM d').format(_visitDateTime);
    _time = new DateFormat("h:mm a").format(_visitDateTime);
  }

  void _save(BuildContext context) async {
    print("save pressed");

    DateTime dateTime = new DateTime(
        _visitDateTime.year,
        _visitDateTime.month,
        _visitDateTime.day,
        _visitTimeOfDay.hour,
        _visitTimeOfDay.minute,
        0,
        0,
        0);


    var visitListItem = await svc.updateVisit(visitId:visit.id, dateTime:
        dateTime, place: _selectedPlace, summary:_summaryController.text, visitType:_visitType);
    print('visit updated with id = ' + visitListItem.id);
    //Navigator.pop(context, visitListItem);
    Navigator.pop(context, "updated");
  }

  void placeSelected(Place place) {
    setState(() {
      _selectedPlace = place;
    });
  }

  List<Place> _searchedPlaces;

  List<Place> filterData(List<Place> places, String pattern) {
    _searchedPlaces = places.where(
      (item) => (item.name + item.location)
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase())
    ).toList();
    return _searchedPlaces;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Visit"),
        backgroundColor: kTracersBlue500,
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
                          color: Colors.black, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: .5, //width of the border
                        ),
                        onPressed: () async {
                          DateTime dateTime = await datePicker.showDatePicker(
                            context: context,
                            firstDate: DateTime(2018, 01, 01),
                            initialDate: _visitDateTime,
                            lastDate: DateTime(2022, 01, 01),
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
                        /*
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true,
                              minTime: DateTime(2000, 1, 1),
                              maxTime: DateTime(2022, 12, 31),
                              onConfirm: (date) {
                            print('confirm date: $date');
                            _date = new DateFormat.yMd().format(date);

                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },

                        */
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 18.0,
                                          color: kTracersBlue500,
                                        ),
                                        Text(
                                          " $_date",
                                          style: TextStyle(
                                              color: kTracersBlue500,
                                              fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
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
                          color: Colors.black, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: .5, //width of the border
                        ),
                        onPressed: () async {
                          timePicker.TimeOfDay timeOfDay =
                              await timePicker.showTimePicker(
                            context: context,
                            initialTime: _visitTimeOfDay,
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
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.access_time,
                                          size: 16.0,
                                          color: kTracersBlue500,
                                        ),
                                        Text(
                                          " $_time",
                                          style: TextStyle(
                                              color: kTracersBlue500,
                                              fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
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
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: FutureBuilder<List<Place>>(
                    future: (new TracerService().getPlaces()),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);

                      return snapshot.hasData
                          ? TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  autofocus: true,
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontStyle: FontStyle.italic),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder())),
                              suggestionsCallback: (pattern) async {
                                return filterData(snapshot.data, pattern);
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion.name),
                                  subtitle: Text('${suggestion.location}'),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() => placeSelected(suggestion));
                              
                              },
                            )
                          : Center(child: LinearProgressIndicator());
                    }),
              ),
              SizedBox(height: 12.0),
              Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: _selectedPlace != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _selectedPlace.name,
                              style: theme.textTheme.body1,
                            ),
                            Text(
                              _selectedPlace.location,
                              style: theme.textTheme.body2,
                            ),
                          ],
                        )
                      : Text('')),
              SizedBox(height: 12.0),
              TextFormField(
                maxLines: 3,
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
