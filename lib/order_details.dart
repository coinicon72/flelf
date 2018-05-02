import 'package:flutter/material.dart';

import 'rest.dart';

class OrderDetails extends StatefulWidget {
  final order;
  OrderDetails(this.order);

  @override
  _OrderDetailsState createState() => new _OrderDetailsState(this.order);
}

class _OrderDetailsState extends State<OrderDetails> {
  var order;
  _OrderDetailsState(this.order);

  @override
  void initState() {
    super.initState();

    // _loadData();
  }

  // _loadData() async {
  //   RestApi.get("http://175.6.57.235:8081/api/data/orders/${order.id}");
  // }
  @override
  Widget build(BuildContext context) {
    var client = order['_embedded']['client'];
    List items = order['_embedded']['items'];

//
    String status;

    switch (order['status']) {
      case 0:
        status = '已签订';
        break;
      case 1:
        status = '履行中';
        break;
      case 2:
        status = '已完成';
        break;
      case 3:
        status = '已取消';
        break;
      default:
    }

//
    return new Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Material(
              child: Column(
                children: <Widget>[
                  Text(order['id'].toString()),
                  Text(order['no']),
                  Text(order['orderDate'].split("T")[0]),
                  Text(order['deliveryDate'].split("T")[0]),
                  Text(order['tax'] ? '含税' : '不含税'),
                  Text(order['value'].toString()),
                  Text(order['comment'] ?? "<无>"),
                  Text(status),
                ],
              ),
            ),
            Material(
              child: Column(
                children: <Widget>[
                  Text(client['contractNo'].toString()),
                  Text(client['name']),
                  Text(client['fullName']),
                  Text(client['settlementPolicy']),
                  Text(client['type']['name']),
                ],
              ),
            ),
            Material(
              child: Column(
                children:
                    items.map((item) => Text(item['product']['code'])).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
