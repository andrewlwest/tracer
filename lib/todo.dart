import 'package:Tracer/colors.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';
import 'dart:math' as math;

class LogToDo extends StatefulWidget {
  @override
  _LogToDoState createState() => _LogToDoState();
}





class _LogToDoState extends State<LogToDo> {
  final _commentsController = TextEditingController();

  String dropdownValue = 'MGH';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTracersBlue500,
        title: Text("Visit-Name To Do"),
      ),
      body: SafeArea(
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
             

              SizedBox(height: 16.0),

              //COMMENTS BOX
              TextFormField(
                maxLines: 10,
                controller: _commentsController,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  filled: true,
                  fillColor: kTracersGray100,
                  labelText: 'Notes',
                ),
              ),
              SizedBox(height: 16.0),

             
            ]),
      ),
    );
  }
}