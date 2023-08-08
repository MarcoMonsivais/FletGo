import 'package:fletgo_user_app/models/address.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/orders/Fletes_Page.dart';
import 'package:fletgo_user_app/views/orders/Mudanza_Page.dart';
import 'package:fletgo_user_app/views/orders/Paqueteria_Page.dart';
import 'package:fletgo_user_app/views/orders/order_summary_page.dart';
import 'package:fletgo_user_app/views/orders/sending_instructions_page.dart';
import 'package:fletgo_user_app/widgets/default_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'characteristics_vehicle_page.dart';

class DropOffInstructionsPage extends StatefulWidget {
  DropOffInstructionsPage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _DropOffInstructionsPageState();
}

class _DropOffInstructionsPageState extends State<DropOffInstructionsPage> {

  final TextEditingController _instructionsTextController = TextEditingController();
  final TextEditingController _nameinstructionsTextController = TextEditingController();
  final TextEditingController _phoneContactController = TextEditingController();

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
              try {

                if (_instructionsTextController.text != '') {
                  widget.order.dropOffInstructions = _instructionsTextController.text;
                  widget.order.detailsdrop = Details(
                    name: _nameinstructionsTextController.text,
                    phoneContact: _phoneContactController.text,
                    description: _instructionsTextController.text,

                  );

                  switch (widget.order.typeTravel) {
                    case 'Flete':
//                  Navigator.push(context, MaterialPageRoute(builder: (context) => FletesPage(widget.order)));
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              CharacteristicsVehiclePage(widget.order)));
                      break;
                    case 'Mudanza':
//                  Navigator.push(context, MaterialPageRoute(builder: (context) => MudanzaPage(widget.order)));
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              CharacteristicsVehiclePage(widget.order)));
                      break;
                    case 'Paqueteria':
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PaqueteriaPage(widget.order)));
                      break;
                    case 'Perecedero':
//                  Navigator.push(context, MaterialPageRoute(builder: (context) => PerecederoPage(widget.order)));
                      break;
                  }
                } else {
                  _showMyDialog('Favor de llenar la información faltante');
                }
              }
              catch(onError) {

                Navigator.push(context, MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Drop Off Instructions')));
//                ErrorsPage(onError.toString(),'Drop Off Instructions');
              }
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
              Image(image: AssetImage("assets/punto_salida.png"), height: 100,),
              SizedBox(height: fletgoPadding),
              Text(
                "IUtilizaremos las siguientes indicaciones para entregar el paquete en:\n${widget.order.to.mainText}",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              SizedBox(height: fletgoPadding),
              Row(
                children: [
                  Text(
                    'Nombre      ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child:
                    Container(
                      height: 40,
                      child:
                      TextFormField(
                        controller: _nameinstructionsTextController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        autocorrect: false,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: fletgoPadding),
              Row(
                children: [
                  Text(
                    'Numero de contacto      ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child:
                    Container(
                      height: 40,
                      child:
                      TextFormField(
                        controller: _phoneContactController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefix: Text('+52 '),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [LengthLimitingTextInputFormatter(10),],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: fletgoPadding * 1.5),
              Text(
                "Comentarios extra",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              TextFormField(
                controller: _instructionsTextController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 5,
                decoration: InputDecoration(border: OutlineInputBorder(),),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('FletGo App:'),
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
