//imports: 
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fletgo_user_app/src/bloc/login_bloc/bloc.dart';
import 'package:fletgo_user_app/src/repository/user_repository.dart';
import 'package:fletgo_user_app/src/ui/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
    : assert(userRepository != null),
    _userRepository = userRepository,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(title: Text('Iniciar sesión'),backgroundColor: fletgoPrimary,),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}