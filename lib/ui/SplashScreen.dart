import 'dart:async';
import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/utils/network/IntranetAPIUtils.dart';
import 'package:GPS_CONTROL/ui/login.dart';
import 'package:GPS_CONTROL/pages/display/SplashScreenDisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:GPS_CONTROL/ui/home.dart';

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

    /// Run async task to change view after given time
    startTime() async {
        var duration = new Duration(seconds: 5);
        return new Timer(duration, checkUserLogged);
    }

    /// Check if the user is connected, and redirect to correct home
    checkUserLogged() async {
         Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Home()
        ));
        //prefs.remove("autolog_url");
        //prefs.setString("autolog_url", "https://intra.epitech.eu/auth-9472567ed80878ddb46ac61a97bad16e5e5bd99d");
        //prefs.setString("email", "cyril.colinet@epitech.eu");

        // Check if autologin url exists in shared preferences and redirect to homepage
        
        // Ask intranet to give authentication URL

        // Not logged, need to redirect to SSO page
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