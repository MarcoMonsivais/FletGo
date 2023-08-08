import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/utils/api.dart';
import 'package:fletgo_user_app/utils/brand.dart';
// import 'package:stripe_payment/stripe_payment.dart';
import 'package:fletgo_user_app/views/payment_methods/show_page.dart';

class PaymentMethodsIndexPage extends StatefulWidget {
  PaymentMethodsIndexPage(this.user);

  final FirebaseUser user;

  @override
  _PaymentMethodsIndexPageState createState() =>
      _PaymentMethodsIndexPageState();
}

class _PaymentMethodsIndexPageState extends State<PaymentMethodsIndexPage> {

  final Firestore _db = Firestore.instance;
  final List<String> entries = <String>['1111', '2222', '4444'];

  @override
  void initState() {
    super.initState();

    // StripePayment.setOptions(StripeOptions(publishableKey: STRIPE_PK));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: fletgoPrimary,
          centerTitle: true,
          title: Text("Métodos de Pago"),
          leading: BackButton(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _addCard(),
            )
          ],
        ),
        body: StreamBuilder(
            stream: _db
                .collection('stripe_customers')
                .document(widget.user.toString())
                .collection('sources')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                
                if (snapshot.data.documents.length < 1) {
                  return _zeroCardsOnboarding();
                }

                return _cardsList(snapshot.data.documents);
              } else {
                //error handling
                return _errorOnboarding();
              }
            }));
  }

  _addCard() {

//    if (widget.user == null) {
//      //todo: maybe implement handling, but a loading should be good to go
//      print("[index_page, _addCard()] widget.user is null");
//      return;
//    }

    // StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
    //     .catchError((e) {
    //   print('ERROR ${e.toString()}');
    // }).then((paymentMethod) {
    //
    //   _db
    //       .collection('stripe_customers')
    //       .document(widget.user.uid)
    //       .collection('tokens')
    //       .document()
    //       .setData({'tokenId': paymentMethod.id});
    // });

  }

  Widget _cardsList(List<DocumentSnapshot> documents) {
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: documents.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Image.asset('assets/card.png', width: 35.0),
          title: Text('*** ${documents[index]['last4']}'),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentMethodsShowPage())),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _zeroCardsOnboarding() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/credit_card.png"),
            height: 200,
          ),
          SizedBox(height: 10),
          Text(
            "No hay tarjetas agregadas",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
          Text(
            "Haz click en el icono de + para agregar una tarjeta",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }

  Widget _errorOnboarding() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Image(
//            image: AssetImage("assets/error.png"),
//            height: 200,
//          ),
          SizedBox(height: 10),
          Text(
            "Cargando tarjetas",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
//          Text(
//            "Revisa que los datos sean correctos e inténtalo de nuevo",
//            textAlign: TextAlign.center,
//            style: TextStyle(
//                fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
//          ),
        ],
      ),
    );
  }

}
