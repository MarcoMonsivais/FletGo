import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/packages/packageDetails.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/brand.dart';

class seeRoutePage extends StatefulWidget {

  seeRoutePage(this.uuidUser,this.routeId);

  String uuidUser, routeId;

  @override
  State<StatefulWidget> createState() => _seeRoutePageState();
}

class _seeRoutePageState extends State<seeRoutePage> {

  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detalles de ruta", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: fletgoPrimary,
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child:
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
                    FutureBuilder(
                      future: _db.collection('socios').document(widget.uuidUser).collection('Routes').document(widget.routeId).get(),
                      // ignore: missing_return
                      builder: (context, snapshot) {

                        DocumentSnapshot ds = snapshot.data;

                        String origen_ciudad, origen_fecha, origen_hora;
                        String destino_ciudad, destino_fecha, destino_hora;

                        Map<dynamic, dynamic> mapOrigen = ds.data['origen'];
                        origen_ciudad = mapOrigen['ciudad'];
                        origen_fecha = mapOrigen['fecha'];
                        origen_hora = mapOrigen['hora'];

                        Map<dynamic, dynamic> mapDestino = ds.data['destino'];
                        destino_ciudad = mapDestino['ciudad'];
                        destino_fecha = mapDestino['fecha'];
                        destino_hora = mapDestino['hora'];

                        try {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Origen',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    height: 2.5,
                                  ),
                                ),
                                SizedBox(height: fletgoPadding,),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child:
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          origen_ciudad,
                                          style: TextStyle(
                                              fontSize: fletgoRegularText,
                                              fontFamily: fletgoFontFamily),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child:
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          origen_fecha,
                                          style: TextStyle(
                                            color: Colors.grey,
                                              fontSize: fletgoRegularText * 0.7,
                                              fontFamily: fletgoFontFamily),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child:
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          origen_hora,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: fletgoRegularText * 0.7,
                                              fontFamily: fletgoFontFamily),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: fletgoPadding,),
                                Divider(height: 5,thickness: 5,),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('Destino',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      height: 2.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: fletgoPadding,),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child:
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          destino_ciudad,
                                          style: TextStyle(
                                              fontSize: fletgoRegularText,
                                              fontFamily: fletgoFontFamily),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child:
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          destino_fecha,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: fletgoRegularText * 0.7,
                                              fontFamily: fletgoFontFamily),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child:
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          destino_hora,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: fletgoRegularText * 0.7,
                                              fontFamily: fletgoFontFamily),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: fletgoPadding,),
                                Divider(height: 5,thickness: 5,),
                                Row(children: [
                                  Text('Aceptar pedidos hasta ',
                                    style: TextStyle(
                                      fontFamily: fletgoFontFamily,
                                      fontSize: 12.0,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    ds.data['adddia'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: fletgoPrimary,
                                        fontSize: 12.0,
                                        fontFamily: fletgoFontFamily),
                                  ),
                                  Text(
                                    ' dias ',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: fletgoFontFamily),
                                  ),
                                  Text(
                                    ds.data['addhora'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: fletgoPrimary,
                                        fontSize: 12.0,
                                        fontFamily: fletgoFontFamily),
                                  ),
                                  Text(
                                    ' horas',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: fletgoFontFamily),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child:
                                    Text(
                                      ' antes de la fecha de salida*',
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: fletgoFontFamily,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                                ),

                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child:
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
                                            StreamBuilder(
                                              stream: _db.collection('socios').document(widget.uuidUser).collection('Routes').document(widget.routeId).collection('packages').snapshots(),
                                              // ignore: missing_return
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {

                                                  if (snapshot.data.documents.length < 1) {
                                                    return _noOrdersOnboarding();
                                                  }

                                                  for (var i = 0; i < snapshot.data.documents.length; ++i) {
                                                    try {

                                                      return ListView.builder(
                                                          itemCount: snapshot.data.documents.length,
                                                          scrollDirection: Axis.vertical,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemBuilder: (context, index) {

                                                            DocumentSnapshot ds = snapshot.data.documents[index];

                                                            return Card(
                                                              child: ListTile(
                                                                onTap: (){
                                                                  Navigator.push(context,MaterialPageRoute(builder: (context) => PackagesPage(widget.uuidUser,widget.routeId,ds.documentID)));
                                                                },
                                                                leading: Icon(Icons.backpack, ),
                                                                title: Row(
                                                                  children: <Widget>[
                                                                    Flexible(
                                                                        flex: 3,
                                                                        child: Text(
                                                                            ds['nombre'],
                                                                            overflow: TextOverflow.ellipsis)),
                                                                  ],
                                                                ),
                                                                subtitle: Row(
                                                                  children: <Widget>[
//                                                                    Icon(Icons.date_range, color: Colors.black54, size: 15),
//                                                                    SizedBox(width: 5.0),
                                                                    Text(ds['date'])
                                                                  ],
                                                                ),
                                                                trailing: PrimaryButton(text: 'Aceptar', height: 30, onPressed: () {
                                                                  print('HOLA');
                                                                },),
                                                              ),
                                                            );
                                                          });

                                                    }
                                                    catch(onError){
                                                      Navigator.push(context, MaterialPageRoute( builder: (context) => ErrorsPage(onError.toString(),'Construcción de orden')));
                                                    }
                                                  }
                                                } else if (snapshot.hasError) {
                                                  return _ordersErrorOnboarding();
                                                } else {
                                                  return Container(
                                                    alignment: Alignment.center,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            ),
                                          //Otros
                                          ]
                                        ),
                                      ]
                                  ),
                                ),

                              ]
                            )
                        );
                        }
                        catch (onError) {
                          return Container(
                            child: Text(onError.toString()),
                          );
//                              Navigator.push(context, MaterialPage( builder: (context) => ErrorsPage(onError.toString(),'Construcción de orden')));
                        }
                      }
                    ),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }

  _noOrdersOnboarding() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/no_data.png"),
            height: 200,
          ),
          SizedBox(height: 10),
          Text(
            "Sin paquetes registrados",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          Center(
            child: Text(
              "Aún no hay paquetes registrados para este viaje",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins'),
            ),
          )
        ],
      ),
    );
  }

  _ordersErrorOnboarding() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/error.png"),
            height: 200,
          ),
          SizedBox(height: 10),
          Text(
            "Ha ocurrido un error",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          Center(
            child: Text(
              "Inténtalo de nuevo más tarde",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins'),
            ),
          )
        ],
      ),
    );
  }

}
