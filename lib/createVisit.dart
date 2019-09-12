import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:Tracer/model/place.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/model/autoPlace.dart';

class CreateVisit extends StatefulWidget {
  static const String id = 'create_visit_screen';
  @override
  _CreateVisitState createState() => new _CreateVisitState();
}

class _CreateVisitState extends State<CreateVisit> {
  _CreateVisitState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Auto Complete List Demo'),
        ),
        body: new Center(
            child: new Column(children: <Widget>[
          new Column(children: <Widget>[AutoPlaceSearch()]),
        ])));
  }
}

class AutoPlaceSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AutoPlaceSearchState();
}

class _AutoPlaceSearchState extends State<AutoPlaceSearch> {
  //static List<Place> suggestions = new List<Place>();
  //static List<AutoPlace> suggestionsAuto = new List<AutoPlace>();

  bool loading = false;

  void _loadData() async {
    //suggestions = (await TracerService().getPlaces()).toList();

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // _loadData();
    super.initState();
  }

  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<AutoPlace>>();

  AutoCompleteTextField<AutoPlace> textField;

  AutoPlace selected;

  List<AutoPlace> suggestionsAuto = [
    new AutoPlace('1', 'Medical Infusion Center', '165 Cambridge St',
        '165 Cambridge Street, 8th floor Suite 820', 'Ambulatory'),
    new AutoPlace('2', 'Neuropathy', '165 Cambridge St',
        '165 Cambridge Street, 8th floor Suite 820', 'Ambulatory'),
    new AutoPlace('3', 'Sports Medicine', '165 Cambridge St',
        '175 Cambridge Street, 4th floor', 'Ambulatory'),
    new AutoPlace('4', 'Sports PT/OT', '165 Cambridge St',
        '175 Cambridge Street, 4th floor', 'Ambulatory'),
    new AutoPlace('1', 'Medical Infusion Center', '165 Cambridge St',
        '165 Cambridge Street, 8th floor Suite 820', 'Ambulatory')
  ];

  _AutoPlaceSearchState() {
    textField = new AutoCompleteTextField<AutoPlace>(
      decoration: new InputDecoration(
          hintText: "Search Resturant:", suffixIcon: new Icon(Icons.search)),
      itemSubmitted: (item) => setState(() => selected = item),
      key: key,
      suggestions: suggestionsAuto,
      itemBuilder: (context, suggestion) => new Padding(
          child: new ListTile(
              title: new Text(suggestion.name),
              trailing: new Text("Stars: {suggestion.location}")),
          padding: EdgeInsets.all(8.0)),
      itemSorter: (a, b) => a.name.compareTo(b.name),
      itemFilter: (suggestion, input) =>
          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      new Padding(
          child: new Container(child: textField),
          padding: EdgeInsets.all(16.0)),
      new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
        child: new Card(
          child: selected != null
              ? new Column(children: [
                  new ListTile(
                      title: new Text(selected.name),
                      trailing: new Text("Rating: ${selected.name}"))
                ])
              : new Icon(Icons.cancel),
        ),
      ),
    ]);
  }
}
