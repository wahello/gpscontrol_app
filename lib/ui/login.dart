import 'package:EnlistControl/models/users.dart';
import 'package:EnlistControl/navigation_home_screen.dart';
import 'package:EnlistControl/ui/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class WebviewLogin extends StatefulWidget {
  final String server;
  WebviewLogin(this.server);

  @override
  createState() => new WebviewLoginState(server);
}

class WebviewLoginState extends State<WebviewLogin> {
  final String server;
  WebviewLoginState(this.server);
  Duration get loginTime => Duration(seconds: 2);
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  User usuario;
  SharedPreferences prefs ;
  String toKen;
  final _history = [];

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: server,
      appBar: new AppBar(
        title: new Text("Iniciar Sesion."),
      ),
      withZoom: true,
      withJavascript: true,
      withLocalStorage: true,
    );
  }

  saveData(String user, String token) async {
      prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user);
      await prefs.setString('token', token);
      //await prefs.setString('token', toKen);
    return "okas";
  }

  @override
  initState() {
    
    super.initState();
    debugPrint("InitState");

    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        debugPrint("Webview Destroyed");
      }
    });
    
    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add("onUrlChanged: $url");
          debugPrint("onUrlChanged: $url");
          var uri = Uri.dataFromString(url);
          if (uri.hasQuery) {
            var parameters = uri.queryParameters;
            debugPrint(parameters.toString());
            if (parameters.containsKey('access_token')) {
              usuario = new User("", "", "", parameters['access_token']);
              debugPrint("Token: " + usuario.token);
              usuario.getDataOfToken();
              Future.delayed(loginTime).then((res){
                debugPrint('Se guardo el usuario: '+usuario.name);
                saveData(usuario.name, usuario.token);
                Navigator.of(context).pushReplacement(FadePageRoute(
                      builder: (context) => new NavigationHomeScreen(
                        userData: usuario,
                      ),
                    ));
              });
              //Navigator.pop(context, parameters["code"]);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    debugPrint("dispose");

    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }
}