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
import 'login.dart';
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

        _webview.hide();
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
        print("onStateChanged: ${state.type} ${state.url}");
        print(code);
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
            body: WebviewScaffold(
                url: widget.authUrl,
                withJavascript: true,
                withZoom: false,
                clearCache: true,
                clearCookies: true,
                initialChild: LoginScreen(),


            ),
        );
    }
    
    _save(String sid,String user, String email,String pass) async {
        usuario = new User(sid, user, email, pass);
    }

}