import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/utils/strings.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/src/bloc/register_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';

class RegisterSuccessPage extends StatefulWidget {

  final user dataUser;
  RegisterSuccessPage({Key key, @required this.dataUser}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterSuccessPageState(dataUser: dataUser);
}

class _RegisterSuccessPageState extends State<RegisterSuccessPage> {

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && !state.isSubmitting;
  }

  user dataUser;

  // ignore: unused_element
  _RegisterSuccessPageState({Key key, @required this.dataUser});

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
                "¡Usuario registrado!",
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

                  final _auth = FirebaseAuth.instance;
                  final newUser = await _auth.createUserWithEmailAndPassword(email: dataUser.userMail, password: dataUser.userPass);
                  final Firestore _db = Firestore.instance;

                  DocumentReference ref = _db.collection('users').document(newUser.user.uid);

                  ref.setData({
                    //User Information
                    'uid': newUser.user.uid,
                    'userLastSeen': DateTime.now(),
                    'userEmail': newUser.user.email,
                    'userName': dataUser.userName + ' ' + dataUser.userLastName,
                    'userNumber': dataUser.userPhoneNumber,
                  }, merge: true);

                  final userInfo = infoUser(
                    uuidUser: newUser.user.uid,
                  );

                  if (newUser != null) {
                    Navigator.push(context,
                      MaterialPageRoute(
                    builder: (context) => MapPage()),
                    );
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
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title:' + string),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
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