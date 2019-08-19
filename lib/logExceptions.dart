import 'package:Tracer/ui/colors.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';
import 'dart:math' as math;

class LogExceptions extends StatefulWidget {
  @override
  _LogExceptionsState createState() => _LogExceptionsState();
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
      // Ink(
      //   decoration: ShapeDecoration(
      //     color: Colors.lightBlue,
      //     bor
      //     shape: RoundedRectangleBorder(
      //       borderRadius: new BorderRadius.circular(10.0),
      //     ),
      //   ),
      //   child: IconButton(
      //     icon: Icon(FontAwesomeIcons.ban),
      //     color: Colors.white,
      //     onPressed: () {
      //       print("filled background");
      //     },
      //   ),
      // ),
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
  final _commentsController = TextEditingController();

  String dropdownValue = 'MGH';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTracersBlue500,
        title: Text("Meds, Specimens Treatment"),
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

              // STYLE LIST USING CheckboxListTile
              CheckboxListTile(
                value: false,
                dense: true,
                title: Text('No Exceptions Found'),
                onChanged: (bool value) {},
              ),
              Divider(
                height: 1,
              ),
              CheckboxListTile(
                value: false,
                dense: true,
                title: Text('Documentation of PRN pain med decision making   '),
                onChanged: (bool value) {},
              ),
              Divider(
                height: 1,
              ),
              CheckboxListTile(
                value: false,
                dense: true,
                title: Text('Duplicate med orders'),
                onChanged: (bool value) {},
              ),
            ]),
      ),
    );
  }
}
