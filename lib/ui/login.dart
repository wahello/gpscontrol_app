import 'dart:async';
import 'package:EnlistControl/models/unit.dart';
<<<<<<< HEAD
import 'package:EnlistControl/ui/init_alistamiento.dart';
import 'package:connectivity/connectivity.dart';
=======
import 'package:EnlistControl/navigation_home_screen.dart';
>>>>>>> master
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:toast/toast.dart';
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
  bool internet;

  _saveData(String user, String pass, String img) async {
      prefs = await SharedPreferences.getInstance();
      prefs.setString("user", user);
      prefs.setString("pass", pass);
<<<<<<< HEAD
      prefs.setString("idU", usuario.idU.toString());
      prefs.setString("nameU", usuario.nameU);
      prefs.setString("tel", usuario.token);
      prefs.setString("sid", usuario.sid);
      prefs.setString("Uid", usuario.id.toString());
      prefs.setString("img", img);

      //await prefs.setString('token', toKen);

  }

  checkConexxion()async{
    Connectivity().checkConnectivity().then((connectivityResult){
        //verificamos si esta conectado a internet
      if (connectivityResult == ConnectivityResult.none) {
        // I am not connected to a mobile network.
        internet = false;
      }else {
        // I'm connected!
        internet = true;        
      }
    });
     
  }
=======
      //await prefs.setString('token', toKen);

  }
>>>>>>> master
  
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
<<<<<<< HEAD
        var internalId = jsonResponse["drv"]["id"];
        var id = jsonResponse["drv"]["rid"];
        var imgRes = "http://hst-api.wialon.com/avl_driver_image/$id/$internalId/200/1.png";
        var uname = jsonResponse["drv"]["nm"];
        usuario = new User(id,uname ,pass ,user );
=======
        var id = jsonResponse["drv"]["rid"];
        var uname = jsonResponse["drv"]["nm"];
        usuario = new User(id.toString(),uname ,pass ,user );
>>>>>>> master
        print(jsonResponse["un"]["id"]);
        print(jsonResponse["un"]["nm"]);
        usuario.setInfoU(jsonResponse["un"]["id"], jsonResponse["un"]["nm"]);
        print("username is: ${usuario.name} ${usuario.nameU}");
<<<<<<< HEAD
        _saveData(usuario.name, usuario.passwd, imgRes);
=======
        _saveData(usuario.name, usuario.passwd);
>>>>>>> master
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
<<<<<<< HEAD
      if (internet == true){
        if (isLoggedIn == true && flagPass==true){
        //_saveData(user, pass);
        return null;
      }else {
        return 'Error, intente de nuevo.';
      }
      }else{
        return 'Comprueba tu conexion a internet e intentalo de nuevo.';
=======
      if (isLoggedIn == true && flagPass==true){
        //_saveData(user, pass);
        return null;
      }else {
        return 'Error, verifica tus credenciales';
>>>>>>> master
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
<<<<<<< HEAD
    final roundBorderRadius = BorderRadius.circular(100);
    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/icon/favicon1.png',
=======
    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/icon/favicon2.png',
>>>>>>> master
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      messages: LoginMessages(
        usernameHint: 'Usuario',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Confirmar',
        loginButton: 'Iniciar Sesion',
        signupButton: 'Registrarme',
        forgotPasswordButton: 'Olvidó su contraseña?',
        recoverPasswordButton: 'Ayuda',
        goBackButton: 'Volver',
        confirmPasswordError: 'No coincide!',
        recoverPasswordDescription: 'para recuperar el pass ... ',
        recoverPasswordSuccess: 'Contraseña rescatada con éxito!!',
      ),
      theme:  LoginTheme(
            primaryColor: Colors.black,
            accentColor: Colors.black,
            errorColor: Color(0xffff0032),
            titleStyle: TextStyle(
              fontSize: 22.0,
              color: Colors.blue,
              fontFamily: 'Quicksand',
            ),
            pageColorLight: Color(0xff000000),
            pageColorDark: Color(0xff282828),
            beforeHeroFontSize: 28,
            afterHeroFontSize: 12,
            bodyStyle: TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,

            ),
            cardTheme: CardTheme(
              color: Color(0xff282828),
              elevation: 5,
              margin: EdgeInsets.only(top: 30),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
            ),
            buttonTheme: LoginButtonTheme(
              backgroundColor: Color(0xff00ff32),
              highlightColor: Colors.white,
            ),
            buttonStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
            inputTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              fillColor: Color(0xffffffff),
              filled: true,
              enabledBorder:OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent , width: 1.5),
                borderRadius: roundBorderRadius,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white , width: 2.9),
                borderRadius: roundBorderRadius,
              ),
            )
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
<<<<<<< HEAD
        checkConexxion();
=======
>>>>>>> master
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
            builder: (context) => InitAlistamiento(data: usuario,),
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