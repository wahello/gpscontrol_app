import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../common/constants.dart';
import 'package:GPS_CONTROL/ui/custom_route.dart';
import 'package:GPS_CONTROL/ui/dashboard_screen.dart';
import '../models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';
  User usuario;
  bool isLoggedIn;
  bool flagPass;

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);
  final _webview = new FlutterWebviewPlugin();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  String toKen;
  String userTemp;
  String url;
  SharedPreferences prefs ;

  _validationWeb(String user,String pass){
    var setUser = 'document.getElementById("login").value="$user";';
    var setPass = 'document.getElementById("passw").value="$pass";';
    var submit = 'document.forms["auth-form"].submit();';
    print('entramos a la validacion');
    print("Usuario: "+user+" "+"Password: "+pass);
    try{
      _webview.evalJavascript(setUser);
      _webview.evalJavascript(setPass);
      _webview.evalJavascript(submit);
    }catch(e){
      print(e);
    }

  }
  _saveData(String user, String pass) async {
      prefs = await SharedPreferences.getInstance();
      usuario = new User('1', user, pass, toKen);
      await prefs.setString('user', user);
      await prefs.setString('ssap', pass);
      //await prefs.setString('token', toKen);

  }
  void initStreamController(){
      print('iniciamos controladores');
      String uri="http://tracking.gpscontrolcolombia.com/login_simple.html";
      print('se limpio cache y cookies');
      _webview.launch(uri,hidden: true);
      _webview.reload();
      _onStateChanged = _webview.onStateChanged.listen(this.onStateChanged);
      flagPass = false;
  }

  onStateChanged(WebViewStateChanged state) async {
        print("onStateChanged: ${state.type} ${state.url}");
        // Check if link is correct
        if (state.type == WebViewState.finishLoad && state.url.contains("simple.html?access_token")) {
            url = state.url;
            //filtro
            print('La url con la que se accedio fue:'+url);
            var token = url.replaceAll('http://tracking.gpscontrolcolombia.com/login_simple.html?access_token=', '');
            print('el token es: '+token);
            _webview.dispose();
            _webview.close();
            isLoggedIn = true;
            flagPass = true;
            toKen = token;
            usuario.setToken(token);
            // Check if view is mounted and displayed
        } else{
          flagPass = false;
        }
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
        return 'Hubo un error, verifica tu usuario o contraseña e inicia de nuevo.';
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
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        userTemp = loginData.name;
        initStreamController();
        _validationWeb(loginData.name , loginData.password);
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
          _webview.dispose();
          _webview.close();
          Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => DashboardScreen(userdata: usuario,),
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
    
}
