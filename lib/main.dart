import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'redux.dart';
import './login.dart';
import './materials.dart';


void main() async {
  // final store = Store<AppState>(stateReducer, initialState: AppState(""), middleware: [loggingMiddleware]);
  var state = await SharedPreferences.getInstance()
  .then((sp) { 
    return sp.getString('state');
    })
  .then(json.decode)
  .then((m) {
    return new AppState.loadFromJson(m);
  })
  .catchError(print);

  if (state != null)
    reduxStore.dispatch(new ActionLoadFromPreference(state));

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final Store<AppState> store = reduxStore;

  // MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var entry;

    final token = reduxStore.state.token ?? "";
    if (token.isNotEmpty)
      entry = new MyHomePage();
    else
      entry = new LoginPage();

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: entry,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "Main";
  final Store<AppState> store = reduxStore;

  @override
  _MyHomePageState createState() =>new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _doNav() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new MaterialsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _doNav,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
