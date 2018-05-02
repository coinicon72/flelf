import 'dart:async';

import 'package:flutter/material.dart';

import 'rest.dart';
import 'order_details.dart';

class MaterialsPage extends StatefulWidget {
  @override
  _MaterialsPageState createState() => new _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  List materialList = new List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    //
    _loadData();
  }

  Future<Null> _loadData() async {
    print('_loadData');

    // _refreshIndicatorKey.currentState?.show();

    await RestApi
        .get("http://175.6.57.235:8081/api/data/orders")
        .then((r) => r["_embedded"]["orders"])
        .then((ml) {
      setState(() {
        materialList.clear();
        materialList.addAll(ml);
      });
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Materials")),
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,
        child: new ListView.builder(
          physics: new AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) =>
              new MaterialItem(materialList[index]),
          itemCount: materialList.length,
        ),
        onRefresh: _loadData,
      ),
    );
  }
}

class MaterialItem extends StatelessWidget {
  final dynamic material;
  const MaterialItem(this.material);

  _navToDetails(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return OrderDetails(material);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () => _navToDetails(context),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Text(
                      material["no"],
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new SizedBox(
                      width: 8.0,
                    ),
                    new Text(
                      material["id"].toString(),
                      style: new TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: new Row(
                    children: <Widget>[
                      new Icon(
                        Icons.today,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      new Text(material['orderDate'].split("T")[0]),
                      new SizedBox(
                        width: 16.0,
                      ),
                      new Icon(
                        Icons.today,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      new Text(material['deliveryDate'].split("T")[0]),
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: new Row(
                    children: <Widget>[
                      new Chip(
                        label:
                            new Text(material["_embedded"]["client"]["name"]),
                      ),
                      new SizedBox(width: 8.0),
                      new Chip(
                          label: new Text(
                              material["_embedded"]["client"]["fullName"])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // new Text( material["safeQuantity"])
          new Divider(
            height: 0.0,
          )
        ],
      ),
    );
  }
}
