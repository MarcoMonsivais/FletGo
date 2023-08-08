import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter/material.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:fletgo_user_app/views/socios/registerDriverInformation.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';

class RegisterCarInformationPage extends StatefulWidget {
  
  final user dataUser;
  RegisterCarInformationPage({Key key, @required this.dataUser}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _RegisterCarInformationPageState(dataUser: dataUser);
  
}

class _RegisterCarInformationPageState extends State<RegisterCarInformationPage> {

  user dataUser;
  // ignore: unused_element
  _RegisterCarInformationPageState({Key key, @required this.dataUser});

  final TextEditingController _carColorController = TextEditingController();
  final TextEditingController _carController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _carYearController = TextEditingController();
  final TextEditingController _carLicenseController = TextEditingController();
  final TextEditingController _carSecureController = TextEditingController();
  final TextEditingController _carSecureNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fletgoPrimary,
      body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: fletgoPadding * 3),
                    Text(
                      "Información del vehículo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: fletgoFontFamily, fontSize: fletgoRegularText, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _carController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.directions_car_rounded),
                        labelText: 'Marca',
                      ),
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                    ),
                    TextFormField(
                      controller: _carModelController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.directions_car_rounded),
                        labelText: 'Modelo',
                      ),
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                    ),
                    TextFormField(
                      controller: _carYearController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.directions_car_rounded),
                        labelText: 'Año',
                      ),
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                    ),
                    TextFormField(
                      controller: _carColorController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.directions_car_rounded),
                        labelText: 'Color',
                      ),
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                    ),
                    //Cargar imagenes
//                    TextFormField(
//                      controller: _carLicenseController,
//                      decoration: InputDecoration(
//                          icon: Icon(Icons.camera_alt_rounded),
//                          labelText: 'Tarjeta de circulación'
//                      ),
//                      autocorrect: false,
//                    ),
//                     TextFormField(
//                       controller: _carSecureController,
//                       decoration: InputDecoration(
//                           icon: Icon(Icons.directions_car_rounded),
//                           labelText: 'Consecionaria de seguro'
//                       ),
//                       autocorrect: true,
//                       textCapitalization: TextCapitalization.words,
//                     ),
//                     TextFormField(
//                       controller: _carSecureNumberController,
//                       decoration: InputDecoration(
//                           icon: Icon(Icons.directions_car_rounded),
//                           labelText: 'Número de seguro'
//                       ),
//                       autocorrect: false,
//                     ),
                    SizedBox(height: fletgoPadding * 3),
                    PrimaryButton(
                      text: "Siguiente",
                      height: fletgoButtonHeight,
                      width: double.infinity,
                      onPressed: () {

                        if(
                        _carColorController.text.length>0&&
                        _carController.text.length>0&&
                        _carModelController.text.length>0&&
                        _carYearController.text.length>0
//                        _carLicenseController.text.length>0&&
//                         _carSecureController.text.length>0&&
//                         _carSecureNumberController.text.length>0
                        ) {

                          final dataCar = car(
                            carColor: _carColorController.text,
                            carMar: _carController.text,
                            carModel: _carModelController.text,
                            carYear: _carYearController.text,
                            carId: _carLicenseController.text,
                            // carSecure: _carSecureController.text,
                            // carSecureNumber: _carSecureNumberController.text,

                          );

                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  RegisterDriverInformationPage(
                                      dataUser: dataUser, dataCar: dataCar)));
                        } else {
                          _showMyDialog('Porfavor llena la información obligatoria.');
                        }
                      },
                    ),
                  ],
                ),
              ),
            //);
          //},
        )
    );
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