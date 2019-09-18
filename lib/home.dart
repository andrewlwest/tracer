
import 'package:Tracer/application/appData.dart';
import 'package:Tracer/model/tracerVisit.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:Tracer/ui/font_awesome_flutter.dart';
import 'package:Tracer/visitDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:Tracer/editVisit.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum ConfirmAction { CANCEL, ACCEPT }
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

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Future<List<TracerVisit>> _visitListFuture;
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
                  Navigator.pushNamed(context, "createVisit")
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
                return FutureBuilder<List<TracerVisit>>(
                  future: _visitListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);

                    return snapshot.hasData
                        ? VisitListView(
                            visits: snapshot.data,
                            callback: () {
                              refreshVisitList();
                            },
                          )
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
                  accountName: Text(appData.user != null ? appData.user.name : "no user loged in"),
                  accountEmail: Text("missing required email"),
                  decoration: BoxDecoration(
                    color: kTracersBlue500,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: kTracersBlue900,
                    child: Text(
                      appData.user != null ? appData.user.initials() : "?",
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
  final List<TracerVisit> visits;
  final Function callback;
  VisitListView({Key key, this.visits, this.callback}) : super(key: key);

  _VisitListViewState createState() =>
      _VisitListViewState(visits: visits, callback: callback);
}

class _VisitListViewState extends State<VisitListView> {
  final Function callback;
  final List<TracerVisit> visits;
  //final TracerService svc = new TracerService();

  _VisitListViewState({Key key, this.visits, this.callback});

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

  void _deleteVisit(String visitId) async {
    await (new TracerService()).deleteVisit(visitId: visitId);
    callback();
  }

Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure you want to delete this visit?'),
        content: const Text(
            'This will delete the visit and all of its contents.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('ACCEPT'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
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
            child: visits.isEmpty ? Center(child: Text('No Visits')) : ListView.builder(
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
                                                              EditVisitPage(
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
                                              onSelected: (value) async {
                                                print("value: $value");
                                                if (value == 1) {
                                                  final returnData =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditVisitPage(
                                                        visit: visits[position],
                                                      ),
                                                    ),
                                                  );
                                                  if (returnData == 'updated') {
                                                      callback();
                                                  }
                                                } else {
                                                  //Are you sure you want to delete it?
                                                  final ConfirmAction action = await _asyncConfirmDialog(context);
                                                  print('action = $action');
                                                  if (action == ConfirmAction.ACCEPT) {
                                                    //delete the visit
                                                    _deleteVisit(visits[position].id);
                                                  }
                                                }
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
                })));
  }
}

void _onTapItem(BuildContext context, TracerVisit visit) {
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
    BuildContext context, TracerVisit visit) async {
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
    BuildContext context, TracerVisit visit) async {
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
