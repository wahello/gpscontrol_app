import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/data/services/odoo_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:GPS_CONTROL/data/services/globals.dart';

class InitAlistamiento extends StatefulWidget {
  InitAlistamiento({this.data});
  final data;
  static const routeName = '/init_alist';
  @override
  _InitAlistamientoState createState() => _InitAlistamientoState();
}

class _InitAlistamientoState extends State<InitAlistamiento> {
  TextEditingController _urlCtrler = new TextEditingController();
  Odoo _odoo;
  String odooURL = "";

  @override
  void initState() {
    super.initState();
    //_checkFirstTime();
  }

  //_checkFirstTime() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //if (prefs.getString("odooUrl") != null) {
    //  setState(() {
    //    _urlCtrler.text = prefs.getString("odooUrl");
    //    odooURL = prefs.getString("odooUrl");
    //  });
   // }
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio Alistamiento"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextField(
              textAlign: TextAlign.left,
              controller: _urlCtrler,
              decoration: InputDecoration(
                labelText: "Placa Vehiculo",
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: MaterialButton(
              child: Text(
                "Iniciar Alistamiento",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, '/alistamientos');
                //_saveURL(_urlCtrler.text);
              },
            ),
          )
        ],
      ),
    );
  }

  _saveURL(String url) async {
    if (!url.toLowerCase().contains("http://") &&
        !url.toLowerCase().contains("https://")) {
      url = "http://" + url;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (url.length > 0 && url != " ") {
      _odoo = Odoo(url: url);
      _odoo.getDatabases().then((http.Response res) {
        prefs.setString("odooUrl", url);
        _showLogoutMessage("Setting Saved! Please Login!");
      }).catchError((error) {
        _showMessage("Can't connect to the server! Please enter valid URL");
      });
    } else {
      _showMessage("Please enter valid URL");
    }
  }

  _showMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          title: Text(
            "Warning",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showLogoutMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          title: Text(
            "Warning",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _clearPrefs();
              },
              child: Text(
                "Logout",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _clearPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _odoo = Odoo(url: odooURL);
    _odoo.destroy();
    preferences.remove(Globals().loginPrefName);
    preferences.remove("session");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (_) => false,
    );
  }
}
