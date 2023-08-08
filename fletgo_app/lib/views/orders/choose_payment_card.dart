import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/orders/existing-cards.dart';
import 'package:fletgo_user_app/views/orders/order_success_page.dart';
import 'package:flutter/material.dart';
import 'package:fletgo_user_app/views/payment_methods/payment-services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';

class HomePAYPage extends StatefulWidget {
  HomePAYPage(this.paymentInfo,this.orderId);
  final infoPayment paymentInfo;
  final String orderId;

  @override
  HomePAYPageState createState() => HomePAYPageState();
}

class HomePAYPageState extends State<HomePAYPage> {

  onItemPress(BuildContext context, int index) async {
    switch(index) {
      case 0:
        payViaNewCard(context, widget.paymentInfo, widget.orderId);
        break;
//      case 1:
//        //_showMyDialog('Estamos trabajando en esta actualización, ¡Esperala pronto!');
//         Navigator.push(context,MaterialPageRoute(builder: (context) => ExistingCardsPage(widget.paymentInfo)));
//        break;
    }
  }

  payViaNewCard(BuildContext context,infoPayment paymentInfo,String orderId) async {
try {
  ProgressDialog dialog = new ProgressDialog(context);
  dialog.style(
      message: 'Cargando información...'
  );
  await dialog.show();
  var response = await StripeService.payWithNewCard(
      widget.paymentInfo,
      widget.orderId
  );
  await dialog.hide();
  Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        duration: new Duration(
            milliseconds: response.success == true ? 1200 : 3000),
      )
  );

  Navigator.push(
      context, MaterialPageRoute(builder: (context) => OrderSuccessPage()));
}
catch(onError){

  Navigator.push(context,MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Error de pago')));
//  ErrorsPage(onError.toString(),'Error de pago');
}
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
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fletgoPrimary,
        title: Text('Elige tu método de pago'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch(index) {
                case 0:
                  icon = Icon(Icons.add_circle, color: fletgoPrimary);
                  text = Text('Pagar con una nueva tarjeta');
                  break;
//                case 1:
//                  icon = Icon(Icons.credit_card, color: fletgoPrimary);
//                  text = Text('Usar una tarjeta ya registrada (PROXIMAMENTE)');
//                  break;
              }

              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: theme.primaryColor,
            ),
            itemCount: 2
        ),
      ),
    );;
  }
}