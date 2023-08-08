import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/orders/order_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacteristicsVehiclePage extends StatefulWidget {
  CharacteristicsVehiclePage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _CharacteristicsVehiclePageState();
}

class _CharacteristicsVehiclePageState extends State<CharacteristicsVehiclePage> {

  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();
  final TextEditingController _weight = TextEditingController();
//  final TextEditingController _enfriamiento = TextEditingController();
  final TextEditingController _size = TextEditingController();
  final TextEditingController _vehicleType = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: fletgoPrimary,
          title: Text("Caracteristicas Vehículo",
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

                    double amountDistance;
                    double amountTMP;
                    String getamountTMP;
                    double amountTotal;
                    double distanceTMP;

                    getamountTMP = val.data[widget.order.typeTravel];
                    amountTMP = double.tryParse(
                        getamountTMP.toString().substring(
                            0, getamountTMP.length - 2));
                    distanceTMP = double.tryParse(widget.order.kmDistance);
                    amountDistance = double.tryParse(val.data['tarifaKM']);
                    amountTotal = (amountDistance * distanceTMP) + amountTMP;

                    String stringAmount = amountTotal.toString().substring(
                        0, amountTotal.toString().indexOf('.') + 3);
                    print('Amount: ' + stringAmount);

                    infoPayment paymentInfo = new infoPayment(
                        amount: stringAmount,
                        currency: 'MXN'
                    );

                    widget.order.package = new Package();
//                    widget.order.package.size = _size1.text + 'x' + _size2.text + 'x' + _size3.text;
                    widget.order.package.size = _size.text + ' mts';
                    widget.order.package.weight = double.parse(_weight.text);
                    widget.order.package.vehicleType = _vehicleType.text;
//                    widget.order.package.isUrgent = _urgente.text;
//                    widget.order.package.image = _image;
                    widget.order.tarifa = val.data[widget.order.typeTravel];

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            OrderSummaryPage(widget.order, paymentInfo)));

//                    double amountDistance;
//                    double amountTMP;
//                    String getamountTMP;
//                    double amountTotal;
//                    double distanceTMP;
//
//                    getamountTMP = val.data[widget.order.typeTravel];
//                    amountTMP = double.tryParse(getamountTMP.toString().substring(0,getamountTMP.length - 2));
//                    distanceTMP = double.tryParse(widget.order.kmDistance);
//                    amountDistance = double.tryParse(val.data['tarifaKM']);
//                    print('3.4: ' + amountDistance.toString());
//                    print('3.4: ' + distanceTMP.toString());
//                    print('3.4: ' + amountTMP.toString());
//                    amountTotal = (amountDistance * distanceTMP) + amountTMP;
//                    String stringAmount = amountTotal.toString().substring(0,amountTotal.toString().indexOf('.') + 3);
//                    print('Amount: ' + stringAmount);
//
//                    infoPayment paymentInfo = new infoPayment(
//                        amount:  stringAmount,
//                        currency: 'MXN'
//                    );
//
//                    widget.order.package = new Package();
////                    widget.order.package.enfriamiento = _enfriamiento.text;
////                    widget.order.package.size = double.parse(_size.text);
//                    widget.order.package.size = _size.text;
//                    widget.order.package.weight= double.parse(_weight.text);
//                    widget.order.package.vehicleType = _vehicleType.text;
//
//                    Navigator.push(context,MaterialPageRoute(builder: (context) => OrderSummaryPage(widget.order, paymentInfo)));
                  }
                  catch(onError){
                    print(onError);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Caracteristicas del vehiculo')));
//                    ErrorsPage(onError.toString(),'Characteristica de vehiculo');
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
//              Text(
//                "Ocupa enfriamiento",
//                style: TextStyle(
//                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
//              ),
//              SizedBox(height: fletgoPadding),
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
