
import 'package:Tracer/model/template/template.dart';
import 'package:Tracer/model/user.dart';

class Application {
  static final Application _singleton = new Application._internal();

  User user;
  Template template;

  factory Application() {
    return _singleton;
  }

  Application._internal();

}
