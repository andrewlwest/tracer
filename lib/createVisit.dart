import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:Tracer/model/place.dart';
import 'package:Tracer/service/tracer_service.dart';

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
          new Column(children: <Widget>[PlaceSearch()]),
        ])));
  }
}

class PlaceSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  GlobalKey<AutoCompleteTextFieldState<Place>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;

  Place selected;
/*
  List<Place> suggestionsAuto = [
    new Place('1', 'Medical Infusion Center', '165 Cambridge St',
        '165 Cambridge Street, 8th floor Suite 820', 'Ambulatory'),
    new Place('2', 'Neuropathy', '165 Cambridge St',
        '165 Cambridge Street, 8th floor Suite 820', 'Ambulatory'),
    new Place('3', 'Sports Medicine', '165 Cambridge St',
        '175 Cambridge Street, 4th floor', 'Ambulatory'),
    new Place('4', 'Sports PT/OT', '165 Cambridge St',
        '175 Cambridge Street, 4th floor', 'Ambulatory'),
    new Place('1', 'Medical Infusion Center', '165 Cambridge St',
        '165 Cambridge Street, 8th floor Suite 820', 'Ambulatory')
  ];
*/
  _PlaceSearchState();

  placeSelected(Place place) {
    setState(() {
      selected = place;
      searchTextField.textField.controller.text = place.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      new Padding(
          child: FutureBuilder<List<Place>>(
            future: (new TracerService().getPlaces()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? Container(
                      child: searchTextField = new AutoCompleteTextField<Place>(
                      decoration: new InputDecoration(
                          hintText: "Search Resturant:",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          )),
                      itemSubmitted: (item) => placeSelected(item),
                      key: key,
                      suggestions: snapshot.data,
                      itemBuilder: (context, item) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              item.name,
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15.0),
                            ),
                            Text(
                              item.location,
                            )
                          ],
                        );
                      },
                      itemSorter: (a, b) => a.name.compareTo(b.name),
                      itemFilter: (suggestion, input) => suggestion.name
                          .toLowerCase()
                          .startsWith(input.toLowerCase()),
                    ))
                  : Center(child: CircularProgressIndicator());
            },
          ),
          padding: EdgeInsets.all(16.0)),
      new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
        child: new Card(
          child: selected != null
              ? new Column(children: [
                  new ListTile(
                      title: new Text(selected.name),
                      trailing: new Text(selected.location))
                ])
              : new Icon(Icons.cancel),
        ),
      ),
    ]);
  }
}
