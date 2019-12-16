import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../common/constants.dart';
import 'package:GPS_CONTROL/ui/custom_route.dart';
import 'package:GPS_CONTROL/ui/dashboard_screen.dart';
import '../models/users.dart';
import 'package:odoo_api/odoo_api.dart';
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
      await prefs.setString('user', user);
      await prefs.setString('ssap', pass);
      await prefs.setString('token', toKen);
  }
  void initStreamController(){
      print('iniciamos controladores');
      String url="http://tracking.gpscontrolcolombia.com/login_simple.html";
      _webview.cleanCookies();
      _webview.clearCache();
      print('se limpio cache y cookies');
      _webview.launch(url,hidden: true);
      _onStateChanged = _webview.onStateChanged.listen(this.onStateChanged);
      flagPass = false;
  }

  saveCredentials(String token)
  {
    prefs.setString('token', token);
  }

  onStateChanged(WebViewStateChanged state) async {
        print("onStateChanged: ${state.type} ${state.url}");
        // Check if link is correct
        if (state.type == WebViewState.finishLoad && state.url.contains("simple.html?access_token")) {
            url = state.url;
            print('La url con la que se accedio fue: '+url);
            var token = url.replaceAll('http://tracking.gpscontrolcolombia.com/login_simple.html?access_token=', '');
            print('el token es: '+token);
            _webview.close();
            isLoggedIn = true;
            flagPass = true;
            toKen = token;
            saveCredentials(token);
            // Check if view is mounted and displayed
            /*
            if (mounted) {
                try {
                  print('entramos al if mounted');
                    // Login... and display
                    scaffoldState.showSnackBar(SnackBar(
                        key: Key("login_message"),
                        backgroundColor: Color.fromARGB(255, 39, 174, 96),
                        content:Text("Connexion en cours..."),
                    ));
                    //aqui guardamos las cookies into server.. cuando las encontremos :()
                    /*await this._api.getAndSaveAutologinLink(state.url).then((res) {
                        print("Autologin " + res.toString());
                    });*/
                    return Navigator.of(context).pushReplacement(FadePageRoute(
                          builder: (context) => DashboardScreen(data: usuario,),
                        ));

                } catch (err) {
                    // Display error
                    print('algo salio mal ..');
                    print('el error es '+err);
                    scaffoldState.showSnackBar(SnackBar(
                        key: Key("login_message"),
                        backgroundColor: Color.fromARGB(255, 192, 57, 43),
                        content:Text("Error al guardar, por favor intente de nuevo !"),
                    ));
                }
            } else{
              print('entramos a else mounted ');
            }*/
            // Parse cookies
            /*cookies.then((Map<String, String> ck) {
                ck.forEach((key, value) {
                    if (key.substring(1) == "ESTSAUTHLIGHT") {
                        //Cookie cookie = Cookie(key.substring(1), value.substring(0, value.length - 1));
                    }
                });
            });*/
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
        initStreamController();
        _validationWeb(loginData.name , loginData.password);
        var client = OdooClient("http://66.228.39.68:8069");
        return _loginUser(loginData);
                /*
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
        
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        if (isLoggedIn == true && flagPass==true) {
          Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => DashboardScreen(),
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
    _save(String sid,String user, String email,String pass) async {
        usuario = new User(sid, user, email, pass);
    }
}
