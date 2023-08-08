import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TravelDetailPage extends StatefulWidget {

  TravelDetailPage(this.customerid,this.orderid,this.activeorderId,this.op);

  final String customerid, orderid, activeorderId, op;

  @override
  State<StatefulWidget> createState() => _TravelDetailPageState();
}

class _TravelDetailPageState extends State<TravelDetailPage> {

  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        resizeToAvoidBottomPadding: false,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text(widget.customerid),
              // Text(widget.activeorderId),
              // Text(widget.op),
              // Text(widget.orderid),
              FutureBuilder(
                future: _db.collection('users')
                    .document(widget.customerid)
                    .collection("orders")
                    .document(widget.orderid)
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
                            buttonWidget(),
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
                          child:
                            Column(
                              children: <Widget> [
                                ListView(
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

  buttonWidget(){
    switch (widget.op){
      case 'aceptada':
        return Expanded(
          child: PrimaryButton(
            text: 'Asignar',
            height: 50,
            onPressed: () async {
              try{

                final Firestore _db = Firestore.instance;
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final newUser = await _auth.currentUser();
                String uuidUser = newUser.uid.toString();
                String uuidName = '', uuidStatus = '';

                await _db.collection('socios').document(uuidUser).get().then((value) {
                  uuidName = value.data['userName'];
                  uuidStatus = value.data['currentState'];
                });

                if(uuidStatus == 'activo') {
                  await _showMyDialog(
                      'Te hemos asignado esta orden y ahora el usuario ha sido notificado.');

                  await _db.collection('users').document(widget.customerid)
                      .collection('orders').document(widget.orderid)
                      .updateData({
                    'addStatus': 'asignada',
                    'addFletGoerMessage': 'Que tal, soy ' + uuidName +
                        ' y tomaré su orden en la fecha establecida. Gracias',
                    'socioOrder': widget.activeorderId
                  });

                  await _db.collection('socios').document(uuidUser).collection(
                      'Orders').document(widget.activeorderId).setData({
                    'orderId': widget.orderid,
                    'customerId': widget.customerid,
                    'status': 'active',
                    'orderStatus': 'asignada'
                  });

                  await _db.collection('activeOrders').document(
                      widget.activeorderId).delete();

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapPage()));
                } else {
                  await _showMyDialog(
                      'Tu usuario no ha sido verificado y no puedes tomar ordenes. Contacta con el equipo FletGo o espera un lapso de 24 horas para recibir instrucciones para tomar la orden.');
                }

              } catch (onError)
              {
                Navigator.push(context, MaterialPageRoute( builder: (context) => ErrorsPage(onError.toString(),'Tomar orden')));
                // print(onError.toString());
              }
            },),
        );
        break;
      case 'asignada':
        return Expanded(
          child: PrimaryButton(
            text: 'Iniciar',
            height: 50,
            onPressed: () async {
              try{
                await _showMyDialog('El pedido ha sido iniciado y hemos notificado al usuario de esto. Tienes un lapso de 2 horas para recoger el paquete');

                final Firestore _db = Firestore.instance;
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final newUser = await _auth.currentUser();
                String uuidUser = newUser.uid.toString();

                await _db.collection('socios').document(uuidUser).collection('perfil').getDocuments().then((value) {
                  print(value.documents[0].data['userName']);

                });

                // await _db.collection('users').document(widget.customerid).collection('orders').document(widget.orderid).updateData({
                //   'addStatus': 'iniciada',
                //   'addFletGoerMessage': 'Estoy en camino a recoger tu pedido, gracias.'
                // });
                //
                // await _db.collection('socios').document(uuidUser).collection('Orders').document(widget.activeorderId).updateData({
                //   'orderStatus': 'iniciada'
                // });
                //
                // Navigator.push(context,MaterialPageRoute(builder: (context) => MapPage()));
                // Navigator.of(context).pushNamedAndRemoveUntil(MapPage(), (Route<dynamic> route) => false);
              } catch (onError)
              {
                Navigator.push(context, MaterialPageRoute( builder: (context) => ErrorsPage(onError.toString(),'Tomar orden')));
                print(onError.toString());
              }
            },),
        );
        break;
      case 'iniciada':
        return Expanded(
          child: PrimaryButton(
            text: 'Iniciar trayecto',
            height: 50,
            onPressed: () async {
              try{
                await _showMyDialog('Has recogido con éxito el pedido. Ahora puedes notificar al cliente de la hora de entrega.');

                final Firestore _db = Firestore.instance;
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final newUser = await _auth.currentUser();
                String uuidUser = newUser.uid.toString();

                await _db.collection('users').document(widget.customerid).collection('orders').document(widget.orderid).updateData({
                  'addStatus': 'en curso',
                  'addFletGoerMessage': 'Tu paquete esta en movimiento a su destino.'
                });


                await _db.collection('socios').document(uuidUser).collection('Orders').document(widget.activeorderId).updateData({
                  'orderStatus': 'en curso'
                });

                Navigator.push(context,MaterialPageRoute(builder: (context) => MapPage()));
                // Navigator.of(context).pushNamedAndRemoveUntil(MapPage(), (Route<dynamic> route) => false);
              } catch (onError)
              {
                Navigator.push(context, MaterialPageRoute( builder: (context) => ErrorsPage(onError.toString(),'Tomar orden')));
                print(onError.toString());
              }
            },),
        );
        break;
      case 'en curso':
        return Expanded(
          child: PrimaryButton(
            text: 'finalizar',
            height: 50,
            onPressed: () async {
              try{
                await _showMyDialog('Has terminado con éxito la orden. Ahora puedes consultar el viaje en tu historial de viajes');

                final Firestore _db = Firestore.instance;
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final newUser = await _auth.currentUser();
                String uuidUser = newUser.uid.toString();

                await _db.collection('users').document(widget.customerid).collection('orders').document(widget.orderid).updateData({
                  'addStatus': 'terminada',
                  'addFletGoerMessage': 'Tu orden ha sido terminada.',
                  'commented': false,
                  'rate': 3.5
                });

                await _db.collection('socios').document(uuidUser).collection('History').document(widget.activeorderId).setData({
                  'orderId': widget.orderid,
                  'customerId': widget.customerid,
                  'status': 'inactive',
                  'orderStatus': 'terminada'
                });

                await _db.collection('socios').document(uuidUser).collection('Orders').document(widget.activeorderId).delete();

                Navigator.push(context,MaterialPageRoute(builder: (context) => MapPage()));
                // Navigator.of(context).pushNamedAndRemoveUntil(MapPage(), (Route<dynamic> route) => false);
              } catch (onError)
              {
                Navigator.push(context, MaterialPageRoute( builder: (context) => ErrorsPage(onError.toString(),'finalizar orden')));
                print(onError.toString());
              }
            },),
        );
        break;
    }
  }

  _headerPhoto(String photoUrl) {
    if(photoUrl.length<=0) {
      return Image(image: AssetImage("assets/no_data.png"), height: 250);
    } else {
      return Image.network(photoUrl, height: 250,fit: BoxFit.fill);
    }
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