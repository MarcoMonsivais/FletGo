import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'choose_payment_card.dart';

class OrderSummaryPage extends StatefulWidget {
  OrderSummaryPage(this.order, this.paymentInfo);
  
  final infoPayment paymentInfo;
  final Order order;

  @override
  State<StatefulWidget> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {

  final Firestore _db = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final HttpsCallable INTENT = CloudFunctions.instance.getHttpsCallable(functionName: 'createPaymentIntent');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: fletgoPrimary,
        centerTitle: true,
        leading: BackButton(),
        title: Text("Resumen de viaje",
            style:
            TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget> [
              _buildOrderSummary(),
              _buildCharacteristicsVehicle(),
              _buildPricingSummary(),
//              _buildImage(),
              SizedBox(height: fletgoPadding),
              PrimaryButton(
                text: "REALIZAR ORDEN",
                width: MediaQuery
                    .of(context)
                    .size
                    .width - (fletgoPadding * 2),
                height: fletgoButtonHeight,
                onPressed: () => _sendOrder(widget.order, widget.paymentInfo),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() =>
      Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, fletgoPadding, 10, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(fletgoPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Desde: ' + widget.order.from.description,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: fletgoRegularText,
                      fontFamily: fletgoFontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.order.pickUpInstructions,
                  style: TextStyle(
                      color: fletgoDarkGrey,
                      fontSize: fletgoRegularText,
                      fontFamily: fletgoFontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: fletgoPadding * 2),
                Text(
                  'Hasta: ' + widget.order.to.description,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: fletgoRegularText,
                      fontFamily: fletgoFontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.order.dropOffInstructions,
                  style: TextStyle(
                      color: fletgoDarkGrey,
                      fontSize: fletgoRegularText,
                      fontFamily: fletgoFontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildCharacteristicsVehicle() =>
      Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, fletgoPadding, 10, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(fletgoPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
//                Text(
//                  'Ocupa enfriamiento: ${widget.order.package.enfriamiento}',
//                  style: TextStyle(
//                      fontWeight: FontWeight.normal,
//                      fontSize: fletgoRegularText,
//                      fontFamily: fletgoFontFamily),
//                  overflow: TextOverflow.ellipsis,
//                ),
//                SizedBox(height: fletgoPadding),
                Text(
                  'Tamaño: ${widget.order.package.size}',
                  style: TextStyle(
                      fontSize: fletgoRegularText,
                      fontFamily: fletgoFontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: fletgoPadding),
                Text(
                  'Peso: ${widget.order.package.weight} Kg',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: fletgoRegularText,
                      fontFamily: fletgoFontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
//                SizedBox(height: fletgoPadding),
//                Text(
//                  'Tipo Vehículo: ${widget.order.package.vehicleType} ',
//                  style: TextStyle(
//                      fontSize: fletgoRegularText,
//                      fontFamily: fletgoFontFamily),
//                  overflow: TextOverflow.ellipsis,
//                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildPricingSummary() =>
      Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, fletgoPadding, 10, 0),
        child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              padding: EdgeInsets.all(fletgoPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    widget.order.typeTravel,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: fletgoRegularText,
                        fontFamily: fletgoFontFamily),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Tarifa: " + widget.paymentInfo.amount.toString().substring(0, widget.paymentInfo.amount.toString().indexOf('.')) + '.' + widget.paymentInfo.amount.toString().substring(widget.paymentInfo.amount.length - 2, widget.paymentInfo.amount.length) + ' ' + widget.paymentInfo.currency.toString(),
                    style: TextStyle(
                        color: fletgoDarkGrey,
                        fontWeight: FontWeight.normal,
                        fontSize: fletgoRegularText,
                        fontFamily: fletgoFontFamily),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: fletgoPadding * 2),
//                  Row(
//                    children: <Widget> [
                      Text(
                        "Distancia: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: fletgoRegularText,
                            fontFamily: fletgoFontFamily),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.order.kmDistance.toString().substring(0, widget.order.kmDistance.toString().indexOf('.') + 3) + ' KM',
                        style: TextStyle(
                            color: fletgoDarkGrey,
                            fontWeight: FontWeight.normal,
                            fontSize: fletgoRegularText,
                            fontFamily: fletgoFontFamily),
                        overflow: TextOverflow.ellipsis,
                      ),
//                    ],
//                  ),
//                  Row(
//                    children: <Widget> [
//                      Text(
//                        "Precio de viaje: ",
//                        textAlign: TextAlign.left,
//                        style: TextStyle(
//                            color: Colors.black,
//                            fontSize: fletgoRegularText,
//                            fontFamily: fletgoFontFamily),
//                        overflow: TextOverflow.ellipsis,
//                      ),
//                      Text(
//                        widget.paymentInfo.amount.toString().substring(0, widget.order.tarifa.toString().indexOf('.')) + '.' + widget.order.tarifa.toString().substring(widget.order.tarifa.length - 2, widget.order.tarifa.length),
//                        style: TextStyle(
//                            color: fletgoDarkGrey,
//                            fontWeight: FontWeight.normal,
//                            fontSize: fletgoRegularText,
//                            fontFamily: fletgoFontFamily),
//                        overflow: TextOverflow.ellipsis,
//                      ),
//                    ],
//                  ),
                ],
              ),
            )
        ),
      );

  Widget _buildImage() =>
      Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, fletgoPadding, 10, 0),
        child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              padding: EdgeInsets.all(fletgoPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
//              scrollDirection: Axis.vertical,
//                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    widget.order.typeTravel,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: fletgoRegularText,
                        fontFamily: fletgoFontFamily),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: fletgoPadding * 2),
                  Image.file(widget.order.package.image,width: 70, height: 70,)
                ],
              ),
            )
        ),
      );

  void _sendOrder(Order order, infoPayment paymentInfo) async {

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      Firestore _db = Firestore.instance;
      final _auth = FirebaseAuth.instance;
      final newUser = await _auth.currentUser();
      String orderId;
      String uuidUser = newUser.uid.toString();

      List<File> _images = [];

      _images.add(widget.order.package.image);

      final uuidu = infoUser(
          uuidUser: uuidUser
      );

      await _db
          .collection('users')
          .document(uuidu.uuidUser)
          .collection('orders')
          .add({
//        'addPickUpInstructions': order.pickUpInstructions,
//        'addDropOffInstructions': order.dropOffInstructions,
        'addType': order.typeTravel,
        'addDate': DateTime.now().toString(),
//        'addMainDropOff': order.from.mainText,
//        'addMainPickUp': order.to.mainText,
        'addStatus': 'Iniciado',
        'addFletGoMessage': '',
        'addFletGoerMessage': '',
        'addDistance': order.kmDistance,
        'detailPickUpAddress': {
          'description': order.from.description,
          'mainText': order.from.mainText,
          'secondaryText': order.from.secondaryText,
          'gPlaceId': order.from.gPlaceId,
          'gId': order.from.gId,
          'details': {
            'name': order.detailspick.name,
            'date': order.detailspick.date,
            'hour1': order.detailspick.hour1,
            'hour2': order.detailspick.hour2,
            'instructions': order.detailspick.description,
          }
        },
        'detailDropOffAddress': {
          'description': order.to.description,
          'mainText': order.to.mainText,
          'secondaryText': order.to.secondaryText,
          'gPlaceId': order.to.gPlaceId,
          'gId': order.to.gId,
          'details': {
            'name': widget.order.detailsdrop.name,
            'contacto': widget.order.detailsdrop.phoneContact,
            'instructions': widget.order.detailsdrop.description,
          }
        },
        'detailPackage': {
          'weight': order.package.weight,
          'size': order.package.size,
//          'isUrgent': order.package.isUrgent,
        },
      // ignore: missing_return
      }).then((value) {
        orderId = value.documentID;
      });

      if(widget.order.package.image!=null) {
        DocumentReference sightingRef = _db.collection('users').document(uuidu.uuidUser).collection('orders').document(orderId);
        await saveImages(_images, sightingRef);
      }

      await _db
          .collection('activeOrders')
          .add({
        'orderId': orderId,
        'customerId': uuidu.uuidUser,
        'cost': paymentInfo.amount,
        'type': widget.order.typeTravel,
        'from': widget.order.from.mainText,
        'to': widget.order.to.mainText,
        'date': DateTime.now().toString(),
      });

      Navigator.push(context,MaterialPageRoute(builder: (context) => HomePAYPage(widget.paymentInfo, orderId)));

    }
    on Exception catch (onError) {
      Navigator.push(context,MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Excepcion: agregar orden')));
      //ErrorsPage(onError.toString(),'Excepcion: agregar orden');
    }
    catch (onError) {

      Navigator.push(context,MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Error general: agregar orden')));
      //ErrorsPage(onError.toString(),'Error general: agregar orden');
    }
  }

  Future<void> saveImages(List<File> _images, DocumentReference ref) async {

    _images.forEach((image) async {
      try {
        String imageURL = await uploadFile(image, ref.path.toString());
        ref.updateData({"addimageURL": FieldValue.arrayUnion([imageURL])});
      }
      catch (onError){
        Navigator.push(context,MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Guardar imagen')));
//        ErrorsPage(onError.toString(),'Guardar imagen');
      }
    });
  }

  Future<String> uploadFile(File _image,String pathFBStorage) async {
    try {
      StorageReference storageReference = FirebaseStorage.instance.ref().child(pathFBStorage + '/imageOrder');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      String returnURL;
      await storageReference.getDownloadURL().then((fileURL) {
        returnURL = fileURL;
      });
      return returnURL;
    }
    catch (onError) {
      Navigator.push(context,MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Cargar imagen')));
//      ErrorsPage(onError.toString(),'Cargar imagen');
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