import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PedidosDetailPage extends StatefulWidget {
  PedidosDetailPage(this.customerId,this.orderId);

  final String customerId, orderId;

  @override
  State<StatefulWidget> createState() => _PedidosDetailPageState();
}

class _PedidosDetailPageState extends State<PedidosDetailPage> {

  final Firestore _db = Firestore.instance;
  final TextEditingController _commentsController = TextEditingController();
  bool iGG;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
              "Detalles ",
              style: TextStyle(color: Colors.white)
          ),
          backgroundColor: fletgoPrimary,
          leading: BackButton(color: Colors.white)
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: _db.collection('users')
                    .document(widget.customerId)
                    .collection("orders")
                    .document(widget.orderId)
                    .get(),
                // ignore: missing_return
                builder: (context, snapshot) {

                  //DocumentSnapshot
                  DocumentSnapshot ds = snapshot.data;

                  //PhotoURL
                  String PhotoURL;
                  try {
                    PhotoURL = ds.data['addimageURL'].toString();
                    PhotoURL = PhotoURL.replaceAll('[', '');
                    PhotoURL = PhotoURL.replaceAll(']', '');
                    PhotoURL.isEmpty ? PhotoURL = '' : null;
                    PhotoURL=='null' ? PhotoURL = '' : null;
                  } catch(onError) {
                    print('Error PhotoURL: ' + onError.toString());
                    PhotoURL = '';
                  }

                  //MAP PAGOS
                  String precio;
                  try
                  {
                    Map<dynamic, dynamic> mapPayment = ds['detailPaymentInfo'];
                    var _listPayment = mapPayment.values.toList();
                    precio = _listPayment[0];
                  } catch(onError) {
                    print('Error Pagos: ' + onError.toString());
                    precio = 'no pagado';
                  }

                  //MAP PICK UP
                  String nombre_pickup, date_pickup, hour1_pickup, hour2_pickup, instructions_pickup, main_pickup;
                  try {
                    Map<dynamic, dynamic> mapdetailPickUpAddress = snapshot.data['detailPickUpAddress'];

                    main_pickup = mapdetailPickUpAddress['mainText'];
                      main_pickup.isEmpty ? main_pickup = 'Sin ubicación' : null;

                    Map<dynamic, dynamic> mapdetailPickUpAddressDetails = mapdetailPickUpAddress['details'];

                    nombre_pickup = mapdetailPickUpAddressDetails['name'];
                      nombre_pickup.isEmpty ? nombre_pickup = 'No existe valor' : null;
                    date_pickup = mapdetailPickUpAddressDetails['date'];
                      date_pickup.isEmpty ? date_pickup = 'NP' : null;
                    hour1_pickup = mapdetailPickUpAddressDetails['hour1'];
                      hour1_pickup.isEmpty ? hour1_pickup = 'NP' : null;
                    hour2_pickup = mapdetailPickUpAddressDetails['hour2'];
                      hour2_pickup.isEmpty ? hour2_pickup = 'NP' : null;
                    instructions_pickup = mapdetailPickUpAddressDetails['instructions'];
                      instructions_pickup.isEmpty ? instructions_pickup = 'Sin instrucciones' : null;
                  } catch (onError){
                    print('Error PickUp: ' + onError.toString());
                    nombre_pickup = 'No existe valor';
                    date_pickup = 'NP';
                    hour1_pickup = 'NP';
                    hour2_pickup = 'NP';
                    instructions_pickup = 'Sin instrucciones';
                    main_pickup = 'Sin ubicación';
                  }

                  //MAP DROP OFF
                  String nombre_dropoff, instructions_dropoff, phone_dropoff, main_dropoff;
                  try {
                    Map<dynamic, dynamic> mapdetailDropFFUpAddress = snapshot.data['detailDropOffAddress'];

                    main_dropoff = mapdetailDropFFUpAddress['mainText'];
                      main_dropoff.isEmpty ? main_dropoff = 'No existe valor' : null;

                    Map<dynamic, dynamic> mapdetailDropOffDetails = mapdetailDropFFUpAddress['details'];

                    nombre_dropoff = mapdetailDropOffDetails['name'];
                      nombre_dropoff.isEmpty ? nombre_dropoff = 'No existe valor' : null;
                    instructions_dropoff = mapdetailDropOffDetails['instructions'];
                      instructions_dropoff.isEmpty ? instructions_dropoff = 'No existe valor' : null;
                    phone_dropoff = mapdetailDropOffDetails['contacto'];
                      phone_dropoff.isEmpty ? phone_dropoff = 'No existe valor' : null;
                  } catch(onError){
                    print('Error DropOff: ' + onError.toString());
                    nombre_dropoff = 'No existe valor';
                    instructions_dropoff = 'No existe valor';
                    phone_dropoff = 'No existe valor';
                    main_dropoff = 'Sin ubicación';
                  }



                  //------------------------------------------------------------
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _headerPhoto(PhotoURL),
                        Row(
                            children: [
                              Expanded(
                                  child: ListTile(
                                    title: Text(ds.data['addStatus'],textAlign: TextAlign.left,style: TextStyle(color: fletgoPrimary),),

                                    subtitle: Text(ds.data['addType'],textAlign: TextAlign.left),
                                  )
                              ),

                              rate(ds.data['addStatus'], ds.data['commented'], ds.data['rate']),

//                              Expanded(
//                                child: PrimaryButton(
//                                  text: 'Cancelar',
//                                  height: 50,
//                                  onPressed: () async {
//                                    try{
//                                      await _showMyDialog('');
//                                      Navigator.push(context,MaterialPageRoute(builder: (context) => MapPage()));
//                                    } catch (onError)
//                                    {
//                                      print(onError.toString());
//                                    }
//                                  },),
//                              ),
                              Expanded(
                                  child: ListTile(
                                    title: Text('Costo',textAlign: TextAlign.right,style: TextStyle(color: fletgoPrimary),),
                                    subtitle: Text(precio,textAlign: TextAlign.right),
                                  )
                              ),
                            ]
                        ),
                        Divider(height: 4,thickness: 5,),
                        Container(
                          color: Colors.white,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: ListView(
                            scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Desde: ' + main_pickup, textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),),]),),
                                  SizedBox(height: fletgoPadding,),
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Contacto: ' + nombre_pickup,textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),)]),),
                                  SizedBox(height: fletgoPadding,),
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Recoger: ' + date_pickup,textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),)]),),
                                  SizedBox(height: fletgoPadding,),
                                  Align(alignment: Alignment.topLeft,child: Row(children: [
                                    Text('Entre la(s) ' + hour1_pickup,textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),),
                                    Text(' y las ',style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),),
                                    Text(hour2_pickup,textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),),
                                  ]),),
                                  SizedBox(height: fletgoPadding,),
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Comentarios: ' + instructions_pickup,textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),)]),),
                                  Divider(height: 6,thickness: 5,),
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Hasta: ' + main_dropoff,textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),)]),),
                                  SizedBox(height: fletgoPadding,),
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Entregar a: ' + nombre_dropoff,textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),)]),),
                                  SizedBox(height: fletgoPadding,),
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Número de contacto: ' + phone_dropoff,textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),)]),),
                                  SizedBox(height: fletgoPadding,),
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Comentarios: ' + instructions_dropoff,textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),)]),),
                                  Divider(height: 6,thickness: 5,),
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Mensaje de FletGo: ' + ds.data['addFletGoMessage'],textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),)]),),
                                  SizedBox(height: fletgoPadding,),
                                  Align(alignment: Alignment.topLeft,child: Column(children: [Text('Mensaje de FletGoer: ' + ds.data['addFletGoerMessage'],textAlign: TextAlign.left, style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),)]),),
                                ],
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _headerPhoto(String photoUrl) {
    if(photoUrl.length<=0) {
      return Image(image: AssetImage("assets/no_data.png"), height: 250);
    } else {
      return Image.network(photoUrl, height: 250,fit: BoxFit.fill);
    }
  }

  rate(op, igBool, rateFirst){
    if (op=='terminada') {
        return Container(
          width: 150.00,
          child: RatingBar.builder(
            initialRating: rateFirst,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            ignoreGestures: igBool,
            itemSize: 22.0,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
            onRatingUpdate: (rating) {
              Future.delayed(const Duration(milliseconds: 2000), () async {
                await _comentarios(rating);
              });
              // print(rating);
            },
          )
        );
     } else {
      return Expanded(child: Text('Termina el viaje para calificarlo'));
    }

  }

  Future<void> _comentarios(rating) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Califica el viaje'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  ignoreGestures: true,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                TextField(
                  maxLines: 2,
                  controller: _commentsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Agrega tus comentarios',
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Center(child:
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(child: SizedBox(height: 20.0,)),
                  TextButton(
                    child: Text('Aceptar'),
                    onPressed: () async {

                      await _db.collection('users')
                          .document(widget.customerId)
                          .collection("orders")
                          .document(widget.orderId).collection('comment').add({
                        'comentario': _commentsController.text,
                        'rate': rating,
                        'date': DateTime.now().toString(),
                      });

                      await _db.collection('users')
                          .document(widget.customerId)
                          .collection("orders")
                          .document(widget.orderId).updateData({
                        'commented': true,
                        'rate': rating,
                      });

                      await _showMyDialog('¡Gracias por calificar tu viaje!');

                      Navigator.push(context,MaterialPageRoute(builder: (context) => MapPage()));

                    },
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('FletGo App'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(string),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}