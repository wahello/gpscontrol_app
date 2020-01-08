import 'package:GPS_CONTROL/ui/SplashScreen.dart';
import 'package:GPS_CONTROL/ui/init_alistamiento.dart';
import 'package:GPS_CONTROL/ui/login.dart';
import 'package:flutter/services.dart';
import 'ui/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'common/transition_route_observer.dart';
import 'ui/alistamientos.dart';

//import 'package:GPS_CONTROL/pages/login.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS CONTROL',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        accentColor: Colors.red,
        cursorColor: Colors.blue,
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          display2: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 15.0,
            // fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          button: TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.blue[300],
          ),
          display4: TextStyle(fontFamily: 'Quicksand'),
          display3: TextStyle(fontFamily: 'Quicksand'),
          display1: TextStyle(fontFamily: 'Quicksand'),
          headline: TextStyle(fontFamily: 'NotoSans'),
          title: TextStyle(fontFamily: 'NotoSans'),
          subhead: TextStyle(fontFamily: 'NotoSans'),
          body2: TextStyle(fontFamily: 'NotoSans'),
          body1: TextStyle(fontFamily: 'NotoSans'),
          subtitle: TextStyle(fontFamily: 'NotoSans'),
          overline: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home: SplashScreen(),
      navigatorObservers: [TransitionRouteObserver()],
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
        AlistamientoScreen.routeName: (context) => AlistamientoScreen(),
        InitAlistamiento.routeName: (context) => InitAlistamiento(),
      },
    );
  }
}
