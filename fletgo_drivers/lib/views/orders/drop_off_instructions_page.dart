import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/orders/order_summary_page.dart';
import 'package:fletgo_user_app/widgets/default_text_field.dart';
import 'package:flutter/material.dart';

import 'characteristics_vehicle_page.dart';

class DropOffInstructionsPage extends StatefulWidget {
  DropOffInstructionsPage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _DropOffInstructionsPageState();
}

class _DropOffInstructionsPageState extends State<DropOffInstructionsPage> {
  final TextEditingController _instructionsTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fletgoPrimary,
        centerTitle: true,
        title: Text("Punto de entrega", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        leading: BackButton(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              widget.order.dropOffInstructions =_instructionsTextController.text;
              print('pushed ${_instructionsTextController.text}');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CharacteristicsVehiclePage(widget.order)));
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
              Image(image: AssetImage("assets/punto_salida.png"), height: 200,),
              SizedBox(height: fletgoPadding),
              Text(
                "Indicaciones para entregar el paquete en: ${widget.order.to.mainText}",
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
