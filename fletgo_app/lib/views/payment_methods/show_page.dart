import 'package:fletgo_user_app/widgets/default_text_field.dart';
import 'package:flutter/material.dart';

class PaymentMethodsShowPage extends StatefulWidget {
  @override
  _PaymentMethodsShowPageState createState() => _PaymentMethodsShowPageState();
}

class _PaymentMethodsShowPageState extends State<PaymentMethodsShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mastercard", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          Icon(Icons.done)
        ],
//        elevation: 0.6, // TODO: Check if better elevation
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            DefaultTextField(
              labelText: "Número de Tarjeta",
              hintText: "**** **** **** 3190",
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Flexible(
                  child: DefaultTextField(
                    labelText: "Fecha de Exp.",
                    hintText: "00/00",
                  ),
                ),
                SizedBox(width: 10.0),
                Flexible(
                  child: DefaultTextField(
                    labelText: "CVV",
                    hintText: "123",
                  ),
                )
              ],
            )
          ],
        )
      ),
    );
  }

}