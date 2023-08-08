import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/views/history/history_detail_page.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage(this.user);

  final FirebaseUser user;

  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final Firestore _db = Firestore.instance;

  List<Object> orders = [
    {"price": 123.0},
    {"price": 123.0},
    {"price": 123.0},
    {"price": 123.0},
    {"price": 123.0}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Historial"),
          leading: BackButton(color: Colors.white)),
      body: SafeArea(
        child: StreamBuilder(
          stream: _db
              .collection('users')
              .document(widget.user.uid)
              .collection('orders')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length < 1) {
                return _noOrdersOnboarding();
              }

              List<Order> orders = [];

              for (var i = 0; i < snapshot.data.documents.length; ++i) {
                orders.add(
                    Order.fromDocumentSnapshot(snapshot.data.documents[i]));
              }

              return _ordersList(orders);
            } else if (snapshot.hasError) {
              return _ordersErrorOnboarding();
            } else {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  _noOrdersOnboarding() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/no_data.png"),
            height: 200,
          ),
          SizedBox(height: 10),
          Text(
            "Sin ordenes registradas",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          Center(
            child: Text(
              "Cuando se termine una orden, aparecera en este apartado",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins'),
            ),
          )
        ],
      ),
    );
  }

  _ordersErrorOnboarding() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/error.png"),
            height: 200,
          ),
          SizedBox(height: 10),
          Text(
            "Ha ocurrido un error",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          Center(
            child: Text(
              "Inténtalo de nuevo más tarde",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins'),
            ),
          )
        ],
      ),
    );
    ;
  }

  _ordersList(List<Order> orders) {
    print(orders.toString());
    return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, position) {
          return Card(
            child: ListTile(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryDetailPage())),
              leading: Icon(Icons.done, color: Colors.green),
              title: Row(
                children: <Widget>[
                  Flexible(
                      flex: 3,
                      child: Text(orders[position].from.mainText,
                          overflow: TextOverflow.ellipsis)),
                  Flexible(flex: 1, child: Icon(Icons.chevron_right)),
                  Flexible(
                      flex: 3,
                      child: Text(orders[position].to.mainText,
                          overflow: TextOverflow.ellipsis))
                ],
              ),
              subtitle: Row(
                children: <Widget>[
                  Icon(Icons.date_range, color: Colors.black54, size: 15),
                  SizedBox(width: 5.0),
                  Text("27/01/2020, 11:04")
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Mudanza",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  Text("MXN \$0.00")
                ],
              ),
            ),
          );
        });
  }
}
