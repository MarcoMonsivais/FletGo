import 'package:fletgo_user_app/views/orders/order_summary_page.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class MudanzaPage extends StatefulWidget {
  MudanzaPage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _MudanzaPageState();
}

class _MudanzaPageState extends State<MudanzaPage> {

  final TextEditingController eCtrl = new TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _size = TextEditingController();
  final TextEditingController _size1 = TextEditingController();
  final TextEditingController _size2 = TextEditingController();
  final TextEditingController _size3 = TextEditingController();
  final TextEditingController _vehicleType = TextEditingController();
//  final TextEditingController _urgente = TextEditingController();
  bool checkedValue = false;
  List<String> litems = [];
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: fletgoPrimary,
          title: Text("Descripción de la mudanza",
          style: TextStyle(fontFamily: 'Poppins',fontSize:16)),
          leading: BackButton(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () async {

                await Firestore.instance
                    .collection('conf')
                    .document('costs')
                    .get()
                    .then((val) {
                  try {

                    infoPayment paymentInfo = new infoPayment(
                        amount: val.data[widget.order.typeTravel],
                        currency: 'MXN'

                    );

                    widget.order.package = new Package();
//                    widget.order.package.enfriamiento = _enfriamiento.text;
//                    widget.order.package.size = double.parse(_size.text);
                    widget.order.package.weight= double.parse(_weight.text);
                    widget.order.package.vehicleType = _vehicleType.text;

                    Navigator.push(context,MaterialPageRoute(builder: (context) => OrderSummaryPage(widget.order, paymentInfo)));
                  }
                  catch(onError){
                    print('Errorafatal ' + onError.toString());
                  }
                });
          },
        )
      ],
    ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(fletgoPadding),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Image(image: AssetImage("assets/tipos_vehiculos.png"), height: 200,),
              SizedBox(height: fletgoPadding),
              Text(
                "Indique que tipo de vehiculo se necesita para la entrega ",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              Divider(
                  color: Colors.black
              ),
              Text(
                "Ocupa enfriamiento",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              SizedBox(height: fletgoPadding),
//              TextField(
//                controller: _enfriamiento,
////                onSubmitted: (text) {
////                  litems.add(text);  // Append Text to the list
////                  eCtrl.clear();     // Clear the Text area
////                  setState(() {});   // Redraw the Stateful Widget
////                },
//                decoration: InputDecoration(
//                  border:
//
//                  OutlineInputBorder(),
//                ),
//              ),
//              Expanded(
//                  child: new ListView.builder
//                    (
//                      itemCount: litems.length,
//                      itemBuilder: (BuildContext ctxt, int Index) {
//                        return new Text(litems[Index]);
//                      }
//                  )
//              ),

              SizedBox(height: fletgoPadding),
              Text(
                "Tamaño Paquete",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              SizedBox(height: fletgoPadding),
              TextField(
                controller: _size,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mts',
                ),
              ),
              SizedBox(height: fletgoPadding),
              Text(
                "Peso Paquete",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              SizedBox(height: fletgoPadding),
              TextField(
                controller: _weight,
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Kg',
                ),
              ),
              SizedBox(height: fletgoPadding),
              Text(
                "Tipo de vehículo",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              SizedBox(height: fletgoPadding),
              TextField(
                controller: _vehicleType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pick up, trailer...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
