import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:GPS_CONTROL/models/alistamiento.dart';
import 'package:GPS_CONTROL/models/pseudouser.dart';
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
import 'package:GPS_CONTROL/models/unit.dart';
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
  PseudoUser user;
  Alistamiento nuevoAlistamiento;
  Map value;
  SharedPreferences preferences;
  var listaVehiculos = new List<PseudoUnit>(); 
  String msg = 'Seleccione Vehiculo';
  Color btnColor = Colors.blueGrey;
  var itemCount;
  String auxJson = '';
  PseudoUnit unit;

  @override
  void initState() {
    super.initState();
    //user = widget.data;
    //_init_alistamiento(false, user.name, '');

    //_checkFirstTime();
  }
  Future<int> getIdOdoo (id_wia) async {
    //preferences = await SharedPreferences.getInstance();
    var client = OdooClient("http://66.228.39.68:8069");
    var auth = await client.authenticate('appbot', 'iopunjab1234!',"smart_contro");
    if(auth.isSuccess){
      print(id_wia);
      client.searchRead('gpscontrol.wialon_unit', [['id_wialon','=',id_wia]], ['id','name']).then((res){
        if(res.hasError()){
          print('algo salio mal marica');
          return 0;
        }else{
          var data = res.getResult();
          var result;
          for(var rec in data['records']){
            print(rec['id']);
            result = rec['id'];
          }
          
          return result;
        }
      });

    }else{
      return 99999;
    }
  }

  Future<List<PseudoUnit>> getVehicles() async {
  user = widget.data;
  var username = user.name;
  var url = 'http://hst-api.wialon.com/wialon/ajax.html?svc=token/login&params={%22token%22:%2253dac8bfe1c32941e9a7b7121196dfe262A6A9DF693E8274C23FD67398B9AFDED9E5FE4F%22,%22operateAs%22:%22$username%22}';
  var url2 = 'https://hst-api.wialon.com/wialon/ajax.html?svc=core/search_items&params={%22spec%22:{%22itemsType%22:%22avl_unit%22,%22propName%22:%22trailers%22,%22propValueMask%22:%22%22,%22sortType%22:%22trailers%22,%22propType%22:%22propitemname%22},%22force%22:1,%22flags%22:1,%22from%22:0,%22to%22:0}&sid=';
  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    itemCount = jsonResponse['eid'];
    var response2 = await http.get(url2+itemCount);
    if(response2.statusCode == 200){
      var jsonResponse2 = convert.jsonDecode(response2.body);
      for (var unit in jsonResponse2['items']){
        var recUnit = new PseudoUnit(unit['id'], user.id, unit['nm'], user);
        print('se encontro el vehiculo '+recUnit.name);
        listaVehiculos.add(recUnit);
      }
      var res =jsonResponse2['totalItemsCount'];
      print('se encontraron '+res.toString()+' Vehiculos');
      return listaVehiculos;
    }else{
      print('no se pudo imprimira la lista');
    }
  } else {
    print('Todo fallo con estado de error: ${response.statusCode}.');
  }
  }

  Future<String> getUnitInfo(id) async{
    var url = 'http://hst-api.wialon.com/wialon/ajax.html?svc=core/search_item&params={%22id%22:';
    var ad = ',"flags":4611686018427387903}&sid=';
    var idWia = id;
    var odooData = await getIdOdoo(idWia);
    var response = await http.get(url+'$idWia'+ad+itemCount);
    if(response.statusCode == 200){
      var jsonResponse = convert.jsonDecode(response.body);
      var result = jsonResponse['item']['nm'];
      print(result);
      unit = new PseudoUnit(odooData, user.id, result, user);
      print(unit.id);
      return result;
    }else{
      return 'algo salio mal...';
    }
  }

  Future<String> buildInfoUnit() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return 'ok';
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
    String _selectedCar;
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pushNamed('/dashboard')
      ),
        title: Text("Inicio Alistamiento"),
      ),
      body: ListView(
                children: <Widget>[
                  FutureBuilder(
                    future: getVehicles(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        return Padding(
                          padding: EdgeInsets.all(28.0),
                          child: Column(
                            children: <Widget>[
                              DropdownButton(
                                hint: Text(msg), // Not necessary 
                                value: _selectedCar,
                                isExpanded: true,
                                isDense: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    //_selectedCar = newValue.toString();
                                    //msg = _selectedCar;
                                    getUnitInfo(newValue).then((res){
                                      print(res);
                                      msg = res;
                                    });
                                    btnColor = Colors.blue;
                                    
                                    print(auxJson);
                                  });
                                },
                                items: listaVehiculos.map((unit) {
                                  return DropdownMenuItem(
                                    child: new Text(unit.name),
                                    value: unit.id,
                                  );
                              }).toList(),
                              )
                            ],
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
                  Padding(
                          padding: EdgeInsets.all(15.0),
                          child: MaterialButton(
                            child: Text(
                              "Iniciar ",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            color: btnColor,
                            onPressed: () {
                              //getVehicles();
                              /*print(nuevoAlistamiento.vehiculo);*/
                              Navigator.of(context).pushReplacement(FadePageRoute(
                                builder: (context) =>new  AlistamientoScreen(data: unit,),
                              ));
                              //_saveURL(_urlCtrler.text);*/
                            },
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(auxJson),
                  ),
                ],
              ),);

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
