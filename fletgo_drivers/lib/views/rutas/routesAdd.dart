import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/rutas/routes.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class RouteDetailsPage extends StatefulWidget {

  RouteDetailsPage(this.userid);

  String userid;

  @override
  State<StatefulWidget> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {

  final TextEditingController _horaOrigenEditingController = TextEditingController();
  final TextEditingController _fechaOrigenEditingController = TextEditingController();
  final TextEditingController _ciudadOrigenEditingController = TextEditingController();

  final TextEditingController _horaDestinoEditingController = TextEditingController();
  final TextEditingController _fechaDestinoEditingController = TextEditingController();
  final TextEditingController _ciudadDestinoEditingController = TextEditingController();

  final TextEditingController _diasEditingController = TextEditingController();
  final TextEditingController _horasEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Nueva ruta", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          backgroundColor: fletgoPrimary,
          leading: BackButton(),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    children: [
                      Text('Origen',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          height: 2.5,
                        ),
                      ),
                      SizedBox(height: fletgoPadding,),
                      Align(
                        alignment: Alignment.center,
                        child:
                        TextFormField(
                          controller: _ciudadOrigenEditingController,
                          textCapitalization: TextCapitalization.words,
                          autocorrect: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Ciudad'
                          ),
                        ),
                      ),
                      SizedBox(height: fletgoPadding,),
                      Row(
                        children: [
                          Expanded(
                            child:
                            TextFormField(
                              controller: _fechaOrigenEditingController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Fecha de salida'
                              ),
                            ),
                          ),
                          Expanded(
                            child:
                            TextFormField(
                              controller: _horaOrigenEditingController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Hora de salida'
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: fletgoPadding,),
                      Divider(height: 5,thickness: 5,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Destino',
                          style: TextStyle(
                            fontSize: 20.0,
                            height: 2.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: fletgoPadding,),
                      Align(
                        alignment: Alignment.center,
                        child:
                        TextFormField(
                          controller: _ciudadDestinoEditingController,
                          textCapitalization: TextCapitalization.words,
                          autocorrect: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Ciudad'
                          ),
                        ),
                      ),
                      SizedBox(height: fletgoPadding,),
                      Row(
                        children: [
                          Expanded(
                            child:
                            TextFormField(
                              controller: _fechaDestinoEditingController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Fecha de llegada'
                              ),
                            ),
                          ),
                          Expanded(
                            child:
                            TextFormField(
                              controller: _horaDestinoEditingController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Hora de llegada'
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: fletgoPadding,),
                      Divider(height: 5,thickness: 5,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Aceptar pedidos hasta',
                          style: TextStyle(
                            fontSize: 20.0,
                            height: 2.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: fletgoPadding,),
                      Row(children: [
                        Flexible(
                          flex: 1,
                          child:
                          TextFormField(
                            controller: _diasEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Días'
                            ),),
                        ),
                        Flexible(
                          flex: 1,
                          child:
                          TextFormField(
                            controller: _horasEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Horas'
                            ),
                          ),
                        ),
                      ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text('antes de la fecha de salida',
                          style: TextStyle(
                            fontSize: 20.0,
                            height: 2.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      PrimaryButton(text: 'Crear ruta', height: 40, onPressed: () async {

                        try{

                          Firestore _db = Firestore.instance;
                          final _auth = FirebaseAuth.instance;
                          final newUser = await _auth.currentUser();
                          String uuidUser = newUser.uid.toString();
                          String routeId;

                          await _db
                              .collection('socios')
                              .document(uuidUser)
                              .collection('Routes').add
                            ({
                            'adddate': DateTime.now(),
                            'addnombre': '',
                            'adddia': _diasEditingController.text,
                            'addhora': _horasEditingController.text,
                            'origen': {
                              'fecha': _fechaOrigenEditingController.text,
                              'hora': _horaOrigenEditingController.text,
                              'ciudad': _ciudadOrigenEditingController.text,
                            },
                            'destino': {
                              'fecha': _fechaDestinoEditingController.text,
                              'hora': _horaDestinoEditingController.text,
                              'ciudad': _ciudadDestinoEditingController.text,
                            },
                            }).then((value)  {

                             _db
                                .collection('activeRoutes')
                                .add({
                              'routeId': value.documentID,
                              'socioId': widget.userid,
                              'salidadia': _fechaOrigenEditingController.text,
                              'llegadadia': _fechaDestinoEditingController.text,
                              'origen': _ciudadOrigenEditingController.text,
                              'destino': _ciudadDestinoEditingController.text,
                              'date': DateTime.now().toString(),
                            });

                          });

                          await _showMyDialog('Tu ruta ha sido creada exitosamente');

                          Navigator.push(context, MaterialPageRoute( builder: (context) => RoutePage(uuidUser)));
                          
                        } catch(onError){
                          Navigator.push(context, MaterialPageRoute( builder: (context) => ErrorsPage(onError.toString(),'Construcción de nueva ruta')));
                        }

                      })
                    ],
                  ),
                ]
            )
          ]
          ),
        )
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