import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:Tracer/model/place.dart';
import 'package:Tracer/service/placesService.dart';
import 'package:Tracer/service/tracer_service.dart';


class CreateVisit extends StatefulWidget {
  static const String id = 'create_visit_screen';
  @override
  _CreateVisitState createState() => new _CreateVisitState();
}

class _CreateVisitState extends State<CreateVisit> {
  GlobalKey<AutoCompleteTextFieldState<Place>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  _CreateVisitState();

  List<Place> _places;

  void _loadData() async {

    //await PlacesModel.loadPlaces();
    _places = await TracerService().getPlaces();

  }

  @override
  void initState() {
    super.initState();
    _loadData();
    

    if (mounted) {
      setState(() {
        // refresh
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Auto Complete List Demo'),
        ),
        body: new Center(
            child: new Column(children: <Widget>[
          new Column(children: <Widget>[
            searchTextField = AutoCompleteTextField<Place>(
                style: new TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: new InputDecoration(
                    suffixIcon: Container(
                      width: 85.0,
                      height: 60.0,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                    filled: true,
                    hintText: 'Search For Place',
                    hintStyle: TextStyle(color: Colors.black)),
                itemSubmitted: (item) {
                  setState(() => searchTextField.textField.controller.text =
                      item.name);
                },
                clearOnSubmit: false,
                key: key,
                suggestions: _places,
                itemBuilder: (context, item) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(item.name,
                      style: TextStyle(
                        fontSize: 16.0
                      ),),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                      ),
                      Text(item.location,
                      )
                    ],
                  );
                },
                itemSorter: (a, b) {
                  return a.name.compareTo(b.name);
                },
                itemFilter: (item, query) {
                  return item.name
                      .toLowerCase()
                      .startsWith(query.toLowerCase());
                }),
          ]),
        ])));
  }
}