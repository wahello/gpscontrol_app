import 'dart:async';

import 'package:GPS_CONTROL/data/services/odoo_api.dart';
import 'package:GPS_CONTROL/ui/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/ui/dashboard_screen.dart';
import 'package:GPS_CONTROL/models/users.dart';

class SplashScreen extends StatefulWidget {
  static String splash = "splash";
  SplashScreen({this.data,});
  final data;
  static const routeName = '/splash';

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  CurvedAnimation _iconAnimation;
  User usuario;
  bool isLoggedIn;

  void handleTimeout() {
    print('Login info');
        //var client = Odoo(url: "http://66.228.39.68:8069",);
        /*client.authenticate(loginData.name, loginData.password, "smart_contro").then((auth) {
          if (auth.isSuccess) {
            print("Bienvenido ${auth.getUser().name}");
            print(auth.getSessionId());
            var name_user = auth.getUser().name;
            _save(auth.getSessionId(),name_user,loginData.name,loginData.password);
            isLoggedIn = true;
          } else {
            print("Algo salio mal. :s ");
            isLoggedIn = false;
          }
        });
        return _loginUser(isLoggedIn);*/
    usuario = widget.data;
  }

  startTimeout() async {

    var duration = const Duration(seconds: 4);
    return new Timer(duration, handleTimeout);

  }
  bool _visible = true;
  @override
  void initState() {
    super.initState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 3000));

    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeIn);
    _iconAnimation.addListener(() => this.setState(() {}));

    _iconAnimationController.forward();

    startTimeout();

  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return new Scaffold(
      body: new Scaffold(
        body: new Center(
          child: new AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: new Duration(milliseconds: 2000),
            child: new Container(
              child: new Text('Bienvenido',style: textTheme.display3,),
            ),
          ),
        ),
      ),
    );
  }
}