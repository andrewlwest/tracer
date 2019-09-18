import 'package:Tracer/createVisit.dart';
import 'package:Tracer/editVisit.dart';
import 'package:Tracer/home.dart';
import 'package:Tracer/login.dart';
import 'package:Tracer/observationDetail.dart';
import 'package:Tracer/visitDetail.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => HomePage());
    case '/login':
      return FadeRoute(page: LoginPage());
    case 'visitDetail':
      final VisitDetailPageArguments args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => VisitDetailPage(visitId: args.visitId));
    case 'observationDetail':
      final ObservationDetailPageArguments args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => ObservationDetailPage(
              visitId: args.visitId,
              observationCategoryId: args.observationCategoryId));
    case 'createVisit':
      return ScaleRoute(page: CreateVisitPage());
    case 'editVisit':
      return MaterialPageRoute(builder: (context) => EditVisitPage());
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
