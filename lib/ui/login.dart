import 'dart:async';
import 'package:EnlistControl/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../common/constants.dart';
import 'package:EnlistControl/ui/custom_route.dart';
import '../models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';
  User usuario;
  bool isLoggedIn;
  bool flagPass;
  String uri;
  Duration get loginTime => Duration(seconds: 5);
  final _webview = new FlutterWebviewPlugin();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  String toKen;
  String userTemp;
  String url;
  SharedPreferences prefs ;

  _saveData(String user, String pass) async {
      prefs = await SharedPreferences.getInstance();
      usuario = new User('1', user, pass, toKen);
      await prefs.setString('user', user);
      await prefs.setString('pass', pass);
      //await prefs.setString('token', toKen);

  }
  void initStreamController(String user,String pass){
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

  onStateChanged(WebViewStateChanged state){
        print("onStateChanged: ${state.type} ${state.url}");
        // Check if link is correct
        if (state.type == WebViewState.finishLoad && state.url.contains("simple.html?access_token")) {
            url = state.url;
            //filtro
            print('La url con la que se accedio fue:'+url);
            var token = url.replaceAll('http://tracking.gpscontrolcolombia.com/login_simple.html?access_token=', '');
            print('el token es: '+token);
            isLoggedIn = true;
            flagPass = true;
            toKen = token;
            //usuario.setToken(token);
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
        return 'Intenta de nuevo';
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
     uri="http://tracking.gpscontrolcolombia.com/login_simple.html";
      _webview.launch(uri,hidden: true);
      flagPass = false;
      _onStateChanged = _webview.onStateChanged.listen(this.onStateChanged);
    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/logo3.png',
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
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        userTemp = loginData.name;
        initStreamController(loginData.name , loginData.password);
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
          print('termino la animacion onsubmit');
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
