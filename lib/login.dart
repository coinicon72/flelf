import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'redux.dart';
import 'rest.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  // final Store<AppState> store;

  // LoginPage({this.store});

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Store<AppState> store = reduxStore;

  var _context;
  var _uidController = new TextEditingController(text: 'a@b.c');
  var _pwdController = new TextEditingController(text: '1234');

  void doLogin() {
    new RestApi()
        .login(email: _uidController.text, password: _pwdController.text)
        .then((s) => s["token"])
        .then((t) {
          debugPrint(t);
          store.dispatch(new ActionUpdateToken(t));
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new MyHomePage()));
        })
        .catchError((e) {
      Scaffold.of(_context).showSnackBar(new SnackBar(
            content: new Text(e.toString()),
            duration: new Duration(seconds: 3),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // backgroundColor: Colors.blueGrey,
      body: new Builder(
        builder: (BuildContext context) {
          _context = context;

          return new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Material(
              color: Colors.transparent,
              child: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new TextField(
                      controller: _uidController,
                      decoration: new InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    new Padding(
                      child: new TextField(
                        obscureText: true,
                        controller: _pwdController,
                        decoration: new InputDecoration(
                          labelText: 'Password',
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 16.0),
                    ),
                    new Padding(
                      child: new FlatButton(
                        child: new Text(
                          "Login",
                          textDirection: TextDirection.ltr,
                        ),
                        onPressed: doLogin,
                      ),
                      padding: const EdgeInsets.only(top: 16.0),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
