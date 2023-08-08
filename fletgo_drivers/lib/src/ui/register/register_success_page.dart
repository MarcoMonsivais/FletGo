import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/src/util/ErrorsPageRegister.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/utils/strings.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fletgo_user_app/src/bloc/register_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';

class RegisterSuccessPage extends StatefulWidget {

  final user dataUser;
  final car dataCar;
  final driver dataDriver;
  RegisterSuccessPage({Key key, @required this.dataUser, @required this.dataCar, @required this.dataDriver}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterSuccessPageState(dataUser: dataUser, dataCar: dataCar, dataDriver: dataDriver);
}

class _RegisterSuccessPageState extends State<RegisterSuccessPage> {

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && !state.isSubmitting;
  }

  user dataUser;
  car dataCar;
  driver dataDriver;

  // ignore: unused_element
  _RegisterSuccessPageState({Key key, @required this.dataUser, @required this.dataCar, @required this.dataDriver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fletgoPrimary,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(fletgoPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image(
                image: AssetImage("assets/order_success.png"), height: 250,),
              SizedBox(height: fletgoPadding),
              Text(
                registerSuccessfulText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fletgoFontFamily,
                    fontSize: fletgoRegularText * 1.2,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: fletgoPadding),
              Text(
                "Gracias por registrarte con FletGo.\nTu información será verificada y te notificaremos al haber terminado el proceso de registro.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),
              ),
              SizedBox(height: fletgoPadding * 3),
              PrimaryButton(
                text: "ENTENDIDO",
                height: fletgoButtonHeight,
                width: double.infinity,
                onPressed: () async {

                  try {
                    final _auth = FirebaseAuth.instance;
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: dataUser.userMail, password: dataUser.userPass);
                    final Firestore _db = Firestore.instance;
                    String driverId;

                    List<File> _images = [];

                    _images.add(widget.dataDriver.INE);
                    _images.add(widget.dataDriver.license);
                    _images.add(widget.dataDriver.domicilio);
                    _images.add(widget.dataDriver.selfie);
                    _images.add(widget.dataDriver.seguro);

                    DocumentReference ref = _db.collection('socios').document(
                        newUser.user.uid);

                    ref.setData({
                      //User Information
                      'uid': newUser.user.uid,
                      'userLastSeen': DateTime.now(),
                      'userEmail': newUser.user.email,
                      'userName': dataUser.userName + ' ' +
                          dataUser.userLastName,
                      'userNumber': dataUser.userPhoneNumber,
                      'currentState': 'inactivo',
                    }, merge: true);

                    _db.collection('socios')
                        .document(newUser.user.uid)
                        .collection('Car')
                        .add({
                      //Car Information
                      'carColor': dataCar.carColor,
                      'car': dataCar.carMar,
                      'carModel': dataCar.carModel,
                      'carYear': dataCar.carYear,
//                    'carId': dataCar.carId,
//                     'carSecure': dataCar.carSecure,
//                     'carNumberSecure': dataCar.carSecureNumber,
                    });

                    await _db.collection('socios').document(newUser.user.uid)
                        .collection('Driver').add({
                      //ID driver
//                    'dataDriverId': dataDriver.driverId,
//                    'driverLicense': dataDriver.driverId,
//                    'driverBirth': dataDriver.driverBirth,
//                    'driverHealthTest': dataDriver.driverHealthTest,
                    })
                        .then((value) {
                      driverId = value.documentID;
                    });

                    try {
                      DocumentReference sightingRef = _db.collection('socios')
                          .document(newUser.user.uid).collection('Driver')
                          .document(driverId);
                      await saveImages(_images, sightingRef);
                    }
                    catch (onError) {
                      print('FATAL ERROR: ' + onError.toString());
                    }
                    final userInfo = infoUser(
                      uuidUser: newUser.user.uid,
                    );

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MapPage()));
                  } catch(onError){

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ErrorsPageRegister(onError.toString(), 'Registro de usuario')));

                    _showMyDialog(onError.toString());
                  }

                  }
              ),
              SizedBox(height: fletgoPadding * 3),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveImages(List<File> _images, DocumentReference ref) async {

    int count = 1;

    _images.forEach((image) async {
      try {
        count++;
        String imageURL = await uploadFile(image, ref.path.toString(),'File' + count.toString());
        ref.updateData({"addURL": FieldValue.arrayUnion([imageURL])});
      }
      catch (onError){
        print('ErrorSave: ' + onError.toString());
//        ErrorsPage(onError.toString(),'Guardar imagen');
      }
    });
  }

  Future<String> uploadFile(File _image,String pathFBStorage,String nameImage) async {
    try {

      StorageReference storageReference = FirebaseStorage.instance.ref().child(pathFBStorage + '/' + nameImage);
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      String returnURL;
      await storageReference.getDownloadURL().then((fileURL) {
        returnURL = fileURL;
      });
      return returnURL;
    }
    catch (onError) {
      print('ErrorUpload: ' + onError.toString());
//      ErrorsPage(onError.toString(),'Cargar imagen');
    }
  }

  mailing(String text_mail) async {

    String username = 'fletgodev@gmail.com';
    String password = 'fletgopass123';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'FletGo')
      ..bccRecipients.addAll(['tobias_021195@hotmail.com','contacto@mingdevelopment.com'])
      ..subject = 'FletGo - Nuevo Socio: ${DateTime.now()}'
      ..text = text_mail;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      _showMyDialog('Message not sent.' + e.toString() + ' y ' + e.problems.toString());
      print('Message not sent.' + e.toString() + ' y ' + e.problems.toString());
      for (var p in e.problems) {
        _showMyDialog('Problem: ${p.code}: ${p.msg}');
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

    var connection = PersistentConnection(smtpServer);

    await connection.close();

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