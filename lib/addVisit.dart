import 'package:Tracer/model/place.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:Tracer/ui/date_picker.dart' as datePicker;
import 'package:Tracer/ui/time_picker.dart' as timePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service/tracer_service.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AddVisit extends StatefulWidget {
  static const String id = 'add_visit_screen';
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
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

  GlobalKey<AutoCompleteTextFieldState<Place>> key = new GlobalKey();
  AutoCompleteTextField<Place> searchTextField;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    
    _visitTimeOfDay = new timePicker.TimeOfDay(hour: 12, minute: 0);
    _visitDateTime = DateTime.now();
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

    var visitListItem = await svc.createVisit(
        dateTime, _selectedPlace, _summaryController.text, _visitType);

    print('visit created with id = ' + visitListItem.id);

    Navigator.pop(context, "saved");
  }

  String convertDateTime(String date, String time) {
    var dateArray = date.split('/');
    String year = dateArray[2];
    String month = dateArray[1];
    String day = dateArray[0];
    if (day.length == 1) day = '0' + day;
    if (month.length == 1) month = '0' + month;

    var timeArray = time.split(new RegExp(':| '));
    String hour = timeArray[0];
    String minute = timeArray[1];
    String ampm = timeArray[2];

    if (ampm == 'PM') hour = (int.parse(hour) + 12).toString();
    return year + '-' + month + '-' + day + 'T' + hour + ':' + minute + ':00';
  }

  void placeSelected(Place place) {
    setState(() {
      _selectedPlace = place;
    });
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
                        /*
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true, onConfirm: (time) {
                            print('confirm time $time');
                            _time = new DateFormat("h:mm a").format(time);
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                          setState(() {});
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
                          ? AutoCompleteTextField<Place>(
                              suggestionsAmount: 20,
                              decoration: new InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: kTracersWhite,
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
                                  hintText: 'Search Place',
                                  hintStyle: TextStyle(color: Colors.grey)),
                              itemSubmitted: (item) {
                                setState(() => placeSelected(item));
                              },
                              clearOnSubmit: true,
                              key: key,
                              suggestions: snapshot.data,
                              itemBuilder: (context, item) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 8, left: 8, right: 8),
                                      child: Text(
                                        item.name,
                                        style: theme.textTheme.body1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.0, right: 8.0, bottom: 8),
                                      child: Text(
                                        item.location,
                                        style: theme.textTheme.body2,
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ],
                                );
                              },
                              itemSorter: (a, b) {
                                return a.name.compareTo(b.name);
                              },
                              itemFilter: (item, query) {
                                return (item.name + item.location)
                                    .toLowerCase()
                                    .contains(query.toLowerCase());
                              })
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
