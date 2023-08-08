import 'package:fletgo_user_app/views/payment_methods/show_page.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/utils/api.dart';
import 'package:flutter/material.dart';

//void main(FirebaseUser userTMP2) {
//
//  WidgetsFlutterBinding.ensureInitialized();
//
//  final FirebaseUser userTMP = userTMP2;
//
//  runApp(
//      PaymentMethodsIndexPage(userTMP)
//  );
//}
//
//class First extends StatelessWidget{
//
//  First(this.user,);
//
//  final FirebaseUser user;
//
//  _PaymentMethodsIndexPageState createState() => _PaymentMethodsIndexPageState();
//
//  @override
//  Widget build(BuildContext context) {
//    main(user);
//    throw UnimplementedError();
//  }
//}

class PaymentMethodsIndexPage extends StatefulWidget {
  PaymentMethodsIndexPage(this.user,);

  final infoUser user;

  @override
  _PaymentMethodsIndexPageState createState() => _PaymentMethodsIndexPageState(user);
}

class _PaymentMethodsIndexPageState extends State<PaymentMethodsIndexPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final infoUser userInfo;

  _PaymentMethodsIndexPageState(this.userInfo);

  @override
  void initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(publishableKey: STRIPE_PK));

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
        body:StreamBuilder(
            stream: _db
                .collection('users')
                .document(userInfo.uuidUser)
                .collection('payment')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print ('Uuid User:' + userInfo.uuidUser);
                if (snapshot.data.documents.length < 1) {
                  return _zeroCardsOnboarding();
                }
                return _cardsList(snapshot.data.documents);
              } else {
                //error handling
                print ('Uuid User:' + userInfo.uuidUser);
                return _errorOnboarding();
              }
            }
        )
    );
  }
}

  _addCard() async {

  try {
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .catchError((e) {
      print('ERROR ${e.toString()}');
    }).then((paymentMethod) async {

      Firestore _db = Firestore.instance;
      final _auth = FirebaseAuth.instance;
      final newUser = await _auth.currentUser();

      String uuidUser = newUser.uid.toString();

      final uuidu = infoUser(
          uuidUser: uuidUser
      );

      print('Payment. Usuario Id: ' + uuidu.uuidUser);
      print('Payment. Payment Id:' + paymentMethod.id);
      print('Payment Method:' +
          '\nid ' + paymentMethod.id.toString() +
          '\ncardId ' + paymentMethod.card.cardId.toString() +
          '\ncustomerId ' + paymentMethod.customerId.toString() +
          '\ntoken ' + paymentMethod.card.token.toString() +
          '\ncard ' + paymentMethod.card.toString() +
          '\nname card ' + paymentMethod.card.name.toString() +
          '\nnumber card ' + paymentMethod.card.number.toString() +
          '\ncvc ' + paymentMethod.card.cvc.toString() +
          '\ncountry ' + paymentMethod.card.country.toString() +
          '\nlast4number card ' + paymentMethod.card.last4.toString() +
          '\nbrand card ' + paymentMethod.card.brand.toString() +
          '\ncurency ' + paymentMethod.card.currency.toString() +
          '\nfunding ' + paymentMethod.card.funding.toString()+
          '\ncreated card ' + paymentMethod.created.toString() +
          '\ntype card ' + paymentMethod.type.toString() +
          '\nlivemode ' + paymentMethod.livemode.toString() +
          '\nbillingDetails' + paymentMethod.billingDetails.name.toString()
      );
      
      _db
          .collection('users')
          .document(uuidu.uuidUser)
          .collection('payment')
          .document()
          .setData({
            'id': paymentMethod.id,
            'tokenId': paymentMethod.card.token,
            'brand': paymentMethod.card.brand,
            'currency': paymentMethod.card.currency,
            'country': paymentMethod.billingDetails.address.country,
            'exp_mont': paymentMethod.card.expMonth,
            'exp_year': paymentMethod.card.expYear,
            'number card': paymentMethod.card.number,
            'last4': paymentMethod.card.last4,
          });

    });
  }
    on Exception catch(e){
    print(e.toString());
    }

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
