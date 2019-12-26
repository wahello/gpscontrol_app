import 'dart:async';
import 'dart:convert';

import 'package:GPS_CONTROL/models/alistamiento.dart';
import 'package:GPS_CONTROL/ui/alistamientos.dart';
import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/data/services/odoo_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:GPS_CONTROL/data/services/globals.dart';
import 'custom_route.dart';
import 'package:GPS_CONTROL/models/users.dart';
import 'package:GPS_CONTROL/models/post.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';

class InitAlistamiento extends StatefulWidget {
  InitAlistamiento({this.data});
  final data;
  static const routeName = '/init_alist';
  @override
  _InitAlistamientoState createState() => _InitAlistamientoState();
}

class _InitAlistamientoState extends State<InitAlistamiento> {
  Odoo _odoo;
  String odooURL = "";
  Post post;
  User user;
  Alistamiento nuevoAlistamiento;
  Map value;
  SharedPreferences preferences;

  @override
  void initState() {
    _initPrefs();
    post = widget.data;
    super.initState();
    //user = widget.data;
    print(user);
    //_init_alistamiento(false, user.name, '');

    //_checkFirstTime();
  }
  Future<void> _initPrefs() async {
    preferences = await SharedPreferences.getInstance();
    Timer(Duration(milliseconds: 2000), (){
      print('holis');
      });
  }

  _init_alistamiento(bool init_state, String user, String vehiculo){
    nuevoAlistamiento.folio = '';
    nuevoAlistamiento.state = '';
    nuevoAlistamiento.vehiculo = vehiculo;
    nuevoAlistamiento.fecha = DateTime.now();
    nuevoAlistamiento.documentos_conductor = init_state;
    nuevoAlistamiento.documentos_vehiculo = init_state;
    nuevoAlistamiento.calcomania = init_state;
    nuevoAlistamiento.pito = init_state;
    nuevoAlistamiento.disp_velocidad = init_state;
    nuevoAlistamiento.estado_esc_p_conductor = init_state;
    nuevoAlistamiento.estado_esc_p_pasajero = init_state;
    nuevoAlistamiento.equipo_carretera = init_state;
    nuevoAlistamiento.linterna = init_state;
    nuevoAlistamiento.extintor = init_state;
    nuevoAlistamiento.botiquin = init_state;
    nuevoAlistamiento.repuesto = init_state;
    nuevoAlistamiento.retrovisores = init_state;
    nuevoAlistamiento.cinturones = init_state;
    nuevoAlistamiento.motor = init_state;
    nuevoAlistamiento.llantas = init_state;
    nuevoAlistamiento.baterias = init_state;
    nuevoAlistamiento.transmision = init_state;
    nuevoAlistamiento.tapas = init_state;
    nuevoAlistamiento.niveles = init_state;
    nuevoAlistamiento.filtros= init_state;
    nuevoAlistamiento.parabrisas = init_state;
    nuevoAlistamiento.frenos= init_state;
    nuevoAlistamiento.frenos_emergencia = init_state;
    nuevoAlistamiento.aire = init_state;
    nuevoAlistamiento.luces = init_state;
    nuevoAlistamiento.silleteria = init_state;
    nuevoAlistamiento.silla_conductor = init_state;
    nuevoAlistamiento.aseo = init_state;
    nuevoAlistamiento.celular = init_state;
    nuevoAlistamiento.ruteros = init_state;

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
    List<String> _locations = []; // Option 2
    String _selectedCar; // Option 2
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pushNamed('/dashboard')
      ),
        title: Text("Inicio Alistamiento"),
      ),
      body: FutureBuilder(
        future: _initPrefs(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
              return ListView(
                children: <Widget>[
                  FutureBuilder(
                    future: _initPrefs(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Center(
                            child: DropdownButton(
                              hint: Text('Seleccione el vehiculo'), // Not necessary 
                              value: _selectedCar,
                              onChanged: (newValue) {
                                this.setState(() {
                                  _selectedCar = newValue;
                                  print(_selectedCar);
                                });
                              },
                              items: _locations.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }else if(snapshot.hasError){
                           throw snapshot.error;
                      }else{
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Center(
                            child: DropdownButton(
                              hint: Text('espere un momento...'), // Not necessary for Option 1
                              value: _selectedCar,
                              onChanged: (newValue) {
                                this.setState(() {
                                  _selectedCar = newValue;
                                  print(_selectedCar);
                                });
                              },
                              items: _locations.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          ),
                        );

                      }
                    },
                  ),
                  FutureBuilder(
                    future: _initPrefs(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        return Padding(
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
                              //print(nuevoAlistamiento.vehiculo);
                              Navigator.of(context).pushReplacement(FadePageRoute(
                                builder: (context) =>new  AlistamientoScreen(data: _selectedCar,),
                              ));
                              //_saveURL(_urlCtrler.text);*/
                            },
                          ),
                        );
                        }else if(snapshot.hasError){
                           throw snapshot.error;
                        }else{
                        return Padding(
                          padding: EdgeInsets.all(15.0),
                          child: MaterialButton(
                            child: Text(
                              "Sincronizando .. ",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.blueGrey,
                            onPressed: () {
                              /*print(nuevoAlistamiento.vehiculo);
                              Navigator.of(context).pushReplacement(FadePageRoute(
                                builder: (context) =>new  AlistamientoScreen(data: _selectedCar,),
                              ));
                              //_saveURL(_urlCtrler.text);*/
                            },
                          ),
                        );
                      }
                    },
                  ),
                  //Text(preferences.getString('user')),
                ],
              );
          }else if(snapshot.hasError){
            throw snapshot.error;
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  /*
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
  */
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
    preferences.remove('user');
    preferences.remove('pass');
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (_) => false,
    );
  }
}
