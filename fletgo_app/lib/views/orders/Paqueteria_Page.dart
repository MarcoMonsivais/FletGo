import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/views/orders/order_summary_page.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class PaqueteriaPage extends StatefulWidget {
  PaqueteriaPage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _PaqueteriaPageState();
}

class _PaqueteriaPageState extends State<PaqueteriaPage> {

  final TextEditingController eCtrl = new TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _size1 = TextEditingController();
  final TextEditingController _size2 = TextEditingController();
  final TextEditingController _size3 = TextEditingController();
  final TextEditingController _vehicleType = TextEditingController();
//  final TextEditingController _urgente = TextEditingController();
  bool checkedValue = false;
  List<String> litems = [];
  File _image;
  bool countImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: fletgoPrimary,
          title: Text("Descripción del paquete",
          style: TextStyle(fontFamily: 'Poppins',fontSize:16)),
          leading: BackButton(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () async {

                try {
                  await Firestore.instance
                      .collection('conf')
                      .document('costs')
                      .get()
                      .then((val) {
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
                    widget.order.package.size =
                        _size1.text + 'x' + _size2.text + 'x' + _size3.text + ' cms';
                    widget.order.package.weight = double.parse(_weight.text);
                    widget.order.package.vehicleType = _vehicleType.text;
//                    widget.order.package.isUrgent = _urgente.text;
                    widget.order.package.image = _image;
                    widget.order.tarifa = val.data[widget.order.typeTravel];

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            OrderSummaryPage(widget.order, paymentInfo)));
                  });
                }
                catch(onError) {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Paqueteria')));
//                  ErrorsPage(onError.toString(),'Paqueteria');
                }
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
                "Indique la descrición del paquete a enviar",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              Divider(
                  color: Colors.black
              ),
              _uploadImage(),
              Text(
                "Tamaño Paquete (cm)",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              Row(
                children: <Widget>[
                  Expanded(child:
                      TextField(
                        controller: _size1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'ancho',
                        ),
                      ),
                  ),
                  Text(
                    " x ",
                    style: TextStyle(fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
                  ),
                  Expanded(child:
                    TextField(
                      controller: _size2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
                        labelText: 'largo',
                      ),
                  ),
                  ),
                  Text(
                    " x ",
                    style: TextStyle(fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
                  ),
                  Expanded(child:
                      TextField(
                    controller: _size3,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(),
                      labelText: 'alto',
                    ),
                  ),
                  ),
                ],
              ),
              SizedBox(height: fletgoPadding * 2),
              Text(
                "Peso Paquete",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              SizedBox(height: fletgoPadding * 2),
              TextField(
                controller: _weight,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Kg',
                ),
              ),
//              SizedBox(height: fletgoPadding * 2),
//              Row(
//                children: <Widget>[
//                  Expanded(child: Text(
//                      "¿Envío urgente?",
//                      style: TextStyle(
//                      fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
//                    ),
//                  ),
//                  Expanded(child:
//                      CheckboxListTile(
//                        title: Text("Si"),
//                        value: checkedValue,
//                        onChanged: (newValue) {
//                          setState(() {
//                            checkedValue = newValue;
//                            widget.order.package.isUrgent = checkedValue.toString();
//                          });
//                        },
//                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
//                      )
//                  ),
//                ]
//              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadImage() {
    if(countImage == false) {
      return Container(child:
        Row(
            children: <Widget>[
              Expanded(child:
                Text(
                  "Cargar imagen",
                  style: TextStyle(
                      fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
                ),
              ),
              Expanded(child:
                TextButton(
                  child: Icon(
                    Icons.photo_album,
                    size: 40,
                    color: fletgoPrimary,
                  ),
                  onPressed: () async {
                    try {
                      countImage = true;
                      _image = getImage(true) as File;
                    }
                    catch (onError) {
                      ErrorsPage(
                          onError.toString(), 'Agregar Imagen desde Galeria');
                    }
                  },
                ),
              ),
              Text(
                " ó ",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              Expanded(child:
                TextButton(
                  child: Icon(
                    Icons.add_a_photo,
                    size: 40,
                    color: fletgoPrimary,
                  ),
                  onPressed: () async {
                        try {
                          countImage = true;
                          _image = getImage(false) as File;
                        }
                        catch (onError) {
                          ErrorsPage(
                              onError.toString(),
                              'Agregar Imagen desde camara');
                        }
                    },
                ),
              ),
              SizedBox(height: fletgoPadding * 2),
            ]
        ),
      );
    } else {
      //Agregar otra imagen
      return Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget> [
            Text(
              "Imagen Cargada",
              style: TextStyle(
                  fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
            ),
            SizedBox(height: fletgoPadding * 2),
            Image.file(_image,width: 90, height: 90,)
          ],
        )
      );
    }
  }

  Future<File> getImage(bool gallery) async {

    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;

    if(gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,);
    }
    else{
      pickedFile = await picker.getImage(
        source: ImageSource.camera,);
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // Use if you only need a single picture
        _showMyDialog('Imagen cargada exitosamente');
        return _image;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _showMyDialog(string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('FletGo App:'),
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
