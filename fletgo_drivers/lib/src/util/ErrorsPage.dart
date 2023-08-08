import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ErrorsPage extends StatefulWidget {

  ErrorsPage(this.messageError, this.locationError);

  final String messageError;
  final String locationError;

  @override
  State<StatefulWidget> createState() => _ErrorsPageState();
}

class _ErrorsPageState extends State<ErrorsPage> {
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
              Image(image: AssetImage("assets/code1.png"), height: 250,),
              SizedBox(height: fletgoPadding),
              Text(
                "¡Oops hubo un error!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fletgoFontFamily, fontSize: fletgoRegularText * 1.2, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: fletgoPadding),
              Text(
                "Hubo un problema con la aplicación.\nReportaremos este error con el equipo FletGo. Porfavor reinicia la app.",
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

                  Firestore _db = Firestore.instance;
                  await _db
                      .collection('errorSocios')
                      .add({
                    'date': DateTime.now().toString(),
                    'message':widget.messageError,
                    'location': widget.locationError,
                  });


                  Navigator.push(context,MaterialPageRoute(builder: (context) => MapPage()));
                },
              ),
              SizedBox(height: fletgoPadding * 3),
            ],
          ),
        ),
      ),
    );
  }
}
