import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/src/bloc/authentication_bloc/bloc.dart';
import 'package:fletgo_user_app/src/repository/user_repository.dart';
import 'package:fletgo_user_app/src/bloc/simple_bloc_delegate.dart';
import 'package:fletgo_user_app/src/ui/login/login_screen.dart';
import 'package:fletgo_user_app/src/ui/splash_screen.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final UserRepository userRepository = UserRepository();

  runApp(
      BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted()),
        child: Login(userRepository: userRepository),
      )
  );
}

class First extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    main();
    throw UnimplementedError();
  }
}

class Login extends StatelessWidget {

  final UserRepository _userRepository;

  Login({Key key, @required UserRepository userRepository})
      : assert (userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }
          if (state is Authenticated) {
            return MapPage();
          }
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository,);
          }
          return Container();
        },
      ),
    );
  }

}