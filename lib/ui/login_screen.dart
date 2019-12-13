import 'dart:async';
import 'dart:io';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/utils/network/IntranetAPIUtils.dart';

import 'package:GPS_CONTROL/pages/display/SplashScreenDisplay.dart';

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

    /// When webview state is changed
    onStateChanged(WebViewStateChanged state) async {
        print("onStateChanged: ${state.type} ${state.url}");

        // Check if link is correct
        if (state.type == WebViewState.shouldStart && state.url.startsWith("https://hst-api.wialon.com/oauth/authorize.html?")) {
            ScaffoldState scaffoldState = this._scaffoldKey.currentState;
            _webview.stopLoading();
            _webview.close();

            // Check if view is mounted and displayed
            if (mounted) {
                try {
                    // Login... and display
                    scaffoldState.showSnackBar(SnackBar(
                        key: Key("login_message"),
                        backgroundColor: Color.fromARGB(255, 39, 174, 96),
                        content:Text("Connexion en cours..."),
                    ));
                    //return Navigator.of(context).pushReplacementNamed('/home');

                    await this._api.getAndSaveAutologinLink(state.url).then((res) {
                        debugPrint("Autologin " + res.toString());
                    });
                } catch (err) {
                    // Display error
                    scaffoldState.showSnackBar(SnackBar(
                        key: Key("login_message"),
                        backgroundColor: Color.fromARGB(255, 192, 57, 43),
                        content:Text("Une erreur est survenue !"),
                    ));
                }
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
                initialChild: SplashScreen(),

            ),
        );
    }

}