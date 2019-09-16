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

import 'package:Tracer/appData.dart';
import 'package:Tracer/model/template/template.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:Tracer/addVisit.dart';
import 'package:Tracer/model/visitListItem.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';

import 'service/tracer_service.dart';
import 'visit_detail.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class VisitListPage extends StatefulWidget {
  static const String id = 'visit_list_page_id';
  
  @override
  _VisitListPageState createState() => _VisitListPageState();
}

class _VisitListPageState extends State<VisitListPage> {

  Future<List<VisitListItem>> _visitListFuture;
  final TracerService svc = new TracerService();

  @override
  void initState() {
    super.initState();
    _visitListFuture = svc.getAllVisits();
    _init();
  }

  void _init() async {
    // load data here

    // load app var
    Template template = await svc.getTemplate();
    appData.template = template;

  }

  void refreshVisitList() async {
    print('in refreshVisitList');
    // reload
    setState(() {
      _visitListFuture = svc.getAllVisits();
    });
  }

  @override
  Widget build(BuildContext context) {

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
                    child: Text("TODAY")),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("UPCOMING")),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("PAST")),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("TODO"))
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
                  Navigator.pushNamed(context, AddVisit.id).whenComplete(refreshVisitList);
                  //Navigator.pushNamed(context, AddVisit.id).then(    (value) { refreshVisitList();}       );
                  //refreshVisitList();
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
                future: _visitListFuture,
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
                  accountName: Text(appData.user.name),
                  accountEmail: Text("missing required email"),
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
  //final TracerService svc = new TracerService();

  VisitListView({Key key, this.visits}) : super(key: key);

  // pull to refresh 
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  // pull down
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    
    // need to switch to stateful, or find some way to refresh the future builder
    //visits = await svc.getAllVisits();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
        child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
                body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
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
                                      '${visits[position].place.location}',
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
                                      //'${visits[position].visitDatetime}',
                                      new DateFormat('M/d/yy h:mm aa').format(visits[position].visitDatetime), 
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
                                    '${visits[position].place.name}',
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
                                            final String todo =
                                                await _todoInputDialog(
                                                    context, visits[position]);
                                            print(
                                                "todo is $todo");
                                          },
                                        ),
                                      ],
                                    ),

                                    //participants  ICON
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                              FontAwesomeIcons.solidUserCircle),
                                          color: Colors.black45,
                                          iconSize: 16,
                                          onPressed: () async {
                                            final String participants =
                                                await _participantsInputDialog(
                                                    context, visits[position]);
                                            print(
                                                "participants are $participants");
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
            }
          )
        )
    );
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


Future<String> _participantsInputDialog(BuildContext context, VisitListItem visit) async {
  
  final TracerService svc = new TracerService();
  final _controller = TextEditingController();

  _controller.text = visit.participants;

  return showDialog<String>(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Participants'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextFormField(
              controller: _controller,
              maxLines: 10,
              autofocus: true,
              decoration: new InputDecoration(
                filled: true,
                fillColor: kTracersGray100,
                //labelText: 'Notes',
              ),
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () async {
              bool success = await svc.savePropertyForVisit("participants",_controller.text, visit.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


Future<String> _todoInputDialog(BuildContext context, VisitListItem visit) async {
  
  final TracerService svc = new TracerService();
  final _controller = TextEditingController();

  _controller.text = visit.todo;

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
              controller: _controller,
              maxLines: 10,
              autofocus: true,
              decoration: new InputDecoration(
                filled: true,
                fillColor: kTracersGray100,
                //labelText: 'Notes',
              ),
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () async {
              bool success = await svc.savePropertyForVisit("todo",_controller.text, visit.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
