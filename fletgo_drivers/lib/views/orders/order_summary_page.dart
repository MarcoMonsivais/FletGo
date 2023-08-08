import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/orders/order_success_page.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class OrderSummaryPage extends StatefulWidget {
  OrderSummaryPage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {

  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: fletgoPrimary,
        centerTitle: true,
        leading: BackButton(),
        title: Text("Resumen de compra",
            style:
            TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              _buildOrderSummary(),
              _buildCharacteristicsVehicle(),
              _buildPricingSummary(),
              SizedBox(height: fletgoPadding),
              PrimaryButton(
                text: "REALIZAR ORDEN",
                width: MediaQuery.of(context).size.width - (fletgoPadding * 2),
                height: fletgoButtonHeight,
                onPressed: () => _sendOrder(widget.order),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() => Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(10, fletgoPadding, 10, 0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(fletgoPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.order.from.description,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: fletgoRegularText,
                  fontFamily: fletgoFontFamily),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.order.pickUpInstructions,
              style: TextStyle(
                  color: fletgoDarkGrey,
                  fontSize: fletgoRegularText,
                  fontFamily: fletgoFontFamily),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: fletgoPadding * 2),
            Text(
              widget.order.to.description,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: fletgoRegularText,
                  fontFamily: fletgoFontFamily),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.order.dropOffInstructions,
              style: TextStyle(
                  color: fletgoDarkGrey,
                  fontSize: fletgoRegularText,
                  fontFamily: fletgoFontFamily),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildCharacteristicsVehicle() => Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(10, fletgoPadding, 10, 0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(fletgoPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Ocupa enfriamiento: ${widget.order.package.enfriamiento}',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: fletgoRegularText,
                  fontFamily: fletgoFontFamily),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: fletgoPadding),
            Text(
              'Tamaño: ${widget.order.package.size} Mts',
              style: TextStyle(
                  fontSize: fletgoRegularText,
                  fontFamily: fletgoFontFamily),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: fletgoPadding),
            Text(
              'Peso: ${widget.order.package.weight} Kg',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: fletgoRegularText,
                  fontFamily: fletgoFontFamily),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: fletgoPadding),
            Text(
              'Tipo Vehículo: ${widget.order.package.vehicleType} ',
              style: TextStyle(
                  fontSize: fletgoRegularText,
                  fontFamily: fletgoFontFamily),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildPricingSummary() => Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(10, fletgoPadding, 10, 0),
    child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: EdgeInsets.all(fletgoPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Distancia",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: fletgoRegularText,
                    fontFamily: fletgoFontFamily),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "FETCHING_FROM_GOOGLE",
                style: TextStyle(
                    color: fletgoDarkGrey,
                    fontWeight: FontWeight.normal,
                    fontSize: fletgoRegularText,
                    fontFamily: fletgoFontFamily),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: fletgoPadding * 2),
              Text(
                "Distancia",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: fletgoRegularText,
                    fontFamily: fletgoFontFamily),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "MISSING_RATE",
                style: TextStyle(
                    color: fletgoDarkGrey,
                    fontWeight: FontWeight.normal,
                    fontSize: fletgoRegularText,
                    fontFamily: fletgoFontFamily),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )),
  );

  void _sendOrder(Order order) async {

    String text_mail;

    text_mail =
    'Un usuario ha solicitado un viaje de FletGo.\n'
        'Conoce aquí los detalles de la orden: \n \n'
        'Fecha: ${DateTime.now()}\n'
        'Origen: ' + order.to.description + '\n'
        'Destino: ' + order.from.description + '\n'
        '--------------------------------------------------------------- \n'
        'Instrucciones para recoger: ' + order.pickUpInstructions + '\n'
        'Instrucciones para entregar: ' + order.dropOffInstructions + '\n'
        '--------------------------------------------------------------- \n'
        'Información del paquete \n\n'
        'Enfriamiento: ' + order.package.enfriamiento + '\n'
        'Tamaño: ' + order.package.size.toString() + '\n'
        'Peso: ' + order.package.weight.toString() + '\n'
        'Tipo de vehículo: ' + order.package.vehicleType + '\n';

    try {

      mailing(text_mail);

      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => OrderSuccessPage(widget.order)),ModalRoute.withName('/map'));

    }
    on Exception catch (ex) {
      _showMyDialog(ex);
    }
    catch (error){
      _showMyDialog(error);
    }

  }

  mailing(String text_mail) async {

      String username = 'fletgodev@gmail.com';
      String password = 'fletgopass123';

      final smtpServer = gmail(username, password);
      final message = Message()
        ..from = Address(username, 'FletGo')
//        ..recipients.add('tobias_021195@hotmail.com')
//        ..ccRecipients.addAll(['tobias_021195@hotmail.com','contacto@mingdevelopment.com'])
//        ..bccRecipients.add(Address('bccAddress@example.com'))
        ..bccRecipients.addAll(['tobias_021195@hotmail.com','contacto@mingdevelopment.com'])
        ..subject = 'FletGo ¡Nuevo viaje disponible!: ${DateTime.now()}'
        ..text = text_mail;
//        ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.' + e.toString() + ' y ' + e.problems.toString());
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }

      var connection = PersistentConnection(smtpServer);
      //await connection.send(message);
      await connection.close();

    }

  Future<void> _showMyDialog(string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title:' + string),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
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
