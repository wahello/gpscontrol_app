import 'dart:async';
import 'dart:core';
import 'dart:convert' as convert;
import 'package:EnlistControl/helper/DatabaseHelper.dart';
import 'package:EnlistControl/models/vehiculos.dart';
import 'package:http/http.dart' as http;
import 'package:EnlistControl/models/alistamiento.dart';
import 'package:EnlistControl/models/pseudouser.dart';
import 'package:EnlistControl/ui/alistamientos.dart';
import 'package:flutter/material.dart';
import 'package:EnlistControl/data/services/odoo_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:EnlistControl/data/services/globals.dart';
import 'custom_route.dart';
import 'package:EnlistControl/models/post.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:EnlistControl/models/unit.dart';
import 'package:EnlistControl/models/atribute.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

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
  Alistamiento nuevoAlistamiento;
  Map value;
  SharedPreferences preferences;
  var listaVehiculos = new List<PseudoUnit>();
  String msg = 'Seleccione Vehiculo';
  Color btnColor = Colors.blueGrey;
  var itemCount;
  String auxJson = '';
  PseudoUser user;
  List<Vehiculo> vehiculos;
  PseudoUnit unit;
  String sid;
  List<Intervalo> intervalos;
  List<Atribute> atributos;
  String _selectedCar;


  bool flagAtributes;
  Duration get loginTime => Duration(seconds: 1);

  @override
  void initState() {
    user = widget.data;
    sid = user.baseUser.sid;
    vehiculos = user.vehiculos;
    _selectedCar = "";
    super.initState();
    //user = widget.data;
    //_init_alistamiento(false, user.name, '');

    //_checkFirstTime();
  }

  Future<int> getIdOdoo(idWia) async {
    //preferences = await SharedPreferences.getInstance();
    var client = OdooClient("http://66.228.39.68:8069");
    var auth =
        await client.authenticate('appbot', 'iopunjab1234!', "smart_contro");
    if (auth.isSuccess) {
      print(idWia);
      /*client.searchRead('gpscontrol.wialon_unit', [
        ['id_wialon', '=', idWia]
      ], [
        'id',
        'name'
      ]).then((res) {
        if (res.hasError()) {
          print('algo salio mal marica');
          return 0;
        } else {
          var data = res.getResult();
          var result;
          for (var rec in data['records']) {
            print('Holis' + rec['id'].toString());
            unit.setId(rec['id']);
          }

          return result;
        }
      });*/
    } else {
      return 99999;
    }
  }

  Future<List<Vehiculo>> getVehicles() async {
    if (vehiculos!=null) {
      vehiculos.forEach((unidad){
        var res = unidad.getData(sid);
        print(res); 
      });
      return vehiculos;
    } else {
      vehiculos= [];
      print('No se encontraron vehiculos.');
      return vehiculos;
    }
  }

  Future<String> checkAvalibleAttrs() {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> buildInfoUnit() async {
    preferences = await SharedPreferences.getInstance();
    return 'ok';
  }

  _init_alistamiento(bool init_state, String user, String vehiculo) {
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
    nuevoAlistamiento.filtros = init_state;
    nuevoAlistamiento.parabrisas = init_state;
    nuevoAlistamiento.frenos = init_state;
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
  
  Future<String> getUnitInfo (index) async {
    intervalos = [];
    atributos = [];
    String unitName ="";
    if (vehiculos.length>0){
      vehiculos.forEach((vehiculo){
        if(vehiculo.id == index){
          //vehiculo.getData(sid);
          Future.delayed(loginTime);
        }
        return unitName;
      });
    }else{
      flagAtributes = false;
      unitName = "Algo salio mal con este vehiculo, selecciona otro";
      
    }
   return unitName;
  }

  Future<String> voidMethod(){
    var log;
    return Future.delayed(loginTime).then((val){
      log = "ok";
      return log;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> _locations = []; // Option 2
    flagAtributes = false;
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop()),
        title: Text("Inicio Alistamiento"),
      ),
      body: new Container(
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              FutureBuilder(
                future: DatabaseHelper.instance.retrieveVehiculos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    vehiculos = snapshot.data;
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
                                      _selectedCar = newValue;
                                      flagAtributes = false;
                                      getUnitInfo(newValue).then((res) {
                                        print(res);
                                        msg = res;
                                        flagAtributes = true;
                                      });
                                      print("new value: "+newValue);
                                      btnColor = Colors.blue;
                                      print("auxjson "+auxJson);
                                    });
                                  },
                                  items: vehiculos.map((unit) {
                                    return DropdownMenuItem(
                                      child: new Text(unit.name),
                                      value: unit.id,
                                    );
                                  }).toList(),
                                ),
                                flagAtributes == false? Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            'Selecciona un vehiculo para cargar la informacion')
                                      ],
                                    ),
                                  ):
                                  Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: <Widget>[
                                        Text(intervalos.length>0?'Intervalos de servicio: ':'No se encontraron intervalos de servicio.', style: new TextStyle(fontWeight: FontWeight.bold),),
                                        FutureBuilder(
                                          future: _selectedCar==""?DatabaseHelper.instance.retrieveAttrs(0):DatabaseHelper.instance.retrieveAttrs(int.parse(_selectedCar)),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            return ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: intervalos.length>0?intervalos.length:0,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Card ( 
                                                  child: Padding ( 
                                                    padding: const EdgeInsets.all (16.0), 
                                                    child: RichText( 
                                                        text: new TextSpan(
                                                          text: intervalos[index].name, 
                                                          style: DefaultTextStyle.of(context).style,
                                                          children: <TextSpan>[
                                                            new TextSpan(text: ': ', style: DefaultTextStyle.of(context).style, ),
                                                            new TextSpan(text: intervalos[index].value , style: DefaultTextStyle.of(context).style, ),
                                                          ],
                                                        ),
                                                      ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        Text(atributos.length>0?'Informacion de usuario: ':'No se econtro informacion de la unidad', style: new TextStyle(fontWeight: FontWeight.bold),),
                                        FutureBuilder(
                                          future:  _selectedCar==""?DatabaseHelper.instance.retrieveAttrs(0):DatabaseHelper.instance.retrieveAttrs(int.parse(_selectedCar)),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            return ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: atributos.length>0?atributos.length:0,
                                              itemBuilder: (BuildContext context, int index) {
                                                  return Card (
                                                    child: Padding (
                                                      padding: const EdgeInsets.all (16.0),
                                                      child: RichText(
                                                          text: new TextSpan(
                                                            text: atributos[index].name,
                                                            style: DefaultTextStyle.of(context).style,
                                                            children: <TextSpan>[
                                                              new TextSpan(text: ': ', style: DefaultTextStyle.of(context).style, ),
                                                              new TextSpan(text: atributos[index].value , style: DefaultTextStyle.of(context).style, ),
                                                            ],
                                                          ),
                                                        ),
                                                    ),
                                                  );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );

                  } else if (snapshot.hasError) {
                    throw snapshot.error;
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: DropdownButton(
                          hint: Text(
                              'espere un momento...'), // Not necessary for Option 1
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
                    print(unit.id);
                    Navigator.of(context).pushReplacement(FadePageRoute(
                      builder: (context) => new AlistamientoScreen(
                        data: unit,
                      ),
                    ));
                    //_saveURL(_urlCtrler.text);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(auxJson),
              ),
            ],
          ),
        ),
      ),
    );
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
    preferences.remove('user');
    preferences.remove('pass');
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (_) => false,
    );
  }
}
