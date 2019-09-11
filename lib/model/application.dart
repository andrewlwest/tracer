
import 'package:Tracer/model/user.dart';

class Application {
  static final Application _singleton = new Application._internal();

  factory Application() {
    return _singleton;
  }

  Application._internal();

  User user;

}
