//import 'package:flutter/widgets.dart';
//import 'package:flutter/material.dart';
//import 'package:fletgo_user_app/widgets/secondary_button.dart';
//
//class RegisterPageViewModel {
//  BuildContext context;
//
//  RegisterPageViewModel({
//    this.context
//  });
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Image(image: AssetImage("assets/logo_red.png"), height: 200,),
//            Container(
//              margin: EdgeInsets.all(10.0),
//              child: SecondaryButton(
//                height: 60.0,
//                text: "Registrar",
//                width: MediaQuery
//                    .of(context)
//                    .size
//                    .width * 0.90,
//                //onPressed: () => RegisterPageViewModel(),
//              ),
//            ),
//            Container(
//              margin: EdgeInsets.all(10.0),
//              child: SecondaryButton(
//                height: 60.0,
//                text: "INICIAR CON GOOGLE",
//                width: MediaQuery
//                    .of(context)
//                    .size
//                    .width * 0.90,
//                //onPressed: () => authService.googleSignIn(),
//              ),
//            ),
//
//          ],
//        ),
//      ),
//    );
//  }
//}