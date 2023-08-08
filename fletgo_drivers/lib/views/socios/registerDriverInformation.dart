//import 'dart:html';

import 'dart:io';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fletgo_user_app/src/ui/register/register_success_page.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter/material.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';

class RegisterDriverInformationPage extends StatefulWidget {

  final user dataUser;
  final car dataCar;
  RegisterDriverInformationPage({Key key, @required this.dataUser, @required this.dataCar}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterDriverInformationPageState(dataUser: dataUser,dataCar: dataCar);

}

class _RegisterDriverInformationPageState extends State<RegisterDriverInformationPage> {

  user dataUser;
  car dataCar;
  // ignore: unused_element
  _RegisterDriverInformationPageState({Key key, @required this.dataUser,@required this.dataCar});

  bool checkedValue = false;
  List<String> litems = [];

  File _INE;
  bool countIne = false;

  File _DOMICILIO;
  bool countDomicilio = false;

  File _SELFIE;
  bool countSelfie = false;

  File _LICENSE;
  bool countLicense = false;

  File _SECURE;
  bool countSecure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: fletgoPrimary,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                SizedBox(height: fletgoPadding * 3),
                Text(
                  "Información del conductor",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: fletgoFontFamily, fontSize: fletgoRegularText, fontWeight: FontWeight.bold),
                ),
                Divider(height: 10,color: fletgoPrimary),
                _uploadImage(_INE,1,countIne,'INE'),
                Divider(height: 10,color: fletgoPrimary),
                _uploadImage(_LICENSE,2,countLicense,'Licencia'),
                Divider(height: 10,color: fletgoPrimary),
                _uploadImage(_DOMICILIO,3,countDomicilio,'Comp. de domicilio'),
                Divider(height: 10,color: fletgoPrimary),
                _uploadImage(_SELFIE,4,countSelfie,'Selfie'),
                Divider(height: 10,color: fletgoPrimary),
                _uploadImage(_SECURE,5,countSecure,'Cons. Seguro'),
                SizedBox(height: fletgoPadding * 3),
                PrimaryButton(
                  text: "Siguiente",
                  height: fletgoButtonHeight,
                  width: double.infinity,
                  onPressed: () {

                    // print(_INE.toString().length);
                    // print(_DOMICILIO.toString().length);
                    // print(_LICENSE.toString().length);
                    // print(_SECURE.toString().length);
                    // print(_SELFIE.toString().length);

                    if(
                        _INE.toString().length>4&&
                        _DOMICILIO.toString().length>4&&
                        _LICENSE.toString().length>4&&
                        _SECURE.toString().length>4&&
                        _SELFIE.toString().length>4
                    ) {

                      final dataDriver = driver(
                        selfie: _SELFIE,
                        INE: _INE,
                        domicilio: _DOMICILIO,
                        license: _LICENSE,
                        seguro: _SECURE
                      );

                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              RegisterSuccessPage(dataUser: dataUser,
                                  dataCar: dataCar,
                                  dataDriver: dataDriver)));
                    }
                    else
                      {
                        _showMyDialog('Carga las imagenes faltantes. En caso de no contar con todos los documentos, carga una imagen vacía y acutalizala en cuanto puedas.');
                      }
                  },
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _uploadImage(File _img, int op, bool countIMG, String hint) {

    if(countIMG == false) {
      return Container(
        child:
        Row(
            children: <Widget>[
              Expanded(
                child:
                Text(
                  "Cargar " + hint,
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
                      switch(op){
                        case 1:
                          _INE = getImage(true,op) as File;
                          countIne = true;
                          break;
                        case 2:
                          _LICENSE = getImage(true,op) as File;
                          countLicense = true;
                          break;
                        case 3:
                          _DOMICILIO = getImage(true,op) as File;
                          countDomicilio = true;
                          break;
                        case 4:
                          _SELFIE = getImage(true,op) as File;
                          countSelfie = true;
                          break;
                        case 5:
                          _SECURE = getImage(true,op) as File;
                          countSecure = true;
                          break;
                      }
                    }
                    catch (onError) {
                      print(onError.toString());
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
                      switch(op){
                        case 1:
                          countIne = true;
                          _INE = getImage(false,op) as File;
                          break;
                        case 2:
                          countLicense = true;
                          _LICENSE = getImage(false,op) as File;
                          break;
                        case 3:
                          countDomicilio = true;
                          _DOMICILIO = getImage(false,op) as File;
                          break;
                        case 4:
                          countSelfie = true;
                          _SELFIE = getImage(false,op) as File;
                          break;
                        case 5:
                          countSecure = true;
                          _SECURE = getImage(false,op) as File;
                          break;
                      }
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
    }
    else {

      switch(op) {
        case 1:
          return Container(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Imagen Cargada",
                    style: TextStyle(
                        fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
                  ),
                  SizedBox(height: fletgoPadding * 2),
                  Image.file(_INE, width: 90, height: 90,)
                ],
              )
          );
          break;
        case 2:
          return Container(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Imagen Cargada",
                  style: TextStyle(
                      fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
                ),
                SizedBox(height: fletgoPadding * 2),
                Image.file(_LICENSE, width: 90, height: 90,)
              ],
            )
          );
          break;
        case 3:
          return Container(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Imagen Cargada",
                    style: TextStyle(
                        fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
                  ),
                  SizedBox(height: fletgoPadding * 2),
                  Image.file(_DOMICILIO, width: 90, height: 90,)
                ],
              )
          );
          break;
        case 4:
          return Container(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Imagen Cargada",
                    style: TextStyle(
                        fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
                  ),
                  SizedBox(height: fletgoPadding * 2),
                  Image.file(_SELFIE, width: 90, height: 90,)
                ],
              )
          );
          break;
        case 5:
          return Container(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Imagen Cargada",
                    style: TextStyle(
                        fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
                  ),
                  SizedBox(height: fletgoPadding * 2),
                  Image.file(_SECURE, width: 90, height: 90,)
                ],
              )
          );
          break;
      }
    }

  }

  Future<File> getImage(bool gallery,int op) async {

    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;

    if(gallery) {
      pickedFile = await picker.getImage(source: ImageSource.gallery,);
    }
    else{
      pickedFile = await picker.getImage(source: ImageSource.camera,);
    }

    setState(() {
      if (pickedFile != null) {

        switch(op){
          case 1:
            _INE = File(pickedFile.path);
            _showMyDialog('Imagen cargada exitosamente');
            countIne = true;
            return _INE;
            break;
          case 2:
            _LICENSE = File(pickedFile.path);
            _showMyDialog('Imagen cargada exitosamente');
            countLicense = true;
            return _LICENSE;
            break;
          case 3:
            _DOMICILIO = File(pickedFile.path);
            _showMyDialog('Imagen cargada exitosamente');
            countDomicilio = true;
            return _DOMICILIO;
            break;
          case 4:
            _SELFIE = File(pickedFile.path);
            _showMyDialog('Imagen cargada exitosamente');
            countSelfie = true;
            return _SELFIE;
            break;
          case 5:
            _SECURE = File(pickedFile.path);
            _showMyDialog('Imagen cargada exitosamente');
            countSecure = true;
            return _SECURE;
            break;
        }

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