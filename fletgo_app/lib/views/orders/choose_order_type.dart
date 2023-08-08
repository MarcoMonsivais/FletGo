import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/views/orders/sending_instructions_page.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter/material.dart';

class ChooseTypePage extends StatefulWidget {
  ChooseTypePage(this.order);

  final Order order;

  @override
  State<StatefulWidget> createState() => _ChooseTypePageState();
}

class _ChooseTypePageState extends State<ChooseTypePage> {
  final TextEditingController typeTravelController =
  TextEditingController();

  double padValue = 0;

  List<Paint> paints = <Paint>[
    Paint('Flete'),
    Paint('Mudanza'),
    Paint('Paqueteria'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Tipo de viaje", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: fletgoPrimary,
        leading: BackButton(),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.arrow_forward),
//            onPressed: () {

//              print(typeTravelController.text);
//              widget.order.typeTravel = typeTravelController.text;
//              print (widget.order.typeTravel);
//
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) =>
//                          SendingInstructionsPage(widget.order)));
//            },
//          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(fletgoPadding),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Image(image: AssetImage("assets/delivery.png"), height: 200,),
              SizedBox(height: fletgoPadding),
              Text(
                "Selecciona el tipo de viaje:",
                style: TextStyle(
                    fontSize: fletgoRegularText, fontFamily: fletgoFontFamily),
              ),
              SizedBox(height: fletgoPadding),
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: List.generate(paints.length, (index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        try {
                          paints[index].selected = !paints[index].selected;
                          widget.order.typeTravel =
                              paints[index].title.toString();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SendingInstructionsPage(widget.order)));
                        }
                        catch(onError) {
                          ErrorsPage(onError.toString(),'Choose Order Type');
                        }
                      });
                    },
                    selected: paints[index].selected,
                    leading: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: Container(
                        width: 48,
                        height: 48,
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        alignment: Alignment.center,
                      ),
                    ),
                    title: Text(paints[index].title),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class Paint {
  final String title;
  bool selected = false;

  Paint(this.title);
}