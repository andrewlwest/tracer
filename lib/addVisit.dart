import 'package:Tracer/ui/colors.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
//import 'dart:math' as math;

import 'package:Tracer/model/site.dart';
import 'service/tracer_service.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddVisit extends StatefulWidget {
  static const String id = 'add_visit_screen';
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  // used for traversing the context
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _summaryController = TextEditingController();
  final _dateFieldController = TextEditingController();
  final _timeFieldController = TextEditingController();

  // listen for changes in focus
  FocusNode _dateFocusNode = new FocusNode();
  FocusNode _timeFocusNode = new FocusNode();

  // fields to hold form data
  String _date = "Date";
  String _time = "Time";
  String _organization = "The General Hospital Corporation";
  String _selectedSite;
  String _selectedLocation;
  String _visitType;

  List<Site> _sites = List<Site>();
  List<String> _siteSelectList = List<String>();
  List<String> _locationSelectList = List<String>();

  TracerService svc = TracerService();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    // load all sites and locations
    _sites = await svc.getSites(_organization);

    // create a simple list of string sites for use in the select
    _siteSelectList = _sites.map((site) => site.name).toList();

    // old implementation for adding event listeners to fields
    //_dateFocusNode.addListener(_onDateFocusChange);
    //_timeFocusNode..addListener(_onTimeFocusChange);
  }

/*

  // these onchange functions are not used ... if we have to hook up focus events for feids
  // we will have to do something like this

  void _onDateFocusChange() {
    debugPrint("date Focus: " + _dateFocusNode.hasFocus.toString());
    if (_dateFocusNode.hasFocus) {
      DatePicker.showDatePicker(context,
          showTitleActions: true,
          minTime: DateTime(2000, 1, 1),
          maxTime: DateTime(2022, 12, 31), onChanged: (date) {
        print('change $date');
      }, onConfirm: (date) {
        _dateFieldController.text =
            '${date.year} - ${date.month} - ${date.day}';
        //_date = '${date.year} - ${date.month} - ${date.day}';
        setState(() {});
        print('confirm $date');
      }, currentTime: DateTime.now(), locale: LocaleType.en);
    }
  }

  void _onTimeFocusChange() {
    debugPrint("time Focus: " + _timeFocusNode.hasFocus.toString());
    if (_timeFocusNode.hasFocus) {
      DatePicker.showTimePicker(context,
          theme: DatePickerTheme(
            containerHeight: 210.0,
          ),
          showTitleActions: true, onConfirm: (time) {
        print('confirm $time');
        _timeFieldController.text =
            '${time.hour} : ${time.minute} : ${time.second}';
        setState(() {});
      }, currentTime: DateTime.now(), locale: LocaleType.en);
      setState(() {});
    }
  }
  */

  void _save(BuildContext context) {
    print("save pressed");

    final snackBar = SnackBar(
        content: Text('date = ' +
            _date +
            '\ntime = ' +
            _time +
            '\norganization = ' +
            _organization +
            '\nsite = ' +
            (_selectedSite == null ? "null" : _selectedSite) +
            '\nlocation = ' +
            (_selectedLocation == null ? "null" : _selectedLocation) +
            '\nvisit Type = ' +
            (_visitType == null ? "null" : _visitType) +
            '\nsummary = ' +
            (_summaryController.text == null
                ? "null"
                : _summaryController.text)));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
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
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true,
                              minTime: DateTime(2000, 1, 1),
                              maxTime: DateTime(2022, 12, 31),
                              onConfirm: (date) {
                            print('confirm $date');
                            _date = new DateFormat("m/d/yy").format(date);
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
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
                                          Icons.date_range,
                                          size: 18.0,
                                          color: Colors.teal,
                                        ),
                                        Text(
                                          " $_date",
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              /*
                              Text(
                                " ",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              */
                            ],
                          ),
                        ),
                        color: Colors.white,
                      )

                      /*
                      TextFormField(
                        controller: _dateFieldController,
                        focusNode: _dateFocusNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: false,
                          fillColor: kTracersWhite,
                          labelText: 'Date',
                          suffixIcon: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              FontAwesomeIcons.calendar,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    */
                    ],
                  )),
                  SizedBox(width: 12.0),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true, onConfirm: (time) {
                            print('confirm $time');
                            _time = new DateFormat("h:mm a").format(time);
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                          setState(() {});
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
                                          size: 18.0,
                                          color: Colors.teal,
                                        ),
                                        Text(
                                          " $_time",
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              /*
                              Text(
                                " select",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              */
                            ],
                          ),
                        ),
                        color: Colors.white,
                      )

                      /*
                      TextFormField(
                        controller: _timeFieldController,
                        focusNode: _timeFocusNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: kTracersWhite,
                          labelText: 'Time',
                          suffixIcon: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              FontAwesomeIcons.clock,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      */
                    ],
                  ))
                ],
              ),
              SizedBox(height: 12.0),
              DropdownButtonFormField<String>(
                value: _selectedSite,
                onChanged: (String newValue) {
                  setState(() {
                    _selectedSite = newValue;
                  });
                },
                items: _siteSelectList
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
                  labelText: 'Site',
                ),
              ),
              SizedBox(height: 12.0),
              DropdownButtonFormField<String>(
                value: _selectedSite,
                onChanged: (String newValue) {
                  setState(() {
                    _selectedSite = newValue;
                  });
                },
                items: _locationSelectList
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
                  labelText: 'Location',
                ),
              ),
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

              /*
              SizedBox(height: 30.0),
              Text(
                "Participants",
                maxLines: 1,
                style: Theme.of(context).textTheme.subhead,
              ),
              SizedBox(height: 8.0),
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

              // STYLE LIST USING CheckboxListTile
              CheckboxListTile(
                value: true,
                dense: true,
                title: Text('Branch Hines'),
                subtitle: Text('Pharmacy'),
                secondary: CircleAvatar(
                  backgroundColor: Color(
                          (math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                      .withOpacity(1.0),
                  child: Text('BH'),
                ),
                onChanged: (bool value) {},
              ),
              Divider(
                height: 1,
              ),
              CheckboxListTile(
                value: true,
                dense: true,
                title: Text('Soto Edwards'),
                subtitle: Text('Pharmacy'),
                secondary: CircleAvatar(
                  backgroundColor: Color(
                          (math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                      .withOpacity(1.0),
                  child: Text('SE'),
                ),
                onChanged: (bool value) {},
              ),
              Divider(
                height: 1,
              ),
              CheckboxListTile(
                value: true,
                dense: true,
                title: Text('Lindsey Mcgowan'),
                subtitle: Text('Pharmacy'),
                secondary: CircleAvatar(
                  backgroundColor: Color(
                          (math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                      .withOpacity(1.0),
                  child: Text('LM'),
                ),
                onChanged: (bool value) {},
              ),

              */
            ]),
      ),
    );
  }
}
