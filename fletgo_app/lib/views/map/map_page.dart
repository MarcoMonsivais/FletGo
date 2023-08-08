import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/models/address.dart';
import 'package:fletgo_user_app/models/order.dart';
import 'package:fletgo_user_app/models/profile.dart';
import 'package:fletgo_user_app/src/util/ErrorsPage.dart';
import 'package:fletgo_user_app/utils/api.dart';
import 'package:fletgo_user_app/utils/brand.dart';
import 'package:fletgo_user_app/views/orders/choose_order_type.dart';
import 'package:fletgo_user_app/views/pedidos/pedidos.dart';
import 'package:fletgo_user_app/views/rutas/routes.dart';
import 'package:fletgo_user_app/widgets/address_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fletgo_user_app/src/util/globlaVariables.dart';
import 'package:fletgo_user_app/src/bloc/authentication_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fletgo_user_app/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fletgo_user_app/src/util/librarys_Variables.dart' as Globals;

class MapPage extends StatefulWidget {

  MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();

}

class MapPageState extends State<MapPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Address _fromAddress = Address();
  final Address _toAddress = Address();
  final Order _currentOrder = Order();
  final infoUser userInfo = infoUser();

  String uuidUserPass;

  Profile _profile;
  FirebaseUser _user;
  double kmDistance;

  // Google maps variables
  final Completer<GoogleMapController> _controller = new Completer();
  final CameraPosition _initialCamera = CameraPosition(
      target: LatLng(25.6714, -100.309), zoom: 11
  );
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  final GoogleMapPolyline _googleMapPolyline = new GoogleMapPolyline(apiKey: GOOGLE_CLOUD_API_KEY);

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection('conf')
        .document('keys')
        .get()
        .then((val) {
      Globals.welcomeMessage = val.data['welcomeMessage'];
      Globals.currentVersion = val.data['currentVersion'];
    });

    if (Globals.wmessage==false) {
      Future.delayed(
        Duration(seconds: 2),
            () {
          Widget okButton = FlatButton(
            child: Text("Aceptar"),
            onPressed: () {
              Globals.wmessage = true;
              Navigator.pop(context);
            },
          );
          AlertDialog alert = AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    Globals.welcomeMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
            actions: [
              okButton,
            ],
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _initialCamera,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: _polyline,
              markers: _markers,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  fletgoPadding, fletgoPadding, fletgoPadding, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildAddressInput(_fromAddress, "¿De dónde envías?", "1"),
                  SizedBox(height: fletgoPadding),
                  _buildAddressInput(_toAddress, "¿En dónde se recibe?", "2"),
                  SizedBox(height: fletgoPadding),
                  PrimaryButton(
                    height: fletgoButtonHeight,
                    width: MediaQuery.of(context).size.width,
                    text: "INICIAR MI ORDEN",
                    onPressed: () {

                      if(_fromAddress.gPlaceId.toString()!='null'&&_toAddress.gPlaceId.toString()!='null'&&kmDistance.toString()!='null')
                      {
                        if(kmDistance<=50.0) {
                          _currentOrder.user = _user;
                          _currentOrder.from = _fromAddress;
                          _currentOrder.from.gPlaceId = _fromAddress.gPlaceId;
                          _currentOrder.from.gId = _fromAddress.gId;
                          _currentOrder.to = _toAddress;
                          _currentOrder.to.gPlaceId = _toAddress.gPlaceId;
                          _currentOrder.to.gId = _toAddress.gId;
                          _currentOrder.kmDistance = kmDistance.toString();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChooseTypePage(_currentOrder)));
                        }
                        else {
                          _showMyDialog('La distancia es mayor a la permita. Selecciona una distancia menor.');
                        }
                      } else {
                        _showMyDialog('Intenta de nuevo e ingresa la ubicación faltante');
                      }

                    },
                  )
                ],
              ),
            ),
            _buildSidebarButton()
          ],
        ),
      ),
      drawer: _sidebarDrawer(),
    );
  }

//Boton de barra lateral
  Widget _buildSidebarButton() {
    return Container(
      margin: EdgeInsets.all(fletgoPadding),
      alignment: Alignment.topLeft,
      child: FloatingActionButton(
        backgroundColor: fletgoPrimary,
        mini: true,
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
        child: Icon(Icons.menu),
      ),
    );
  }

  Widget _buildAddressInput(Address address, String hintText, String markerId) {
    return GestureDetector(
      child: Container(
          child: address.description == null
              ? AddressBox(hintText)
              : AddressBox(address.mainText)),
      onTap: () async {
        final Prediction p = await PlacesAutocomplete.show(

            mode: Mode.fullscreen,
            context: context,
            apiKey: GOOGLE_CLOUD_API_KEY,
            hint: "Ingresa la dirección");

        if (p != null)
        {
          List<Placemark> placemark = await Geolocator().placemarkFromAddress(p.description);
          List<LatLng> polyline;

          setState(() {
            address.description = p.description;
            address.mainText = p.structuredFormatting.mainText;
            address.secondaryText = p.structuredFormatting.secondaryText;
            address.gPlaceId = p.placeId;
            address.gId = p.id;

            _markers.add(Marker(
              visible: true,
              markerId: MarkerId(markerId),
              position: LatLng(placemark[0].position.latitude, placemark[0].position.longitude),
              infoWindow: InfoWindow(
                title: p.structuredFormatting.mainText,
                snippet: hintText,
              ),
            ));
          });

          if (_fromAddress.gPlaceId != null && _toAddress.gPlaceId != null)
          {
            polyline = await _googleMapPolyline.getPolylineCoordinatesWithAddress(
              origin: _fromAddress.description,
              destination: _toAddress.description,
              mode: RouteMode.driving);

            _goToMidPoint(polyline[0], polyline[1]);

            double totalDistance = 0.0;

            for (int i = 0; i < polyline.length - 1; i++) {
              totalDistance += _coordinateDistance(
                polyline[i].latitude,
                polyline[i].longitude,
                polyline[i + 1].latitude,
                polyline[i + 1].longitude,
              );
            }

            setState(() {
              if (polyline != null) {
                _polyline.add(Polyline(
                  polylineId: PolylineId(markerId),
                  visible: true,
                  geodesic: true,
                  points: polyline,
                  color: fletgoPrimary,
                ));

                try {
                  String _placeDistance = totalDistance.toStringAsFixed(2);
                  kmDistance = totalDistance;
                  print('DISTANCE: $_placeDistance km');
                  print('DISTANCE: ' + kmDistance.toString() + 'km');
                }
                catch (onError){
                  ErrorsPage(onError.toString(), 'Distancia');
                }
              }
            });
          }
        }
      },
    );
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _goToCurrentUserLocation() async {
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 30)));
  }

  Future<infoUser> GetUuid () async {

      final _auth = FirebaseAuth.instance;
      final newUser = await _auth.currentUser();

      String uuidUser = newUser.uid.toString();

      final uuidu = infoUser(
          uuidUser: uuidUser
      );

      uuidUserPass = uuidu.uuidUser;

      print('Usuario ID: ' + uuidu.uuidUser);

  }

  Future<void> _goToMidPoint(LatLng position1, LatLng position2) async {
    final double middleLat = (position1.latitude + position2.latitude) / 2;
    final double middleLng = (position1.longitude + position2.longitude) / 2;
    print(middleLat);
    print(middleLng);
    final LatLng middlePosition = LatLng(middleLat, middleLng);

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: middlePosition, zoom: 15)));
  }

  //Barra lateral
  Widget _sidebarDrawer() => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white54,
              ),
              child: _profile != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            _profile.photoURL,
                            width: 60,
                          ),
                        ),
                        SizedBox(height: fletgoPadding),
                        Text(
                          _profile.displayName,
                          style: TextStyle(
                              fontFamily: fletgoFontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _user.displayName,
                          style: TextStyle(
                              fontFamily: fletgoFontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
                  : Text("¡Bienvenido a Fletgo!"), //todo: add default image
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet_outlined),
              title: Text('Acerca de nosotros'),
              onTap: () => _launchURL('https://facebook.com/fletgo'),
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: Text('Conocenos'),
              onTap: () => _launchURL('https://fletgo.com'),
            ),
            // ListTile(
            //   leading: Icon(Icons.airport_shuttle_outlined),
            //   title: Text('Mis rutas'),
            //   onTap: () {
            //
            //     GetUuid();
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => RoutePage(uuidUserPass)));
            //
            //   },
            // ), //Historial de viajes
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Mis pedidos'),
              onTap: () {

                GetUuid();
                Navigator.push(context, MaterialPageRoute(builder: (context) => PedidosPage(uuidUserPass)));

              },
            ), //Historial de viajes
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
            onTap: (){
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              Navigator.of(context).pushReplacementNamed('/');
            },
            )//Cerrar sesión
          ],
        ),
      );

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

_launchURL(String page) async {
  String url = page;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No puede abrirse el URL $url';
  }
}