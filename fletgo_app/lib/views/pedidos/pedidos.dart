import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:fletgo_user_app/views/pedidos/pedidos_detail.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter/material.dart';

class PedidosPage extends StatefulWidget {
  PedidosPage(this.uuidUserPass);

  final String uuidUserPass;

  @override
  State<StatefulWidget> createState() => _PedidosPageState();

}

class _PedidosPageState extends State<PedidosPage> {
  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: fletgoPrimary,
          centerTitle: true,
          title: Text("Mis Pedidos"),
          leading: BackButton(color: Colors.white)),
      body: SafeArea(
        child: StreamBuilder(
          stream: _db.collection('users').document(widget.uuidUserPass).collection('orders').orderBy('addDate').snapshots(),
          // ignore: missing_return
          builder: (context, snapshot) {

            if (snapshot.hasData) {

              if (snapshot.data.documents.length < 1) {
                return _noOrdersOnboarding();
              }

              for (var i = 0; i < snapshot.data.documents.length; ++i) {
                try {

                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {

                        DocumentSnapshot ds = snapshot.data.documents[index];
                        Map<dynamic, dynamic> mapdetailPickUpAddress = ds['detailPickUpAddress'];
                        Map<dynamic, dynamic> mapdetailDropOffAddress = ds['detailDropOffAddress'];

                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => PedidosDetailPage(widget.uuidUserPass,ds.reference.documentID)));
                              },
                            leading: Icon(Icons.done, color: Colors.green),
                            title: Row(
                              children: <Widget>[
                                Flexible(
                                    flex: 5,
                                    child: Text(
                                        mapdetailPickUpAddress['mainText'],
                                        overflow: TextOverflow.ellipsis)),
                                Flexible(flex: 1, child: Icon(Icons.chevron_right)),
                                Flexible(
                                    flex: 5,
                                    child: Text(
                                        mapdetailDropOffAddress['mainText'],
                                        overflow: TextOverflow.ellipsis))
                              ],
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Icon(Icons.date_range, color: Colors.black54, size: 15),
                                SizedBox(width: 5.0),
                                Text(ds["addDate"].toString())
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  ds["addType"].toString(),
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                                Text(ds["addStatus"].toString(),)
                              ],
                            ),
                          ),
                        );
                      });

                }
                catch(onError){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Construcción de pedido')));
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

}