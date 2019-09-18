import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/user.dart';


class AppData {
  static final AppData _singleton = new AppData._internal();

  User user;
  Template template;

  factory AppData() {
    return _singleton;
  }

  AppData._internal();

}

AppData appData = new AppData();