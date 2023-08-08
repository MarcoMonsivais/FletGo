import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/src/util/soporteRapido.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fletgo_user_app/views/map/map_page.dart';
import 'package:fletgo_user_app/widgets/secondary_button.dart';
import 'package:fletgo_user_app/src/login_page.dart';
import 'package:fletgo_user_app/src/ui/register/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fletgo_user_app/src/repository/user_repository.dart';
import 'package:fletgo_user_app/src/util/librarys_Variables.dart' as Globals;

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  _EstablishVariables();

  runApp(MyApp());
}

_launchURL(String page) async {
  String url = page;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No puede abrirse el URL $url';
  }
}

_EstablishVariables() async{
  try {
    await Firestore.instance
        .collection('conf')
        .document('keys')
        .get()
        .then((val) {
      Globals.SK_STRIPE = val.data['SK_STRIPE'];
      Globals.PK_STRIPE = val.data['PK_STRIPE'];
      Globals.STRIPE_MERCHANTID = val.data['STRIPE_MERCHANTID'];
      Globals.STRIPE_ANDROIDPAYMODE = val.data['STRIPE_ANDROIDPAYMODE'];
//      Globals.welcomeMessage = val.data['welcomeMessageSocios'];
    });
  }
  catch (onError){
    print('Error: ' + onError.toString());
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FletGo Socios',
      theme: ThemeData(
        // This is the theme of your application.
        primaryColor: Colors.red,
        primarySwatch: Colors.red,
        accentColor: Colors.blueAccent
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => MyHomePage(),//title: "inicio"
        '/map' : (context) => MapPage(),
        '/src/' : (context) => First(),
        '/ui/register/' : (context) => RegisterScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  final UserRepository _userRepository;

  MyHomePage({Key key, @required UserRepository userRepository})
        : _userRepository = userRepository,
        super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/Webp.net-resizeimage.png"), height: 250),
            Container(
              margin: EdgeInsets.all(10.0),
              child: SecondaryButton(
                  height: 45.0,
                  text: "Iniciar sesión",
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.70,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => First()));
                  }
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: SecondaryButton(
                  height: 45.0,
                  text: "Registrarme",
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.70,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(userRepository: _userRepository)));
                  }
              ),
            ),
            bottomBar()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FastSupportPage() ));
        },
        tooltip: 'Soporte',
        backgroundColor: fletgoPrimary,
        child: Icon(Icons.support_agent),
      ),
    );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 150),
          //margin: EdgeInsets.only(top: 24),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _launchURL('https://apps.apple.com/us/app/fletgo-socios/id1556389418');
                },
                child: new Text(
                  'AppStore: 2.00.07',
                  style: TextStyle(fontSize: 10,color: Colors.red),
                  textDirection: TextDirection.ltr,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://play.google.com/store/apps/details?id=com.fletgo.fletgo_drivers');
                },
                child: new Text(
                  'PlayStore: 2.00.07',
                  style: TextStyle(fontSize: 10,color: Colors.red),
                  textDirection: TextDirection.ltr,
                ),
              ),
              GestureDetector(
                onTap: () {
                  //Navigator.pushNamed(context, "/src");
                  _launchURL('https://facebook.com/fletgo');
                },
                child: new Text(
                  'Acerca de nosotros',
                  style: TextStyle(fontSize: 10,color: Colors.red),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  }
