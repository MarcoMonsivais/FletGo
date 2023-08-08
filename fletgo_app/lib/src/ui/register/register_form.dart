import 'package:fletgo_user_app/src/ui/register/register_success_page.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fletgo_user_app/src/bloc/register_bloc/bloc.dart';
import 'package:fletgo_user_app/src/bloc/authentication_bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  bool checkedvalue = false;

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  
  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {

        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Registrando'),
                    CircularProgressIndicator()
                  ],
                ),
              )
            );
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
            .add(LoggedIn());
          Navigator.of(context).pop();
        }

        if (state.isFailure) {
          Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Registro fallido'),
                  Icon(Icons.error)
                ],
              ),
              backgroundColor: Colors.red,
            )
          );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Text(
                    "Información de contacto",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: fletgoFontFamily, fontSize: fletgoRegularText * 0.85),
                  ),
                  SizedBox(height: fletgoPadding * 3),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Correo',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_){
                      return !state.isEmailValid? 'Formato incorrecto' : null;
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_box),
                      labelText: 'Nombre(s)',
                    ),
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    validator: (_){
                      return !state.isEmailValid? 'Formato incorrecto' : null;
                    },
                  ),
                  TextFormField(
                    controller: _apellidoController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_box),
                      labelText: 'Apellidos',
                    ),
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    validator: (_){
                      return !state.isEmailValid? 'Formato incorrecto' : null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      labelText: 'Número de telefono',
                    ),
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                    validator: (_){
                      return !state.isEmailValid? 'Formato incorrecto' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                        labelText: 'Contraseña'
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_){
                      return !state.isPasswordValid ? 'Formato incorrecto': null;
                    },
                  ),
                  SizedBox(height: fletgoPadding * 3),
                  GestureDetector(
                    onTap: () {
                      _launchURL('https://www.fletgo.com/terminos-y-condiciones.html');
                    },
                    child: Center(
                      child: Text(
                        'Conoce aquí los terminos y condiciones aqui',
                        style: TextStyle(fontSize: 10,color: Colors.red),
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ),
                  SizedBox(height: fletgoPadding * 3),
                  CheckboxListTile(
                    title: Text("Aceptas los terminos y condiciones"),
                    value: checkedvalue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedvalue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),
                  SizedBox(height: fletgoPadding * 3),
                  // Un button
                  PrimaryButton(
                    text: "Siguiente",
                    height: fletgoButtonHeight,
                    width: double.infinity,
                    onPressed:() {

                      if((_emailController.text.length>0&&_passwordController.text.length>0&&_phoneController.text.length>0&&checkedvalue==true))
                      {
                        final dataUser = user(
                          userMail: _emailController.text,
                          userPass: _passwordController.text,
                          userName: _nameController.text,
                          userLastName: _apellidoController.text,
                          userPhoneNumber: _phoneController.text,

                        );

                        Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterSuccessPage(dataUser: dataUser)));
                      } else {
                        _showMyDialog("Ingresa los datos faltantes");
                      }

                    },
                  )
                ],
              ),
            ),
          );
        },
      )
    );
  }

  _launchURL(String page) async {
    String url = page;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No puede abrirse el URL $url';
    }
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text)
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text)
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
