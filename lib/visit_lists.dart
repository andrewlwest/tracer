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

import 'package:Tracer/addVisit.dart';
import 'package:Tracer/autoComplete.dart';
import 'package:Tracer/createVisit.dart';
import 'package:Tracer/model/visitListItem.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';

import 'service/tracer_service.dart';
import 'visit_detail.dart';

class VisitListPage extends StatelessWidget {
  static const String id = 'visit_list_page_id';
  @override
  Widget build(BuildContext context) {
    final TracerService svc = new TracerService();

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
                  //Navigator.pushNamed(context, CreateVisit.id);
                  //Navigator.pushNamed(context, AutoComplete.id);
                  Navigator.pushNamed(context, CreateVisit.id);
                },
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.search,
              //     semanticLabel: 'search',
              //   ),
              //   onPressed: () {
              //     print('Search button');
              //   },
              // ),
              // IconButton(
              //   icon: Icon(
              //     Icons.more_vert,
              //     semanticLabel: 'more',
              //   ),
              //   onPressed: () {
              //     print('More button');
              //   },
              // ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              //TODAY TAB PANE CONTENT

              FutureBuilder<List<VisitListItem>>(
                future: svc.getAllVisits(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? VisitListView(visits: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              ),

              //UPCOMING TAB PANE CONTENT
              Text('Upcoming'),

              //PAST TAB PANE CONTENT
              Text('Past'),

              //ADMIN TAB PANE CONTENT
              Text('Admin'),
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
                ListTile(
                  title: Text("Sign Out"),
                  trailing: Icon(Icons.exit_to_app),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VisitListView extends StatelessWidget {
  final List<VisitListItem> visits;

  VisitListView({Key key, this.visits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
        child: ListView.builder(
            itemCount: visits.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, position) {
              return new InkWell(
                onTap: () => _onTapItem(
                    context, visits[position]), // handle your onTap here
                child: SizedBox(
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
                              new Expanded(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${visits[position].site}',
                                      maxLines: 1,
                                      style: theme.textTheme.caption,
                                    ),
                                  ],
                                ),
                              ),
                              new Column(
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
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  Text(
                                    '${visits[position].location}',
                                    style: theme.textTheme.headline,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                            child: Row(
                              children: <Widget>[
                                new Flexible(
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 45,
                                        child: Text(
                                          '${visits[position].summary}',
                                          style: theme.textTheme.body2,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                //TODAY and UPCOMING CARDS WILL HAVE THE PROGRESS BAR SHOWN INSTEAD OF THE SCORE BAR
                                // new Expanded(
                                //   child: new SizedBox(
                                //     height: 4,
                                //     child: new LinearProgressIndicator(
                                //       valueColor: new AlwaysStoppedAnimation(
                                //           kTracersBlue500),
                                //       backgroundColor: kTracersBlue100,
                                //       value: .03,
                                //     ),
                                //   ),
                                // ),
                                //PAST CARDS WILL HAVE THE SCORE BAR SHOWN INSTEAD OF THE PROGRESS BAR
                                //vCardScore,
                                new Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    //TO DO ICON
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                              FontAwesomeIcons.solidClipboard),
                                          color: Colors.black45,
                                          iconSize: 16,
                                          onPressed: () async {
                                            final String currentTeam =
                                                await _asyncInputDialog(
                                                    context);
                                            print(
                                                "Current team name is $currentTeam");
                                          },
                                        ),
                                      ],
                                    ),
                                    //ASSIGN USERS ICON
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                              FontAwesomeIcons.solidUserCircle),
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
                                          icon:
                                              Icon(FontAwesomeIcons.ellipsisV),
                                          color: Colors.black45,
                                          iconSize: 16,
                                          onPressed: () {
                                            print('Card Actions');
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}

void _onTapItem(BuildContext context, VisitListItem visit) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => VisitDetailPage(visitId: visit.id)),
  );

/*
  Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(visit.id.toString() + ' - ' + visit.location)));
*/
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
