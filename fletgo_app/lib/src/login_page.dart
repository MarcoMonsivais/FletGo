import 'package:fletgo_user_app/src/bloc/authentication_bloc/bloc.dart';
import 'package:fletgo_user_app/src/repository/user_repository.dart';
import 'package:fletgo_user_app/src/bloc/simple_bloc_delegate.dart';
import 'package:fletgo_user_app/src/ui/login/login_screen.dart';
import 'package:fletgo_user_app/src/ui/splash_screen.dart';
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

//            Future<String> username = _userRepository.getUser();

//            if() {
//              _showMyDialog ( 'Registra tu usuario como usuario', context );
//              return LoginScreen(userRepository: _userRepository,);
//            } else {
              return MapPage ( );
//            }
          }
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository,);
          }
          return Container();
        },
      ),
    );
  }

  Future<void> _showMyDialog(string,context) async {
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