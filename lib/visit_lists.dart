// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:Tracer/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';

class VisitListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final vCardOverline = new Expanded(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'visit.site' + ' - ' + 'visit.location',
            maxLines: 1,
            style: theme.textTheme.caption,
          ),
        ],
      ),
    );
    //CARD OVERLINE WITH DATE/TIME
    final vCardDate = new Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: Text(
            'Today',
            maxLines: 1,
            style: theme.textTheme.caption,
          ),
        )
      ],
    );

    //CARD HEADING
    final vCardHeading = new Column(
      children: <Widget>[
        Text(
          'visit.name',
          style: theme.textTheme.headline,
          maxLines: 1,
        ),
      ],
    );

    //CARD SUMMARY
    final vCardSummary = new Flexible(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Quisque viverra nunc eget dui. Etiam iaculis tincidunt sapien. Aliquam erat volutpat. Mauris sagittis mi suscipit est. Maecenas adipiscing erat vestibulum purus. In scelerisque facilisis risus. In ac erat. Etiam nulla. Donec ut arcu sit amet nisi sollicitudin gravida.',
            style: theme.textTheme.body2,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );

    //CARD PROGRESS BAR
    final vCardProgress = new Expanded(
      child: new SizedBox(
        height: 4,
        child: new LinearProgressIndicator(
          valueColor: new AlwaysStoppedAnimation(kTracersBlue500),
          backgroundColor: kTracersBlue100,
          value: .03,
        ),
      ),
    );

    //CARD ACTIONS
    final vCardActions = new Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        //TO DO ICON
        Column(
          children: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.solidClipboard),
              color: Colors.black45,
              iconSize: 16,
              onPressed: () async {
                final String currentTeam = await _asyncInputDialog(context);
                print("Current team name is $currentTeam");
              },
            ),
          ],
        ),
        //ASSIGN USERS ICON
        Column(
          children: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.solidUserCircle),
              color: Colors.black45,
              iconSize: 16,
              onPressed: () {
                print('To Do Button');
              },
            ),
          ],
        ),
        //MORE ACTIONS ICON
        Column(
          children: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.ellipsisV),
              color: Colors.black45,
              iconSize: 16,
              onPressed: () {
                print('Card Actions');
              },
            ),
          ],
        ),
      ],
    ));

    //SCORE ACTIONS
    final vCardScore = new Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //COMPLIANT SCORE
          Column(
            children: <Widget>[
              ButtonTheme(
                minWidth: 16.0,
                child: FlatButton(
                  padding: const EdgeInsets.all(1),
                  onPressed: () => print("COMPLIANT Score Button Pressed"),
                  child: new Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Icon(
                          FontAwesomeIcons.solidCheckCircle,
                          size: 16.0,
                          color: kTracersGreen500,
                        ),
                      ),
                      Text(
                        '100%',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: kTracersGreen500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              //ADVISORY SCORE
              ButtonTheme(
                minWidth: 16.0,
                child: FlatButton(
                  padding: const EdgeInsets.all(1),
                  onPressed: () => print("ADVISORY Score Button Pressed"),
                  child: new Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Icon(
                          FontAwesomeIcons.exclamationCircle,
                          size: 16.0,
                          color: kTracersYellow500,
                        ),
                      ),
                      Text(
                        '40%',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: kTracersYellow500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              //NON-COMPLIANT SCORE
              ButtonTheme(
                minWidth: 16.0,
                child: FlatButton(
                  padding: const EdgeInsets.all(1),
                  onPressed: () => print("NON-COMPLIANT Score Button Pressed"),
                  child: new Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Icon(
                          FontAwesomeIcons.solidTimesCircle,
                          size: 16.0,
                          color: kTracersRed500,
                        ),
                      ),
                      Text(
                        '40%',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: kTracersRed500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      //ADVISORY ICON AND SCORE
    );

    //TODAY CARD
    final vCardToday = new SizedBox(
      height: 174,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 12.0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  vCardOverline,
                  vCardDate,
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  vCardHeading,
                ],
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: Row(
                  children: <Widget>[
                    vCardSummary,
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //TODAY and UPCOMING CARDS WILL HAVE THE PROGRESS BAR SHOWN INSTEAD OF THE SCORE BAR
                    vCardProgress,
                    //PAST CARDS WILL HAVE THE SCORE BAR SHOWN INSTEAD OF THE PROGRESS BAR
                    //vCardScore,
                    vCardActions,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: kTracersBlue500,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                semanticLabel: 'menu',
              ),
              onPressed: () {
                print('Menu button');
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("Today")),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("Upcoming")),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("Past")),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("Admin"))
              ],
            ),
            title: Text('Tracer'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  semanticLabel: 'add',
                ),
                onPressed: () {
                  print('Add button');
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  semanticLabel: 'search',
                ),
                onPressed: () {
                  print('Search button');
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  semanticLabel: 'more',
                ),
                onPressed: () {
                  print('More button');
                },
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              //TODAY TAB PANE CONTENT
              ListView(
                children: <Widget>[
                  vCardToday,
                  vCardToday,
                  vCardToday,
                  vCardToday,
                  vCardToday,
                ],
              ),

              //UPCOMING TAB PANE CONTENT
              Text('Upcoming'),

              //PAST TAB PANE CONTENT
              Text('Past'),

              //ADMIN TAB PANE CONTENT
              Text('Admin')
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text("Branch Himes"),
                  accountEmail: Text("bh@mgh.harvard.edu"),
                  decoration: BoxDecoration(
                    color: kTracersBlue500,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: kTracersBlue900,
                    child: Text(
                      "BH",
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Today"),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text("Profile"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> _asyncInputDialog(BuildContext context) async {
  String toDo = '';
  return showDialog<String>(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('To Do'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextFormField(
              maxLines: 10,
              autofocus: true,
              decoration: new InputDecoration(
                filled: true,
                fillColor: kTracersGray100,
                labelText: 'Notes',
              ),
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(toDo);
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(toDo);
            },
          ),
        ],
      );
    },
  );
}
