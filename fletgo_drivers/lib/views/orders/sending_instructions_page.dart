import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/orders/drop_off_instructions_page.dart';
import 'package:fletgo_user_app/widgets/default_text_field.dart';
import 'package:flutter/material.dart';

import '../../utils/brand.dart';
import '../../utils/brand.dart';
import '../../utils/brand.dart';

class SendingInstructionsPage extends StatefulWidget {
  SendingInstructionsPage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _SendingInstructionsPageState();
}

class _SendingInstructionsPageState extends State<SendingInstructionsPage> {
  final TextEditingController _instructionsTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Punto de partida", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: fletgoPrimary,
        leading: BackButton(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              widget.order.pickUpInstructions =
                  _instructionsTextController.text;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DropOffInstructionsPage(widget.order)));
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
              Image(image: AssetImage("assets/punto_partida.png"), height: 200,),
              SizedBox(height: fletgoPadding),
              Text(
                "Indicaciones para recoger el paquete en: ${widget.order.from.mainText}",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              SizedBox(height: fletgoPadding),
              DefaultTextField(
                maxLines: 5,
                controller: _instructionsTextController,
              )
            ],
          ),
        ),
      ),
    );
  }
}
