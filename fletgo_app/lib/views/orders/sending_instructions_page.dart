import 'package:fletgo_user_app/models/address.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/orders/drop_off_instructions_page.dart';
import 'package:fletgo_user_app/widgets/default_text_field.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../utils/brand.dart';

class SendingInstructionsPage extends StatefulWidget {
  SendingInstructionsPage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _SendingInstructionsPageState();
}

class _SendingInstructionsPageState extends State<SendingInstructionsPage> {

  final TextEditingController _instructionsTextController = new TextEditingController();
  final TextEditingController _nameinstructionsTextController = new TextEditingController();
  final TextEditingController _dateinstructionsTextController = new TextEditingController();
  final TextEditingController _descriptioninstructionsTextController = new TextEditingController();
  final TextEditingController _hour1instructionsTextController = new TextEditingController();
  final TextEditingController _hour2instructionsTextController = new TextEditingController();

  bool valueradio = false;
  int selectedRadioTile;
  int selectedRadio;

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
              try {
                if (_instructionsTextController.text != ''||selectedRadioTile>0) {

                  widget.order.pickUpInstructions = _instructionsTextController.text;
                  widget.order.detailspick = new Details(
                    name: _nameinstructionsTextController.text,
                    date: _dateinstructionsTextController.text,
                    description: _instructionsTextController.text,
                    hour1: _hour1instructionsTextController.text,
                    hour2: _hour2instructionsTextController.text,
                  );

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DropOffInstructionsPage(widget.order)));
                } else {
                  _showMyDialog('Porfavor llena la información faltante.');
                }
              }
              catch (onError) {
                print(onError.toString());
//                ErrorsPage(onError.toString(),'SendinegInstructions');
                Navigator.push(context, MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'SendinegInstructions')));
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
              Image(image: AssetImage("assets/punto_partida.png"), height: 100,),
              SizedBox(height: fletgoPadding),
              Text(
                "Utilizaremos las siguientes indicaciones para recoger el paquete en: \n${widget.order.from.mainText}",
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
                        autocorrect: true,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        onEditingComplete: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: fletgoPadding * 1.5),
              Row(
                children: [
                  Flexible(
                    child: Center(
                      child:
                      Container(
                        height: 40,
                        width: 170,
                        child: RadioListTile(
                          title: Text("Programar"),
                          value: 1,
                          groupValue: selectedRadioTile,
                          autofocus: true,
//                          activeColor: Colors.red,
                          selected: valueradio,
                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setSelectedRadioTile(val);
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Center(
                      child:
                      Container(
                          height: 40,
                          width: 1200,
                          child: RadioListTile(
                            title: Text("FletGoYa"),
                            value: 2,
                            groupValue: selectedRadioTile,
//                            activeColor: Colors.red,
                            selected: valueradio,
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setSelectedRadioTile(val);
                            },
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: fletgoPadding * 1.5),
              _programar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _programar () {
//    if(selectedRadioTile==1) {
    switch(selectedRadioTile){
      case 1:
      return Container(
        padding: EdgeInsets.all(fletgoPadding),
        color: Colors.white,
        child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Fecha          ',
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
                        controller: _dateinstructionsTextController,
                        autocorrect: true,
                        keyboardType: TextInputType.datetime,
                        textCapitalization: TextCapitalization.sentences,
                        onEditingComplete: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        inputFormatters: [LengthLimitingTextInputFormatter(10),],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'DD/MM/YYYY'
                        ),

                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: fletgoPadding * 1.5),
              Text(
                'Hora para recoger el paquete (formato 24hrs)',
                textAlign: TextAlign.left,
                style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,),
              ),
              SizedBox(height: fletgoPadding * 1.5),
              Row(
                children: [
                  Flexible(
                    child: Center(
                      child:
                      Container(
                        height: 40,
                        width: 120,
                        child: TextFormField(
                          controller: _hour1instructionsTextController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'hora incial'
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text('-'),
                  Flexible(
                    child: Center(
                      child:
                      Container(
                        height: 40,
                        width: 120,
                        child: TextFormField(
                          controller: _hour2instructionsTextController,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'hora final'
                          ),
                        ),
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
              TextField(
                maxLines: 5,
                controller: _instructionsTextController,
                autocorrect: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                onEditingComplete: (){
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ]
        ),
      );
      break;
//    } else {
      case 2:
      return Container(
        padding: EdgeInsets.all(fletgoPadding),
        color: Colors.white,
        child: ListView (
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              Text('Un FletGoer atenderá tu paquete con alta prioridad.'),
              SizedBox(height: fletgoPadding * 1.5),
              Text(
                "Comentarios extra",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              TextField(
                maxLines: 5,
                controller: _instructionsTextController,
                autocorrect: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                onEditingComplete: (){
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              ]
        ),
      );
      break;
      default:
        return Text('Selecciona una de las opciones para recoger tu pedido');
        break;
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    TextEditingController _date = new TextEditingController();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(text: formatter.format(picked));
      });
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

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }
}
