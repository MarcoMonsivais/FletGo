import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/rutas/routesDetails.dart';
import 'package:fletgo_user_app/views/rutas/seeRoute.dart';
import 'package:flutter/material.dart';
import '../../utils/brand.dart';

class RoutePage extends StatefulWidget {

  RoutePage(this.uuidUser);

  String uuidUser;

  @override
  State<StatefulWidget> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {

  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mis rutas", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: fletgoPrimary,
        leading: BackButton(),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.add),
//            onPressed: () {
//              Navigator.push(context, MaterialPageRoute( builder: (context) => RouteDetailsPage(widget.uuidUser)));
//            },
//          )
//        ],
      ),
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
                    StreamBuilder(
                      stream: _db.collection('activeRoutes').snapshots(),
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
                                          Navigator.push(context,MaterialPageRoute(builder: (context) => seeRoutePage(ds['socioId'],ds['routeId'])));
                                          },
                                        leading: Icon(Icons.airport_shuttle_outlined, ),
                                        title: Row(
                                          children: <Widget>[
                                            Flexible(
                                                flex: 3,
                                                child: Text(
                                                    ds['origen'],
                                                    overflow: TextOverflow.ellipsis)),
                                            Flexible(flex: 1, child: Icon(Icons.chevron_right)),
                                            Flexible(
                                                flex: 3,
                                                child: Text(
                                                    ds['destino'],
                                                    overflow: TextOverflow.ellipsis))
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: <Widget>[
                                            Icon(Icons.date_range, color: Colors.black54, size: 15),
                                            SizedBox(width: 5.0),
                                            Text(ds['salidadia'],)
                                          ],
                                        ),
//                                        trailing: Column(
//                                          mainAxisAlignment: MainAxisAlignment.center,
//                                          crossAxisAlignment: CrossAxisAlignment.end,
//                                          children: <Widget>[
//                                            Text(
//                                              '\$120',
//                                              style: TextStyle(color: Colors.redAccent),
//                                            ),
//                                            Text('toString()',)
//                                          ],
//                                        ),
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
                  ],
                ),
              ],
            ),
          ],
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
            "Sin rutas registradas",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          Center(
            child: Text(
              "Crea una nueva ruta en el botón de arriba",
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
