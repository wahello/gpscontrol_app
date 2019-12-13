import 'dart:async';
import 'package:GPS_CONTROL/models/users.dart';
import 'package:GPS_CONTROL/ui/SplashScreen.dart';
import 'package:GPS_CONTROL/ui/custom_route.dart';
import 'package:GPS_CONTROL/ui/dashboard_screen.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/utils/network/IntranetAPIUtils.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:odoo_api/odoo_api.dart';
import 'package:flutter_login/flutter_login.dart';
import '../common/constants.dart';

class LoginWebview extends StatefulWidget {
    final String authUrl;
    static const routeName = '/auth';
    /// Constructor
    LoginWebview({Key key, @required this.authUrl}) : super(key: key);

    @override
    _LoginWebview createState() => _LoginWebview();
}

class _LoginWebview extends State<LoginWebview> {

    final IntranetAPIUtils _api = new IntranetAPIUtils();
    final _webview = new FlutterWebviewPlugin();
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    User usuario;
    bool isLoggedIn;
    Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);
    StreamSubscription<WebViewStateChanged> _onStateChanged;

    String token;

    /// When activity closing
    @override
    void dispose() {
        // Every listener should be canceled, the same should be done with this stream.
        _onStateChanged.cancel();
        _webview.dispose();
        super.dispose();
    }

    /// Init state and webview controller
    @override
    void initState() {
        super.initState();

        _webview.close();
        _onStateChanged = _webview.onStateChanged.listen(this.onStateChanged);
    }
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

    /// When webview state is changed
    onStateChanged(WebViewStateChanged state) async {
        var code = "document.getElementById('login').value";
        var username = _webview.evalJavascript(code);
        print("onStateChanged: ${state.type} ${state.url}");
        print(username);
        // Check if link is correct
        if (state.type == WebViewState.finishLoad && state.url.contains("/login.html?access_token=")) {
            ScaffoldState scaffoldState = this._scaffoldKey.currentState;
            _webview.stopLoading();
            _webview.close();
            print('cerramos el web_view');
            // Check if view is mounted and displayed
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
            }
            // Parse cookies
            /*cookies.then((Map<String, String> ck) {
                ck.forEach((key, value) {
                    if (key.substring(1) == "ESTSAUTHLIGHT") {
                        //Cookie cookie = Cookie(key.substring(1), value.substring(0, value.length - 1));
                    }
                });
            });*/
        }
    }

    /// Build widget and display content
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: this._scaffoldKey,
            appBar: new AppBar(
              title: Text('Iniciar Sesion'),
            ),
            body: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FlutterLogin(
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
                      var client = OdooClient("http://66.228.39.68:8069");
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
                      });
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
                  ),
                WebviewScaffold(
                url: widget.authUrl,
                withJavascript: true,
                hidden: true,
                withZoom: false,
                clearCache: true,
                clearCookies: true,
                initialChild: SplashScreen(),

            )
              ],
            ),
        );
    }
    
    _save(String sid,String user, String email,String pass) async {
        usuario = new User(sid, user, email, pass);
    }

}