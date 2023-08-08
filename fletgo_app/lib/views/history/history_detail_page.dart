import 'package:flutter/material.dart';

class HistoryDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  List<Object> orders = [
    {
      "price": 123.0
    },
    {
      "price": 123.0
    },
    {
      "price": 123.0
    },
    {
      "price": 123.0
    },
    {
      "price": 123.0
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
              "Detalles ",
              style: TextStyle(color: Colors.black)
          ),
          backgroundColor: Colors.white,
          leading: BackButton(color: Colors.black)
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }

}