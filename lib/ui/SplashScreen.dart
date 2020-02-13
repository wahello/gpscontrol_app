import 'dart:async';
import 'package:EnlistControl/ui/custom_route.dart';
import 'package:EnlistControl/ui/init_alistamiento.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:EnlistControl/pages/display/SplashScreenDisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:EnlistControl/models/users.dart';
import 'package:toast/toast.dart';
import 'package:EnlistControl/ui/login.dart';

/// SplashScreen extended from StatefulWidget
/// State
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// _SplashScreenState extended from State<SplashScreen>
/// Display content
class _SplashScreenState extends State<SplashScreen> {
<<<<<<< HEAD
=======
  final IntranetAPIUtils _api = new IntranetAPIUtils();
>>>>>>> master
  User usuario;

  /// Run async task to change view after given time
  startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, checkUserLogged);
  }

  /// Check if the user is connected, and redirect to correct home
  checkUserLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var connectivityResult = await (Connectivity().checkConnectivity());
    //prefs.remove("autolog_url");
    //prefs.setString("autolog_url", "https://intra.epitech.eu/auth-9472567ed80878ddb46ac61a97bad16e5e5bd99d");
    //prefs.setString("email", "cyril.colinet@epitech.eu");

    if (prefs.getString("user") != null) {
      print("se encontro user " + prefs.getString("user"));
<<<<<<< HEAD
      var user = prefs.getString("user");
      var pass = prefs.getString("pass");
      var idU = prefs.getString("idU");
      var nameU = prefs.getString("nameU");
      var token = prefs.getString("tel");
      var sid = prefs.getString("sid");
      var uid = prefs.getString("Uid");
      usuario = new User(int.parse(uid), user,
            pass, token);
        usuario.setSID(sid);
        usuario.setInfoU(int.parse(idU), nameU);
=======
>>>>>>> master
      //verificamos si esta conectado a internet
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        Toast.show("Se detecto: Datos moviles.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

<<<<<<< HEAD
        
        return Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => InitAlistamiento(
            data: usuario,
=======
       usuario = new User("0", prefs.getString("user"),
            "", prefs.getString("token"));
        return Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => NavigationHomeScreen(
            userData: usuario,
>>>>>>> master
          ),
        ));
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        Toast.show("Se detecto: WIFI.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

<<<<<<< HEAD
        return Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => InitAlistamiento(
            data: usuario,
=======
        usuario = new User("1", prefs.getString("user"),
            "", prefs.getString("token"));
        return Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => NavigationHomeScreen(
            userData: usuario,
>>>>>>> master
          ),
        ));
      } else {
        // not connected
<<<<<<< HEAD
        Toast.show("No estas conectado a internet.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        return Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => InitAlistamiento(
            data: usuario,
=======
        usuario = new User("offline", prefs.getString("user"),
            "", prefs.getString("token"));
        Toast.show("No estas conectado a internet.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        return Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => NavigationHomeScreen(
            userData: usuario,
>>>>>>> master
          ),
        ));
      }
    } else {
<<<<<<< HEAD
      Toast.show("Bienvenido.", context,
=======
      Toast.show("Bienvenido!.", context,
>>>>>>> master
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => new LoginScreen()));
    }
  }

  /// Init state of the widget and start timer
  @override
  void initState() {
    super.initState();
    this.startTime();
  }

  /// Build widget and display content
  @override
  Widget build(BuildContext context) {
    return SplashScreenDisplay();
  }
}
