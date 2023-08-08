import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fletgo_user_app/src/bloc/register_bloc/bloc.dart';
import 'package:fletgo_user_app/src/bloc/authentication_bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fletgo_user_app/views/socios/registerCarInformation.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerConfirm = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();

  RegisterBloc _registerBloc;

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
        // Si estado es submitting
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
        // Si estado es success
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
            .add(LoggedIn());
          Navigator.of(context).pop();
        }
        // Si estado es failure
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
                    textCapitalization: TextCapitalization.words,
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
                    textCapitalization: TextCapitalization.words,
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
                  //CAMPOS OPCIONALES
                  // Un textForm para password
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                        labelText: 'Contraseña'
                    ),
                    obscureText: true,
                    autocorrect: false,
                    validator: (_){
                      return !state.isPasswordValid ? 'Formato incorrecto': null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordControllerConfirm,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Confirma la contraseña'
                    ),
                    obscureText: _obscureText,
                    autocorrect: false,
                    validator: (_){
                      return !state.isPasswordValid ? 'Formato incorrecto': null;
                    },
                  ),
                  FlatButton(
                      onPressed: _toggle,
                      child: Text(_obscureText ? "Mostrar" : "Ocultar")
                  ),
                  SizedBox(height: fletgoPadding * 3),
                  // Un button
                  PrimaryButton(
                    text: "Siguiente",
                    height: fletgoButtonHeight,
                    width: double.infinity,
                    onPressed:() {

                      if (_passwordController.text==_passwordControllerConfirm.text) {
                        if (_emailController.text.length > 0 && _passwordController.text.length > 0 && _nameController.text.length > 0 && _apellidoController.text.length > 0 && _phoneController.text.length > 0) {
                          final dataUser = user(
                            userMail: _emailController.text,
                            userPass: _passwordController.text,
                            userName: _nameController.text,
                            userLastName: _apellidoController.text,
                            userPhoneNumber: _phoneController.text,

                          );

                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  RegisterCarInformationPage(
                                      dataUser: dataUser)));
                        }
                        else {
                          _showMyDialog(
                              'Debes llenar la información obligatoria para continuar con el registro');
                        }
                      }
                      else {
                        _showMyDialog('Las contraseñas no coinciden');
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
