import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/data/services/globals.dart';
import 'package:GPS_CONTROL/data/services/odoo_api.dart';
import 'package:GPS_CONTROL/data/services/odoo_response.dart';
import 'package:GPS_CONTROL/data/services/utils.dart';
import 'package:GPS_CONTROL/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_login/flutter_login.dart';
import '../common/constants.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class Login extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static String odoo_URL = "66.228.39.68:8069";
  String _selectedProtocol = "http";
  String _selectedDb = "smart_contro";
  String _email;
  String _pass;
  Globals _globals;
  List dynamicList = [];
  bool isCorrectURL = false;
  bool isDBFilter = false;
  Odoo _odoo;
  bool isFirstTime = true;
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  _saveUser(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_globals.loginPrefName, username);
  }

  Future<String> _loginUser(LoginData data) {
    _email = data.name;
    _pass = data.password;
    _odoo = Odoo(url: _globals.url);
    bool flag = false;
    _odoo.authenticate(_email, _pass, _selectedDb).then(
            (OdooResponse auth) {
          if (!auth.hasError()) {
            Map jsonUser = auth.getResult();
            jsonUser["url"] = _globals.url;
            _saveUser(json.encode(jsonUser));
            flag = true;
          } else {
            print(auth.getError());
            flag = false;
          }
        }
    );
    return Future.delayed(loginTime).then((_) {
      print("Entramos a _loginUser return method");
      if (flag == true){
        Navigator.of(context).pushReplacementNamed("/home");
        return null;
      }else {
        return 'Prohibido';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //_checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/icon/favicon0.png',
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      messages: LoginMessages(
        usernameHint: 'Usuario',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Confirmar',
        loginButton: 'Iniciar Sesion',
        signupButton: 'Registrarme',
        forgotPasswordButton: 'Olvidaste la contraseña?',
        recoverPasswordButton: 'Ayuda',
        goBackButton: 'Volver',
        confirmPasswordError: 'No coincide!',
        recoverPasswordDescription: 'para recuperar el pass ... ',
        recoverPasswordSuccess: 'Contraseña rescatada con éxito!!',
      ),
      theme:  LoginTheme(
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
        errorColor: Colors.deepOrange,
        titleStyle: TextStyle(
          fontSize: 60.0,
          color: Colors.white,
          fontFamily: 'Quicksand',
        ),


        //   // beforeHeroFontSize: 50,
        //   // afterHeroFontSize: 20,
        bodyStyle: TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        //   textFieldStyle: TextStyle(
        //     color: Colors.orange,
        //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
        //   ),
        //   buttonStyle: TextStyle(
        //     fontWeight: FontWeight.w800,
        //     color: Colors.yellow,
        //   ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 19,
          margin: EdgeInsets.only(top: 55),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
        ),
        //   inputTheme: InputDecorationTheme(
        //     filled: true,
        //     fillColor: Colors.purple.withOpacity(.1),
        //     contentPadding: EdgeInsets.zero,
        //     errorStyle: TextStyle(
        //       backgroundColor: Colors.orange,
        //       color: Colors.white,
        //     ),
        //     labelStyle: TextStyle(fontSize: 12),
        //     enabledBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
        //       borderRadius: inputBorder,
        //     ),
        //     focusedBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
        //       borderRadius: inputBorder,
        //     ),
        //     errorBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
        //       borderRadius: inputBorder,
        //     ),
        //     focusedErrorBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
        //       borderRadius: inputBorder,
        //     ),
        //     disabledBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.grey, width: 5),
        //       borderRadius: inputBorder,
        //     ),
        //   ),
        //   buttonTheme: LoginButtonTheme(
        //     splashColor: Colors.purple,
        //     backgroundColor: Colors.pinkAccent,
        //     highlightColor: Colors.lightGreen,
        //     elevation: 9.0,
        //     highlightElevation: 6.0,
        //     shape: BeveledRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
        //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
        //   ),
      ),
      emailValidator: (value) {
        if (value.isEmpty) {
          return 'El usuario esta vacio';
        }
        //if (!value.contains('@') || !value.endsWith('.com')) {
        //  return "El correo electrónico debe contener '@' y terminar con '.com' ";
        //}
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'La contraseña esta vacía';
        }
        return null;
      },
      onLogin: (loginData) {
        return null;
      },
      onSignup: (loginData) {
        print('Signup info');
        return null;
      },
      onSubmitAnimationCompleted: () {
        print('on Submit aNIMATION completed');
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return null;
        // Show new password dialog
      },
      showDebugButtons: false,
    );
  }
}
