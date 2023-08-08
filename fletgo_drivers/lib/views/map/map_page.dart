import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:fletgo_user_app/src/util/librarys_Variables.dart' as Globals;
import 'package:fletgo_user_app/src/bloc/authentication_bloc/bloc.dart';
import 'package:fletgo_user_app/views/rutas/routes.dart';
import 'package:fletgo_user_app/views/travels/travelDetails.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/models/profile.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MapPage extends StatefulWidget {

  MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();

}

class MapPageState extends State<MapPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Firestore _db = Firestore.instance;

  String imageUrl, uuidUserPass;

  @override
  initState() {
    super.initState();
    GetUuid();
    Firestore.instance
        .collection('conf')
        .document('keys')
        .get()
        .then((val) {
      Globals.welcomeMessage = val.data['welcomeMessageSocios'];
      Globals.currentVersion = val.data['currentVersionSocios'];
    });

    if (Globals.wmessage==false) {
      Future.delayed(
        Duration(seconds: 2),
            () {
          Widget okButton = FlatButton(
            child: Text("Aceptar"),
            onPressed: () {
              Globals.wmessage = true;
              Navigator.pop(context);
            },
          );
          AlertDialog alert = AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    Globals.welcomeMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
            actions: [
              okButton,
            ],
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Center(
                      child:
                      FutureBuilder<dynamic>(
                        future: _setUrl(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Image.network(imageUrl, fit: BoxFit.fill);
                          } else {
                            return CircularProgressIndicator();
                          }
                        }
                      ),
                    ),
                    Text(
                      "Tus ordenes",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    FutureBuilder(
                        future: GetUuid(),
                        builder: (context, infoUser){
                          return StreamBuilder(
                            stream: _db.collection('socios').document(uuidUserPass).collection('Orders').snapshots(),
                            // ignore: missing_return
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                if (snapshot.data.documents.length < 1) {
                                  return _noSocioOrdersOnboarding();
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
                                          IconData iconStatus;
                                          return FutureBuilder(
                                              future: _db.collection('users')
                                                  .document(ds['customerId'])
                                                  .collection('orders').document(
                                                  ds['orderId'])
                                                  .get(),
                                              // ignore: missing_return
                                              builder: (context, snapshot) {
                                                DocumentSnapshot ds2 = snapshot
                                                    .data;

                                                //MAP PAGOS
                                                String precio;
                                                try {
                                                  Map<dynamic,
                                                      dynamic> mapPayment = ds2
                                                      .data['detailPaymentInfo'];
                                                  var _listPayment = mapPayment
                                                      .values.toList();
                                                  precio = _listPayment[0];
                                                } catch (onError) {
                                                  print('Error Pagos: ' +
                                                      onError.toString());
                                                  precio = 'no pagado';
                                                }

                                                //MAP PICK UP
                                                String main_pickup;
                                                try {
                                                  Map<dynamic,
                                                      dynamic> mapdetailPickUpAddress = ds2
                                                      .data['detailPickUpAddress'];

                                                  main_pickup =
                                                  mapdetailPickUpAddress['mainText'];
                                                  main_pickup.isEmpty
                                                      ?
                                                  main_pickup = 'Sin ubicación'
                                                      : null;
                                                } catch (onError) {
                                                  print('Error PickUp: ' +
                                                      onError.toString());
                                                  main_pickup = 'Sin ubicación';
                                                }

                                                //MAP DROP OFF
                                                String main_dropoff;
                                                try {
                                                  Map<dynamic,
                                                      dynamic> mapdetailDropFFUpAddress = ds2
                                                      .data['detailDropOffAddress'];

                                                  main_dropoff =
                                                  mapdetailDropFFUpAddress['mainText'];
                                                  main_dropoff.isEmpty
                                                      ?
                                                  main_dropoff = 'No existe valor'
                                                      : null;
                                                } catch (onError) {
                                                  print('Error DropOff: ' +
                                                      onError.toString());
                                                  main_dropoff = 'Sin ubicación';
                                                }

                                                iconStatus =
                                                    assignIcon(ds2['addStatus']);

                                                return Card(
                                                  child: ListTile(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TravelDetailPage(
                                                                      ds['customerId']
                                                                          .toString(),
                                                                      ds['orderId']
                                                                          .toString(),
                                                                      ds.reference
                                                                          .documentID,
                                                                      ds2['addStatus'])));
                                                    },
                                                    leading: Icon(
                                                      //Icons.compare_arrows_outlined,
                                                        iconStatus,
                                                        color: Colors.green),
                                                    title: Row(
                                                      children: <Widget>[
                                                        Flexible(
                                                            flex: 3,
                                                            child: Text(
                                                                main_pickup,
                                                                overflow: TextOverflow
                                                                    .ellipsis)),
                                                        Flexible(flex: 1,
                                                            child: Icon(Icons
                                                                .chevron_right)),
                                                        Flexible(
                                                            flex: 3,
                                                            child: Text(
                                                                main_dropoff,
                                                                overflow: TextOverflow
                                                                    .ellipsis))
                                                      ],
                                                    ),
                                                    subtitle: Row(
                                                      children: <Widget>[
                                                        Icon(Icons.date_range,
                                                            color: Colors.black54,
                                                            size: 15),
                                                        SizedBox(width: 5.0),
                                                        Text(ds2.data["addDate"]
                                                            .toString())
                                                      ],
                                                    ),
                                                    trailing: Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .end,
                                                      children: <Widget>[
                                                        Text(
                                                          ds2.data["addType"]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent),
                                                        ),
                                                        Text(precio)
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });

                                        });

                                  }
                                  catch(onError){
                                    Navigator.push(context, MaterialPageRoute( builder: (context) => ErrorsPage(onError.toString(),'Construcción de ordenes')));
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
                          );
                        }
                      ),
                    Divider(height: 4,thickness: 5,),
                    Text(
                      "Ordenes disponibles",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    StreamBuilder(
                      stream: _db.collection('activeOrders').orderBy('date').snapshots(),
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
                                              // print(ds['customerId']);
                                              // print(ds['orderId']);
                                              // print(ds.reference.documentID);
                                              // print(ds['orderStatus']);
                                          Navigator.push(context,MaterialPageRoute(builder: (context) => TravelDetailPage(ds['customerId'].toString(),ds['orderId'].toString(),ds.reference.documentID,'aceptada')));
                                        },
                                    leading: Icon(Icons.done, color: Colors.green),
                                    title: Row(
                                      children: <Widget>[
                                        Flexible(
                                            flex: 3,
                                            child: Text(
                                                ds["from"].toString(),
                                                overflow: TextOverflow.ellipsis)),
                                        Flexible(flex: 1, child: Icon(Icons.chevron_right)),
                                        Flexible(
                                            flex: 3,
                                            child: Text(
                                                ds["to"].toString(),
                                                overflow: TextOverflow.ellipsis))
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: <Widget>[
                                        Icon(Icons.date_range, color: Colors.black54, size: 15),
                                        SizedBox(width: 5.0),
                                        Text(ds["date"].toString())
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          ds["type"].toString(),
                                          style: TextStyle(color: Colors.redAccent),
                                        ),
                                        Text(ds["cost"].toString(),)
                                      ],
                                    ),
                                  ),
                                );
                              });

                        }
                        catch(onError){
                          Navigator.push(context, MaterialPageRoute( builder: (context) => ErrorsPage(onError.toString(),'Construcción de pedido')));
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
                  ],
                ),
              ],
            ),
            _buildSidebarButton()
          ],
        ),
      ),
      drawer: _sidebarDrawer(),
    );
  }

  assignIcon(status){
    switch(status){
      case 'asignada':
        return Icons.person;
        break;
      case 'iniciada':
        return Icons.approval;
        break;
      case 'en curso':
        return Icons.compare_arrows_outlined;
        break;
    }
  }

  _setUrl() async {
    try{
      final ref = FirebaseStorage.instance.ref().child('conf').child('fletgo.jpg');
      var url = await ref.getDownloadURL();
      imageUrl = url;
      return imageUrl;
    }
    catch(onError){
      print("Error: " + onError.toString());
    }
  }

  Future<infoUser> GetUuid () async {

    final _auth = FirebaseAuth.instance;
    final newUser = await _auth.currentUser();

    String uuidUser = newUser.uid.toString();

    final uuidu = infoUser(
        uuidUser: uuidUser
    );

    uuidUserPass = uuidu.uuidUser;

    print('Usuario ID: ' + uuidu.uuidUser);

  }

  _noSocioOrdersOnboarding() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Image(
          //   image: AssetImage("assets/no_data.png"),
          //   height: 200,
          // ),
          SizedBox(height: 10),
          Text(
            "Sin ordenes activas",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          // Center(
          //   child: Text(
          //     "Cuando se termine una orden, aparecera en este apartado",
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.normal,
          //         fontFamily: 'Poppins'),
          //   ),
          // )
        ],
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
            "Sin ordenes registradas",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          Center(
            child: Text(
              "Cuando se termine una orden, aparecera en este apartado",
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

  Widget _buildSidebarButton() {
    return Container(
      margin: EdgeInsets.all(fletgoPadding),
      alignment: Alignment.topLeft,
      child: FloatingActionButton(
        backgroundColor: fletgoPrimary,
        mini: true,
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
        child: Icon(Icons.menu),
      ),
    );
  }

  Widget _sidebarDrawer() => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.white54,
          ),
          child:
          // _profile != null
              // ? Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //       ClipRRect(
              //         borderRadius: BorderRadius.circular(50.0),
              //         child: Image.network(
              //           _profile.photoURL,
              //           width: 60,
              //         ),
              //       ),
              //       SizedBox(height: fletgoPadding),
              //       Text(
              //         _profile.displayName,
              //         style: TextStyle(
              //             fontFamily: fletgoFontFamily,
              //             fontSize: 20,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.black),
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       Text(
              //         _profile.email,
              //         style: TextStyle(
              //             fontFamily: fletgoFontFamily,
              //             fontSize: 13,
              //             fontWeight: FontWeight.normal,
              //             color: Colors.black54),
              //         overflow: TextOverflow.ellipsis,
              //       )
              //   ],
              // )
              // :
          Text("¡Bienvenido a Fletgo!"), //todo: add default image
        ),
//        ListTile(
//          leading: Icon(Icons.history),
//          title: Text('Viajes'),
//          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TravelPage())),
//        ), //Historial de viajes
        ListTile(
          leading: Icon(Icons.account_balance_wallet_outlined),
          title: Text('Acerca de nosotros'),
          onTap: () => _launchURL('https://facebook.com/fletgo'),
        ),
        ListTile(
          leading: Icon(Icons.web),
          title: Text('Conocenos'),
          onTap: () => _launchURL('https://fletgo.com'),
        ),
        ListTile(
            leading: Icon(Icons.airport_shuttle_outlined),
            title: Text('Mis rutas'),
            onTap: () {

              GetUuid();

              Navigator.push(context,MaterialPageRoute(builder: (context) => RoutePage(uuidUserPass)));
            },
        ),
       ListTile(
         leading: Icon(Icons.book_online_outlined),
         title: Text('Mis viajes'),
         onTap: () => _showMyDialog('Estamos trabajando en esta sección. Contacta con FletGo para recibir detalles de tu historial de viajes fletgo@gmail.com')
//              Navigator.push(context,MaterialPageRoute(builder: (context) => MyT()));,
       ), //Historial de viajes
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Cerrar sesión'),
          onTap: () {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            Navigator.of(context).pushReplacementNamed('/');
          },
        )//Cerrar sesión
      ],
    ),
  );

  _launchURL(String page) async {
    String url = page;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No puede abrirse el URL $url';
    }
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
