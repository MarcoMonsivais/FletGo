import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/main.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:fletgo_user_app/widgets/default_text_field.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class FastSupportPage extends StatefulWidget {

  FastSupportPage();

  @override
  State<StatefulWidget> createState() => _FastSupportPageState();
}

class _FastSupportPageState extends State<FastSupportPage> {

  TextEditingController _MessageController = TextEditingController();
  TextEditingController _NombreController = TextEditingController();
  TextEditingController _ContactoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(fletgoPadding),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: fletgoPadding * 3),
                Image(
                  image: AssetImage("assets/code1.png"),
                  height: 100,
                ),
                SizedBox(height: fletgoPadding),
                Text(
                  "¡Contacta con FletGo Soporte!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: fletgoFontFamily,
                      fontSize: fletgoRegularText * 1.2,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: fletgoPadding),
                Row(
                  children: [
                    Text(
                      "Nombre:       ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: fletgoFontFamily,
                          fontSize: fletgoRegularText),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _NombreController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: fletgoPadding),
                Row(
                  children: [
                    Text(
                      "Contacto:     ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: fletgoFontFamily,
                          fontSize: fletgoRegularText),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _ContactoController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: fletgoPadding),
                Row(
                  children: [
                    Text(
                      "Mensaje:       ",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: fletgoRegularText,
                          fontFamily: fletgoFontFamily),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _MessageController,
                        autocorrect: true,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: fletgoPadding * 3),
                PrimaryButton(
                  text: "ENTENDIDO",
                  height: fletgoButtonHeight,
                  width: double.infinity,
                  onPressed: () async {
                    try {
                      Firestore _db = Firestore.instance;
                      await _db.collection('FastSupportSocios').add({
                        'date': DateTime.now().toString(),
                        'message': _MessageController.text.toString(),
                        'nombre': _NombreController.text.toString(),
                        'contacto': _ContactoController.text.toString(),
                      });

                      await _showMyDialog(
                          'Hemos recibido tu reporte. Un agente FletGo te contactará tan pronto como nos sea posible.');

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    } catch (onError) {
                      print(onError.toString());
                    }
                  },
                ),
              ]
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
        backgroundColor: fletgoPrimary,
        tooltip: 'Regresar',
        child: Icon(Icons.arrow_back_rounded),
      ),
    );
  }

  Future<void> _showMyDialog(string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('FletGo App'),
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
