import 'package:Tracer/model/application.dart';
import 'package:Tracer/model/user.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'visit_lists.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final TracerService svc = TracerService();

  String _userLogin;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    //userList = await svc.getAllUsers();
/*
    SharedPreferences.getInstance().then((sp)  {
      print("sp " + sp.getString("userLogin"));
      setState(() {
        _userLogin = sp.getString("userLogin");
        _usernameController.text = _userLogin;
      });
    });
    print("login is " + _userLogin);
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kTracersBlue900,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/tracer-logo-ko.png'),
                SizedBox(height: 16.0),
              ],
            ),
            SizedBox(height: 20.0),
            // [Name]
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: kTracersWhite,
                labelText: 'Username',
              ),
            ),
            // spacer
            SizedBox(height: 12.0),
            // [Password]
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: kTracersWhite,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                // FlatButton(
                //   child: Text('CANCEL'),
                //   onPressed: () {
                //     _usernameController.clear();
                //     _passwordController.clear();
                //   },
                // ),
                RaisedButton(
                  child: Text('LOG IN'),
                  textColor: kTracersWhite,
                  onPressed: () {
                    login(context);

                    //Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> login(BuildContext context) async {
    String login = _usernameController.value.text;
    String pass = _passwordController.value.text;

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => VisitListPage()));

/*
    bool success = await svc.login(login, pass);
    print("success = " + (success ? "true" : "false"));

    // if successful partners login.. lookup user and persist
    if (success) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userLogin", login);

      // load user
      User user = await svc.getUser(login);

      print("user = $user");

      Navigator.push(context,MaterialPageRoute(builder: (context) => VisitListPage()));

    } else {
      final snackBar = SnackBar(
        content: Text('login failed, try again'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
*/
  }
}
