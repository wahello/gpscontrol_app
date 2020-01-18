import 'dart:async';
import 'package:EnlistControl/models/unit.dart';
import 'package:EnlistControl/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../common/constants.dart';
import 'package:EnlistControl/ui/custom_route.dart';
import '../models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';
  User usuario;
  bool isLoggedIn;
  bool flagPass;
  String uri;
  Duration get loginTime => Duration(seconds: 2);
  final _webview = new FlutterWebviewPlugin();
  String toKen;
  String userTemp;
  String url;
  SharedPreferences prefs ;

  _saveData(String user, String pass) async {
      prefs = await SharedPreferences.getInstance();
      prefs.setString("user", user);
      prefs.setString("pass", pass);
      //await prefs.setString('token', toKen);

  }
  
  validationKeyMobile(String user, String pass){
    isLoggedIn = false;
    flagPass = false;
    var rec = user;
    rec = rec.replaceAll("+", "");
    print(rec);
    var url = "http://hst-api.wialon.com/wialon/ajax.html?svc=resource/driver_operate&params={%22phoneNumber%22:%22%2B$rec%22,%22password%22:%22$pass%22,%22callMode%22:%22status%22,%22app%22:%22enlist%22}";
    http.get(url).then((res){
      var jsonResponse = convert.jsonDecode(res.body);
      print(jsonResponse);
      if(jsonResponse.containsKey("drv")){
        print('Contiene la clave drv');
        usuario = new User(jsonResponse["drv"]["rid"].toString(),jsonResponse["drv"]["nm"],pass,user);
        print(jsonResponse["un"]["id"]);
        print(jsonResponse["un"]["nm"]);
        usuario.setInfoU(jsonResponse["un"]["id"], jsonResponse["un"]["nm"]);
        print("username is: ${usuario.name} ${usuario.nameU}");
        _saveData(usuario.name, usuario.passwd);
        print("ok .. inicio sesion");
        isLoggedIn = true;
        flagPass = true;
      }else{
        isLoggedIn = false;
        flagPass = false;
      }
   });
  }
  
  Future<String> _loginUser(LoginData logindata) {
    return Future.delayed(loginTime).then((_) {
      print("Entramos a _loginUser method");
      if (isLoggedIn == true && flagPass==true){
        var user = logindata.name;
        var pass = logindata.password;
        _saveData(user, pass);
        return null;
      }else {
        return 'Error, verifica tus credenciales';
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

    @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/icon/favicon2.png',
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
              fontSize: 22.0,
              color: Colors.blue,
              fontFamily: 'Quicksand',
            ),


            beforeHeroFontSize: 28,
            afterHeroFontSize: 12,
            bodyStyle: TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,

            ),
            cardTheme: CardTheme(
              color: Colors.white,
              elevation: 30,
              margin: EdgeInsets.only(top: 30),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
            ),
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
        validationKeyMobile(loginData.name, loginData.password);
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        userTemp = loginData.name;
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        if (isLoggedIn == true && flagPass==true) {
          _webview.close();
          Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => NavigationHomeScreen(userData: usuario,),
          ));
        }else{
          _webview.close();
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
    
}