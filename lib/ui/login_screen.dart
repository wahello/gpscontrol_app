import 'package:GPS_CONTROL/models/vehiculos.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:odoo_api/odoo_user_response.dart';
import '../common/constants.dart';
import 'custom_route.dart';
import 'dashboard_screen.dart';
import '../models/users.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:GPS_CONTROL/common/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'as convert;

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';
  User usuario;
  bool isLoggedIn;

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String> _loginUser(bool data) {
    return Future.delayed(loginTime).then((_) {
      print("Entramos a _loginUser method");
      if (isLoggedIn == true){
        return null;
      }else {
        return 'Prohibido';
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
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
           fontSize: 12.0,
           color: Colors.white,
           fontFamily: 'Quicksand',
         ),


       beforeHeroFontSize: 31,
       afterHeroFontSize: 20,
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
           elevation: 30,
           margin: EdgeInsets.only(top: 2),
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
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        /*var client = OdooClient("http://66.228.39.68:8069");
        client.authenticate(loginData.name, loginData.password, "smart_contro").then((auth) {
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
        });*/
        login_wialon(loginData.name , loginData.password);
        return _loginUser(isLoggedIn);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(isLoggedIn);
      },
      onSubmitAnimationCompleted: () {
        if (isLoggedIn == true) {
          Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => DashboardScreen(data: usuario,),
          ));
        }
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: false,
    );
  }

  login_wialon(String user, String pass) async {
    var url = "https://hst-api.wialon.com/wialon/ajax.html?svc=token/login&params={%22token%22:%2253c45668de3e5399eb7af78a889bd45a4D9DD25ED3B4DDDC261DB138027093247B183718%22,%22operateAs%22:%22$user%22}";
    var response = await http.post(url);

    // Await the http get response, then decode the json-formatted responce.
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Todo Ok.");
      print(jsonResponse);
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }
    _read() async {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_int_key';
      final value = prefs.getInt(key) ?? 0;
      print('read: $value');
    }

    _save(String sid,String user, String email,String pass) async {
        usuario = new User(sid, user, email, pass);
    }
}
