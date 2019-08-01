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
import 'package:flutter/material.dart';
import 'model/visits_repository.dart';
import 'model/visit.dart';
import 'font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  List<Card> _buildGridCards(BuildContext context) {
    List<Visit> visits = VisitsRepository.loadVisits(Category.all);

    if (visits == null || visits.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);

    return visits.map((visit) {
      // CARD OVERLINE WITH SITE AND LOCATION
      final vCardOverline = new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              visit.site + ' - ' + visit.location,
              maxLines: 1,
              style: theme.textTheme.caption,
            ),
          ],
        ),
      );

      //CARD OVERLINE WITH DATE/TIME
      final vCardDate = new Column(
        children: <Widget>[
          Text(
            visit.time,
            maxLines: 1,
            style: theme.textTheme.caption,
          ),
        ],
      );

      //CARD HEADING
      final vCardHeading = new Column(
        children: <Widget>[
          Text(
            visit.name,
            style: theme.textTheme.headline,
            maxLines: 1,
          ),
        ],
      );

      //CARD SUMMARY
      final vCardSummary = new Column(
        children: <Widget>[
          Text(
            visit.summary,
            style: theme.textTheme.body2,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      );

      //CARD PROGRESS BAR
      final vCardProgress = new Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: new LinearProgressIndicator(
              valueColor: new AlwaysStoppedAnimation(Colors.blue),
              value: .1,
            ),
            height: 4.0,
            width: 100.0,
          )
        ],
      ));

      //CARD ACTIONS
      final vCardActions = new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              //TO DO ICON
              Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.solidClipboard),
                    color: Colors.black45,
                    iconSize: 18,
                    onPressed: () {
                      print('To Do Button');
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
                    iconSize: 18,
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
                    iconSize: 18,
                    onPressed: () {
                      print('Card Actions');
                    },
                  ),
                ],
              ),
            ],
          )
        ],
      );

      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
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
                    vCardSummary,
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        vCardProgress,
                        vCardActions,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTracersBlue500,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            semanticLabel: 'menu',
          ),
          onPressed: () {
            print('Menu button');
          },
        ),
        title: Text('Visits'),
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
      body: GridView.count(
          crossAxisCount: 1,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 4),
          children: _buildGridCards(context) // Changed code
          ),
      resizeToAvoidBottomInset: false,
    );
  }
}
