import 'package:Tracer/colors.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';
import 'dart:math' as math;

class AddVisit extends StatefulWidget {
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final _summaryController = TextEditingController();

  String dropdownValue = 'MGH';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Visit"),
        backgroundColor: kTracersBlue500,
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
                      TextFormField(
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
                    ],
                  )),
                  SizedBox(width: 12.0),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      TextFormField(
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
                    ],
                  ))
                ],
              ),
              SizedBox(height: 12.0),
              DropdownButtonFormField<String>(
                //value: 'Select Site',
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['MGH', 'BWH', 'Spaulding']
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
                //value: 'Select Site',
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['Ellison 5', 'Blake 4', 'IMA Pod 2']
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
                //value: 'Select Site',
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
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
                  backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
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
                  backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
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
                  backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
                  child: Text('LM'),
                ),
                onChanged: (bool value) {},
              ),
            ]),
      ),
    );
  }
}
