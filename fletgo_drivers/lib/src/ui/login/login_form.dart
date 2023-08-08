import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/auth.dart';
import 'dart:io' show Platform;
import 'package:apple_sign_in/apple_sign_in.dart' as Apple;
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fletgo_user_app/src/bloc/login_bloc/bloc.dart';
import 'package:fletgo_user_app/src/bloc/authentication_bloc/bloc.dart';
import 'package:fletgo_user_app/src/repository/user_repository.dart';
import 'package:fletgo_user_app/src/ui/login/google_login_button.dart';
import 'package:fletgo_user_app/src/ui/login/login_button.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  // Initially password is obscure
  bool _obscureText = true;

  String _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    //AppleLogin
    if(Platform.isIOS){
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      // tres casos, tres if:
      if (state.isFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Inicio fallido'), Icon(Icons.error)],
              ),
              backgroundColor: Colors.red,
            ),
          );
      }
      if (state.isSubmitting) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Iniciando sesión... '),
                CircularProgressIndicator(),
              ],
            ),
          ));
      }
      if (state.isSuccess) {

        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(
                    'assets/Webp.net-resizeimage.png',
                    height: 200,
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Correo'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_){
                    return !state.isEmailValid? 'Formato incorrecto': null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Contraseña'
                  ),
                  obscureText: _obscureText,
                  autovalidate: true,
                  autocorrect: false,
//                  validator: (_){
//                    return !state.isPasswordValid? 'Formato incorrecto': null;
//                  },
                ),
                FlatButton(
                    onPressed: _toggle,
                    child: Text(_obscureText ? "Mostrar" : "Ocultar")
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Tres botones:
                      // LoginButton
                      LoginButton(
                        onPressed: isLoginButtonEnabled(state)
                          ? _onFormSubmitted
                          : null,
                      ),
                      // GoogleLoginButton
                      GoogleLoginButton(),SizedBox(height: fletgoButtonHeight * 0.2,),
                      Center( child: Text('ó',style: TextStyle(fontFamily: fletgoFontFamily, fontSize: fletgoRegularText),),),
                      SizedBox(height: fletgoButtonHeight * 0.2,),
                      AppleSignInButton(
                        style: Apple.ButtonStyle.whiteOutline,
                        type: ButtonType.continueButton,
                        onPressed: () async {
                          if(await AppleSignIn.isAvailable()) {
                            //Check if Apple SignIn isn available for the device or not
                          }else{
                            _showMyDialog('Tu equipo no es compatible con iOs para iniciar sesión');
                          }

                          if(await AppleSignIn.isAvailable()) {
                            final AuthorizationResult result = await
                            AppleSignIn.performRequests([
                              AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
                            ]);
                          }

                          if(await AppleSignIn.isAvailable()) {
                            final AuthorizationResult result = await AppleSignIn.performRequests([
                              AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
                            ]);
                            switch (result.status) {
                              case AuthorizationStatus.authorized:

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MapPage()));
                                print('Apple Login: ' + result.credential.user);
                                break;
                              case AuthorizationStatus.error:
                                print("Sign in failed: ${result.error.localizedDescription}");
                                break;
                              case AuthorizationStatus.cancelled:
                                print('User cancelled');
                                break;
                            }
                          }

                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {

    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text
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
