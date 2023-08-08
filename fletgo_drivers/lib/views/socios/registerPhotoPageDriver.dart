import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/utils/strings.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class RegisterPhotoPageDriver extends StatefulWidget {

  RegisterPhotoPageDriver();

  @override
  State<StatefulWidget> createState() => _RegisterPhotoPageDriverState();
}

class _RegisterPhotoPageDriverState extends State<RegisterPhotoPageDriver> {

  _RegisterPhotoPageDriverState();

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
              Image(image: AssetImage("assets/order_success.png"), height: 250,),
              Text(
                registerSuccessfulText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fletgoFontFamily, fontSize: fletgoRegularText * 1.2, fontWeight: FontWeight.bold),
              ),
              Text(
                "Gracias por registrarte con FletGo.\nTu información será verificada y te notificaremos al haber terminado el proceso de registro.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),
              ),
              PrimaryButton(
                text: "ENTENDIDO",
                height: fletgoButtonHeight,
                width: double.infinity,
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => MapPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}