import 'package:Tracer/application/appData.dart';
import 'package:Tracer/model/user.dart';
import 'package:Tracer/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:Tracer/service/tracer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final TracerService svc = TracerService();

  String _userLogin;
  bool _authorized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    //userList = await svc.getAllUsers();

    SharedPreferences.getInstance().then((sp) async {
      //print("sp " + sp.getString("userLogin"));
      var authUsername = sp.getString("authenticatedUserLogin");
      var auth = (authUsername != null && authUsername.isNotEmpty);

      setState(() {
        _usernameController.text = authUsername;
        _authorized = auth;
      });

      if (authUsername != null) {
        // load user
        try {
          var user = await svc.getUser(authUsername);
          appData.user = user;
          Navigator.pop(context);
        } catch (err) {
          print("error logging in using stored login '$authUsername': $err");
        }
      } 
    });

    //print("login is " + _userLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kTracersBlue900,
      body: _authorized ? Center(child: CircularProgressIndicator()) : SafeArea(
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
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    String login = _usernameController.value.text;
    String pass = _passwordController.value.text;
    String errorMessage;

    if (login != null && login.isNotEmpty && pass != null && pass.isNotEmpty) {
      bool success = await svc.login(login, pass);
      print("success = " + (success ? "true" : "false"));
      //bool success = true;

      // if successful partners login.. lookup user and persist
      if (success) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("authenticatedUserLogin", login);

        // load user
        try {
          var user = await svc.getUser(login);
          appData.user = user;
        } catch (err) {
          errorMessage = "login failed: $err";
        }
      } else {
        errorMessage = "Partners Login Failed";
      }

      if (errorMessage != null) {
        final snackBar = SnackBar(content: Text(errorMessage));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        Navigator.pop(context);
      }
    } else {
      final snackBar = SnackBar(content: Text("Username and Password are required"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
}

      /*
      User user = await svc.getUser(login).catchError((e) {
        print('there was an error $e');
      });

    
      if (user == null) {
        final snackBar = SnackBar(content: Text('login failed, try again'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        // set the authenticqated user object in the Application singleton.
        //Application application = new Application();
        appData.user = user;
        Navigator.pop(context);
      }
    } else {
      final snackBar = SnackBar(content: Text('login failed, try again'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    */