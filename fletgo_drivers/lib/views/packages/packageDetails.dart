import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/utils/strings.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class PackagesPage extends StatefulWidget {
  PackagesPage(this.uuidUser,this.routeId,this.packageId);

  String uuidUser, routeId, packageId;

  @override
  State<StatefulWidget> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {

  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: fletgoPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detalles de paquete", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: fletgoPrimary,
        leading: BackButton(),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(fletgoPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              FutureBuilder(
                future: _db.collection('socios').document(widget.uuidUser).collection("Routes").document(widget.routeId).collection('packages').document(widget.packageId).get(),
                // ignore: missing_return
                builder: (context, snapshot) {

                  //DocumentSnapshot
                  DocumentSnapshot ds = snapshot.data;

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(ds['nombre']),
                      ],
                    ),
                  );
                },
              ),

              PrimaryButton(
                text: "ENTENDIDO",
                height: fletgoButtonHeight,
                width: double.infinity,
                onPressed: () {
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => MapPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
