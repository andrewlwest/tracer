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
import 'package:Tracer/editVisit.dart';
import 'package:Tracer/model/visitListItem.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'font_awesome_flutter.dart';
import 'service/tracer_service.dart';
import 'visit_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyTab {
  const MyTab({this.title, this.filter});

  final String title;
  final String filter;
}

const List<MyTab> myTabs = const <MyTab>[
  const MyTab(title: 'TODAY', filter: 'today'),
  const MyTab(title: 'UPCOMING', filter: 'future'),
  const MyTab(title: 'PAST', filter: 'past'),
  const MyTab(title: 'TODO', filter: 'hastodo'),
  const MyTab(title: 'ALL', filter: 'all'),
];

class VisitListPage extends StatefulWidget {
  static const String id = 'visit_list_page_id';

  @override
  _VisitListPageState createState() => _VisitListPageState();
}

class _VisitListPageState extends State<VisitListPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Future<List<VisitListItem>> _visitListFuture;
  final TracerService svc = new TracerService();
  final String pageTitle = 'Tracer';
  var previousIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
    /*_tabController.addListener(() {
        if (_tabController.indexIsChanging) {
          this._handleTabSelection();
        }
      });
      */
    _loadTemplate();
    _loadData(myTabs[_tabController.index].filter);
  }

  /// load template info into appData global singleton
  void _loadTemplate() async {
    appData.template = await svc.getTemplate();
  }

  void _handleTabSelection() {
    if (previousIndex != _tabController.index) {
      setState(() {
        //print('previousIndex ${previousIndex} currentIndex: ${_tabController.index}');
        _loadData(myTabs[_tabController.index].filter);
        previousIndex = _tabController.index;
      });
    }
  }

  void _loadData(String filter) async {
    _visitListFuture = svc.getAllVisits(filter: filter);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void refreshVisitList() async {
    print('in refreshVisitList');
    // reload
    setState(() {
      _loadData(myTabs[_tabController.index].filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

    return MaterialApp(
      home: DefaultTabController(
        length: myTabs.length,
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
              controller: _tabController,
              tabs: [
                ...myTabs.map((MyTab tab) {
                  final String label = tab.title.toUpperCase();
                  return Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(label));
                }).toList()
              ],
            ),
            title: Text(pageTitle),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  semanticLabel: 'add',
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AddVisit.id)
                      .whenComplete(refreshVisitList);
                  //Navigator.pushNamed(context, AddVisit.id).then(    (value) { refreshVisitList();}       );
                  //refreshVisitList();
                },
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              //TODAY TAB PANE CONTENT

              ...myTabs.map((MyTab tab) {
                return FutureBuilder<List<VisitListItem>>(
                  future: _visitListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);

                    return snapshot.hasData
                        ? VisitListView(visits: snapshot.data)
                        : Center(child: CircularProgressIndicator());
                  },
                );
              }).toList(),
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

class VisitListView extends StatefulWidget {
  final List<VisitListItem> visits;
  VisitListView({Key key, this.visits}) : super(key: key);

  _VisitListViewState createState() => _VisitListViewState(visits: visits);
}

class _VisitListViewState extends State<VisitListView> {

  final List<VisitListItem> visits;
  //final TracerService svc = new TracerService();

  _VisitListViewState({Key key, this.visits});

  // pull to refresh
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // pull down
  void _onRefresh() async {
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
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 12, 0),
                                        child: Text(
                                          //'${visits[position].visitDatetime}',
                                          new DateFormat('M/d/yy h:mm aa')
                                              .format(visits[position]
                                                  .visitDatetime),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        //TO DO ICON
                                        Column(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(FontAwesomeIcons
                                                  .solidClipboard),
                                              color: Colors.black45,
                                              iconSize: 16,
                                              onPressed: () async {
                                                final String todo =
                                                    await _todoInputDialog(
                                                        context,
                                                        visits[position]);
                                                print("todo is ${todo}");
                                                if (todo != 'CANCEL') {
                                                  visits[position].todo = todo;
                                                }
                                              },
                                            ),
                                          ],
                                        ),

                                        //participants  ICON
                                        Column(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(FontAwesomeIcons
                                                  .solidUserCircle),
                                              color: Colors.black45,
                                              iconSize: 16,
                                              onPressed: () async {
                                                final String participants =
                                                    await _participantsInputDialog(
                                                        context,
                                                        visits[position]);
                                                print(
                                                    "participants are $participants");
                                                if (participants != 'CANCEL') {
                                                  visits[position]
                                                          .participants =
                                                      participants;
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        //MORE ACTIONS ICON
                                        Column(
                                          children: <Widget>[
                                            PopupMenuButton<int>(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.black45,
                                              ),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: ListTile(
                                                    leading: Icon(Icons.edit),
                                                    onTap: () async {
                                                      final returnData =
                                                          await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditVisit(
                                                            visit: visits[
                                                                position],
                                                          ),
                                                        ),
                                                      );
                                                      if (returnData == 'updated') {
                                                        setState(() {//ToDo
                                                          visits[position] = visits[
                                                                position];
                                                        });
                                                      }
                                                    },
                                                    title: Text('Edit visit'),
                                                  ),
                                                ),
                                                const PopupMenuDivider(),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: ListTile(
                                                    leading: Icon(Icons.delete),
                                                    title: Text('Delete visit'),
                                                  ),
                                                ),
                                              ],
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
                })));
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

Future<String> _participantsInputDialog(
    BuildContext context, VisitListItem visit) async {
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
              Navigator.pop(context, 'CANCEL');
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () async {
              bool success = await svc.savePropertyForVisit(
                  "participants", _controller.text, visit.id);
              Navigator.pop(context, _controller.text);
            },
          ),
        ],
      );
    },
  );
}

Future<String> _todoInputDialog(
    BuildContext context, VisitListItem visit) async {
  final TracerService svc = new TracerService();
  final _controller = TextEditingController();
  print('controllertext= ${_controller.text} visit todo ${visit.todo}');
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
              Navigator.pop(context, 'CANCEL');
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () async {
              bool success = await svc.savePropertyForVisit(
                  "todo", _controller.text, visit.id);
              //we need to update the text
              Navigator.pop(context, _controller.text);
            },
          ),
        ],
      );
    },
  );
}
