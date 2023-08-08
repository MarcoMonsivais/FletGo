import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 250,),
                Image.asset(
                  "assets/Ball-Loading.gif",
                  height: 250.0,
                  width: 250.0,
                ),
                Text('Cargando información...',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: fletgoRegularText,
                      fontFamily: fletgoFontFamily),
                  overflow: TextOverflow.ellipsis,),
              ]
            )
      ),
    );
  }
}