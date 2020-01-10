import 'dart:async';
import 'package:GPS_CONTROL/navigation_home_screen.dart';
import 'package:GPS_CONTROL/ui/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/utils/network/IntranetAPIUtils.dart';
import 'package:GPS_CONTROL/ui/login.dart';
import 'package:GPS_CONTROL/pages/display/SplashScreenDisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:GPS_CONTROL/ui/home.dart';
import 'package:GPS_CONTROL/models/users.dart';

/// SplashScreen extended from StatefulWidget
/// State
class SplashScreen extends StatefulWidget {
    @override
    _SplashScreenState createState() => _SplashScreenState();
}

/// _SplashScreenState extended from State<SplashScreen>
/// Display content
class _SplashScreenState extends State<SplashScreen> {

    final IntranetAPIUtils _api = new IntranetAPIUtils();
    User usuario;
    /// Run async task to change view after given time
    startTime() async {
        var duration = new Duration(seconds: 5);
        return new Timer(duration, checkUserLogged);
    }

    /// Check if the user is connected, and redirect to correct home
    checkUserLogged() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
         
        //prefs.remove("autolog_url");
        //prefs.setString("autolog_url", "https://intra.epitech.eu/auth-9472567ed80878ddb46ac61a97bad16e5e5bd99d");
        //prefs.setString("email", "cyril.colinet@epitech.eu");

        if (prefs.getString("user") != null){
          print("se encontro user "+prefs.getString("user"));
          usuario = new User(prefs.getString("id"), prefs.getString("user"), prefs.getString("pass"), 'token');
            return Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => NavigationHomeScreen(userData: usuario,),
          ));
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Home()
        ));

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