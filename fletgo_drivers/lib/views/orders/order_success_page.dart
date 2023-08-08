import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/utils/strings.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class OrderSuccessPage extends StatefulWidget {
  OrderSuccessPage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
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
              SizedBox(height: fletgoPadding),
              Text(
                registerSuccessfulText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fletgoFontFamily, fontSize: fletgoRegularText * 1.2, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: fletgoPadding),
              Text(
                registerSuccessfulSubText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),
              ),
              SizedBox(height: fletgoPadding * 3),
              PrimaryButton(
                text: "ENTENDIDO",
                height: fletgoButtonHeight,
                width: double.infinity,
                onPressed: () {
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => MapPage()));
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
