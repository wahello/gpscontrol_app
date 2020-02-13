import 'dart:async';
import 'dart:core';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:EnlistControl/helper/DatabaseHelper.dart';
import 'package:EnlistControl/models/users.dart';
import 'package:EnlistControl/models/vehiculos.dart';
import 'package:EnlistControl/ui/login.dart';
import 'package:http/http.dart' as http;
import 'package:EnlistControl/models/alistamiento.dart';
import 'package:EnlistControl/models/pseudouser.dart';
import 'package:EnlistControl/ui/alistamientos.dart';
import 'package:flutter/material.dart';
import 'package:EnlistControl/data/services/odoo_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:EnlistControl/data/services/globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_route.dart';
import 'package:EnlistControl/models/post.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:EnlistControl/models/unit.dart';
import 'package:EnlistControl/models/atribute.dart';
import 'package:flutter_login/src/widgets/gradient_box.dart';
import 'package:EnlistControl/common/utils.dart';
import 'package:intl/intl.dart';


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
  String msg = 'Seleccione Vehiculo';
  Color btnColor = Colors.blueGrey;
  var itemCount;
  String auxJson = '';
  PseudoUser user;
  Vehiculo vehiculo;
  PseudoUnit unit;
  String sid;
  List<Intervalo> intervalos;
  List<Atribute> atributos;
  String _selectedCar;
  User baseUser;
  Widget screenView;
  AnimationController sliderAnimationController;
  String username;
  Utils utils = new Utils();
  List<Alistamiento> alistamientos;
  List<Alistamiento> invertAlistamientos;
  bool loadedEnlist;
  String imgLink;
  DateFormat dateFormat;
  String unitname;


  bool flagAtributes;
  Duration get loginTime => Duration(seconds: 4);

  @override
  void initState() {
    dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    alistamientos = [];
    initPseudoUser();
    super.initState();
  }

  normalinit()async{
    preferences = await SharedPreferences.getInstance();
    print("inicio el normal init ... ");
    //user = widget.data;
    intervalos = user.intervalos;
    atributos = user.atributos;
    var recId = int.parse(vehiculo.id);
    print("se supone que se creo la variable recId: $recId");
    _selectedCar = "";
    unit = new PseudoUnit(await getIdOdoo(recId), vehiculo.name);
    unit.setUser(user);
    unit.setIdUser(user.id);
    print('se inicializo correctamente la data');
  }

   void initPseudoUser() async{
     var status = await DatabaseHelper.instance.initializeDatabase();
    print(status);
    baseUser = widget.data;
    username = baseUser.name;
    unitname = baseUser.nameU;
    user = new PseudoUser(baseUser);
    intervalos = [];
    atributos = [];
    var token='53dac8bfe1c32941e9a7b7121196dfe262A6A9DF693E8274C23FD67398B9AFDED9E5FE4F';
    var uri = "https://hst-api.wialon.com/wialon/ajax.html?svc=token/login&params={%22token%22:%22$token%22}";
    http.get(uri).then((res){
      if(res.statusCode == 200){
        var jsonResponse = convert.jsonDecode(res.body);
        sid = jsonResponse['eid'];
        baseUser.setSID(sid);
        print('sid: '+sid);
        user.setBaseUser(baseUser);
        var id = baseUser.idU;
        var url = "https://hst-api.wialon.com/wialon/ajax.html?svc=core/search_item&params={%22id%22:$id,%22flags%22:4611686018427387903}&sid=$sid";
        http.get(url).then((res){
          if(res.statusCode == 200){
            var jsonResponse = convert.jsonDecode(res.body);
            print('--------');
            print(jsonResponse);
            var item = jsonResponse['item'];
            var vehId = item['id'];
            var vehName = item['nm'];
            vehiculo = new Vehiculo(vehId.toString(), vehName);
            user.setVehiculo(vehiculo);
            _saveVehicle(vehiculo);
            var imgUri = item['uri'];
            user.setImg(imgUri);
            if(item.containsKey("si")){
              Map si = item['si'];
              print('hey intervalos servicio...');
              if(si!=null){
                for (var i in si.values) {
                  print(i);
                  /*var name = jsonResponse['item']['aflds'][i]['n'];
                  var value = jsonResponse['item']['aflds'][i]['v'];*/
                  var interval = new Intervalo(
                      name: i['n'],
                      desc: i['t'],
                      iK: i['im'],
                      iD: i['it'],
                      iH: i['ie'],
                      pm: i['pm'],
                      pt: i['pt'],
                      pe: i['pe'],
                      c: i['c']);
                  print('El valor del intervalo es ...'+interval.calculateInterval());
                  intervalos.add(interval);
                  //_saveInterval(interval, vehId);
                }
                user.setIntervals(intervalos);
              }else{
                print('El vehiculo no tiene intervalos');
              }
            }
            if(item.containsKey("aflds")){
              Map aflds = item['aflds'];
              print('hey admin flds...');
              print('el objeto contiene la clave aflds');
              if(aflds!=null){
                for (var i in aflds.values) {
                  var atribute = new Atribute(name: i['n'], value: i['v']);
                  //_saveAttr(atribute, vehId);
                  atributos.add(atribute);
                  /*var name = jsonResponse['item']['aflds'][i]['n'];
                var value = jsonResponse['item']['aflds'][i]['v'];
                var atribute = new Atribute(name: name, value: value);
                lista.add(atribute);*/
                }
              }else{
                print('no tienes propiedades administrativas');
              }
            }
            if(item.containsKey("pflds")){
              Map pflds = item['pfdls'];
              print('hey personalized flds...');
              print('el objeto contiene la clave pflds');
              if(pflds!=null){
                for (var i in pflds.values) {
                print(i);
                var atribute = new Atribute(name: i['n'], value: i['v']);
                atributos.add(atribute);
                //_saveAttr(atribute, vehId);
                /*var name = jsonResponse['item']['aflds'][i]['n'];
                var value = jsonResponse['item']['aflds'][i]['v'];
                var atribute = new Atribute(name: name, value: value);
                lista.add(atribute);*/
                }
              }else{
                print('no tienes propiedades personalizadas');
              }
              
            }
            user.setAttrib(atributos);
        /*for(var i in items){
          var id = i['id'];
          var name = i['nm'];
          var userCaption = new Vehiculo(id.toString(), name);
          _saveVehicle(userCaption);
          vehiculos.add(userCaption);
          print('se añadio ${userCaption.name}');
        }*/
        normalinit();
          }else{
            print('algo salio mal');
          }
          
        });
        
      }
    });


    }
    //user = new PseudoUser(0, '', '', baseUser);

  _saveVehicle(Vehiculo vehicle) async {
    DatabaseHelper.instance.insertVehicle(vehicle);
  }
  _saveAlistamiento(Alistamiento alistamiento){
    alistamientos.add(alistamiento);
  }
  
  
  //get data wialon of server
  Future<String> conexionPrincipal() async {
    var client = OdooClient("http://66.228.39.68:8069");
    var auth =
        await client.authenticate('appbot', 'iopunjab1234!', "smart_contro");
    if (auth.isSuccess) {
      print("Bienvenido ${baseUser.name}");
      print('the sesion id is: ' + auth.getSessionId());
      var name_user = auth.getUser().name;
      print('hola .. se conecto a al servidor con el usuario ' + name_user);
      print('se buscara a ' + username);
      client.searchRead('gpscontrol.wialon_driver', [
        ['name', '=', '$username']
      ], [
        'id',
        'id_wia',
        'name'
      ]).then((res) {
        if (res.hasError()) {
          print('algo salio mal ${res.getError()}');
        } else {
          var result = res.getResult();
          if(result['length'] == 1){
            for (var rec in result['records']) {
              print('buscaremos los alistamientos de: ${rec['name']}');
              client.searchRead('gpscontrol.alistamientos', [
                ['partner_id.id', '=', '${rec['id']}']
                ], [
                  'id',
                  'folio',
                  'vehiculo',
                  'partner_id',
                  'fecha',
                  'state'
                ]).then((res){
                   var resEnlist = res.getResult();
                   if(res.hasError()){
                     print(res.getError());
                   }else{
                    var getEnlist = resEnlist['records'];
                    for(var alistamiento in getEnlist){
                      print(alistamiento);
                      var nuevoAlistamiento = new Alistamiento.basicJson(alistamiento);
                      _saveAlistamiento(nuevoAlistamiento);
                    }
                    
                   }
                });
            user.setJson(rec);
            print(rec);
            //print('se guardo ' + user.name);
            }
            
          }else{
            print('no se encontraron registros por lo cual crearemos el nuevo driver');
            Map<String, dynamic> map = {
              'id_wia': baseUser.id,
              'name': baseUser.name,
              'password': baseUser.passwd,
              'telefono': baseUser.token,
            };
            client.create('gpscontrol.wialon_driver', map).then((res) {
              if (res.hasError()) {
                print('algo salio mal marica');
                print(res.getError());
                return 'algo salio mal ...';
              } else {
                print('este es el resultado de crear el nuevo driver: ${res.getResult()}');
                user.setID(res.getResult());
                return 'ok';
              }
            });
          }
          
          //preferences.setInt('id_user', pseudoUser.id);
        }
      });

      //_save(auth.getSessionId(),name_user,loginData.name,loginData.password);
      //isLoggedIn = true;
      return 'ok';
    } else {
      print("Algo salio mal. :s ");
      //isLoggedIn = false;
      return 'bad';
    }
  }


  Future<int> getIdOdoo(idWia) async {
    //preferences = await SharedPreferences.getInstance();
    voidMethod();
    var client = OdooClient("http://66.228.39.68:8069");
    var auth = await client.authenticate('appbot', 'iopunjab1234!',"smart_contro");
    int result = 0;
    if(auth.isSuccess){
      print("idWia: $idWia");
      client.searchRead('gpscontrol.wialon_unit', [['id_wialon','=',idWia]], ['id','name']).then((res){
        if(res.hasError()){
          print('algo salio mal marica');
          return 0;
        }else{
          var data = res.getResult();
          print("el resultado de odoo es:");
          print(data);
          for(var rec in data['records']){
            print('Holis ' +rec['id'].toString());
            result = rec['id'];
            unit.setId(result);
            
            
          }
          
          
        }
      });
      return result;
    }else{
      return 99999;
    }
  }

  Future<String> checkAvalibleAttrs() {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
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
  _checkFirstTime() async {
    alistamientos = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString("img") != null) {
    imgLink = prefs.getString("img");
   }
  }
  

  Future<String> voidMethod()async{
    _checkFirstTime();
    await conexionPrincipal();
    var log;
    return Future.delayed(loginTime).then((val){
      var inversed = alistamientos.reversed;
      alistamientos = inversed.toList();
      log = "ok";
      flagAtributes = true;
      btnColor = Colors.blue;
      print("aqui va el resultado de alistamientos!!!!!!!!!!!!!!.....");
      print(alistamientos);
      return log;
    });
  }
 

  Future<bool> _goToLogin(BuildContext context) {
    SharedPreferences.getInstance().then((preferences){
      preferences.setString("user", null);
      preferences.setString("pass", null);
      preferences.setString("idU", null);
      preferences.setString("nameU", null);
      preferences.setString("tel", null);
      preferences.setString("sid", null);
      preferences.setString("Uid", null);
    });
    DatabaseHelper.instance.clearDb();
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
    brightness:     Brightness.light,
    primaryColor:   Color(0xbb0032),
    accentColor:    Color(0xff00ff32),
);
    List<String> _locations = []; // Option 2
    flagAtributes = false;
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff000000),
                Color(0xff282828),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(75.0), // here the desired height
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top:30, left: 25),
                    child:  Image.asset("assets/logo2.png", width: 220,),
                  ),
                  Positioned(
                    top: 30,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.only(top: 1, left: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                                  tooltip: "Salir de la app.",
                                  icon: Icon(utils.getIconForName('salir'), size: 30.0),
                                  color: Color(0xff8c8c8c),
                                  onPressed: () {
                                    _goToLogin(context);
                                  },
                                ),
                        Text('SALIR', style: TextStyle(color: Color(0xff8c8c8c), fontWeight: FontWeight.w800, fontSize: 12),),
                        ],
                      ),
                    ),),
                ],
              ),
            ),
            body: TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                new Container(
                  child: Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned(
                                  child: Container(
                                    padding: new EdgeInsets.fromLTRB(25, 50, 25, 50),
                                    child: FutureBuilder(
                                      future: voidMethod(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          return Container(
                                            child: Column(
                                              children: <Widget>[
                                                Card(
                                                    shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50)
                                                    ),
                                                    color: Color(0xff282828),
                                                    child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            decoration: new BoxDecoration(
                                                                color: Color(0xff464646),
                                                                borderRadius: new BorderRadius.only(
                                                                    topLeft:  const  Radius.circular(50.0),
                                                                    topRight: const  Radius.circular(50.0)
                                                                    )
                                                            ),
                                                            padding: const EdgeInsets.only(left: 26, top: 26, bottom: 20),
                                                            child: Column(
                                                              children: <Widget>[
                                                                Row(
                                                                  children: <Widget>[
                                                                    Container(
                                                                      width: 55.0,
                                                                      height: 55.0,
                                                                      decoration: new BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          image: new DecorationImage(
                                                                          fit: BoxFit.fill,
                                                                          image: imgLink!=null?NetworkImage(imgLink):FileImage(File("assets/images/userImage.png")),
                                                                          )
                                                                        ),
                                                                      ),
                                                                    Container(
                                                                      padding: EdgeInsets.only(left: 10),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: <Widget>[
                                                                          Row(
                                                                            children: <Widget>[
                                                                              username != null ?Text(
                                                                                'Hola, $username',
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w900,
                                                                                  color: Colors.white,
                                                                                  fontSize: 22,
                                                                                  ),
                                                                                ):
                                                                                Text(""),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: <Widget>[
                                                                              Text(
                                                                                 'Vehiculo $unitname',
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Color(0xff00ff32),
                                                                                  fontSize: 18,
                                                                                  ),
                                                                                )


                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                      
                                                                    ),
                                                                  ],
                                                                ),      
                                                              ],
                                                            ),
                                                          ),
                                                        Container(
                                                          padding: EdgeInsets.only(left:7, right: 7, top: 20),
                                                          child: Column(
                                                            children: <Widget>[
                                                              
                                                              Padding(
                                                                padding: EdgeInsets.all(4.0),
                                                                child:FutureBuilder(
                                                                  future: DatabaseHelper.instance.retrieveAttrs(baseUser.idU),
                                                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                                     if (!snapshot.hasData) {
                                                                        return Center(
                                                                          child: Text(
                                                                            "cargando: ",
                                                                          ),
                                                                        );
                                                                    }else{
                                                                        return ListView.builder(
                                                                        padding: EdgeInsets.only(bottom: 4, left: 10),
                                                                        scrollDirection: Axis.vertical,
                                                                        shrinkWrap: true,
                                                                        itemCount: atributos.length,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          if(atributos[index].value!=""){
                                                                            return Padding(
                                                                              padding: EdgeInsets.all(3),
                                                                              child: Row(
                                                                                    children: <Widget>[
                                                                                      Text("${atributos[index].name} : ",style: TextStyle(color: Color(0xffffffff) ,fontSize: 14 ,fontWeight: FontWeight.w800),),
                                                                                      Text("${atributos[index].value}", style:  TextStyle(color: Color(0xffdcdcdc) ,fontSize: 14, ),)
                                                                                    ],
                                                                                  ),
                                                                            );
                                                                          }else{
                                                                            return SizedBox.shrink();
                                                                          }
                                                                        },
                                                                      );
                                                                    }

                                                                  },
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.all(15.0),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    intervalos.length>0?Text('Intervalos de servicio ', style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w700, color: Color(0xff00ff32)),):Text('No se encontraron intervalos de servicio.', style: TextStyle(fontSize: 12 ,fontWeight: FontWeight.w300, color: Color(0xffff0032)),),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.all(4.0),
                                                                child: FutureBuilder(
                                                                  future: DatabaseHelper.instance.retrieveSI(baseUser.idU),
                                                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                                    if (snapshot.hasError) {
                                                                        return Center(
                                                                          child: Text(
                                                                            "ERROR: " + snapshot.error.toString(),
                                                                          ),
                                                                        );
                                                                    }else{
                                                                      return ListView.builder(
                                                                        padding: EdgeInsets.only(bottom: 30, left: 10),
                                                                        scrollDirection: Axis.vertical,
                                                                        shrinkWrap: true,
                                                                        itemCount: intervalos.length,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return Padding(
                                                                            padding: EdgeInsets.all(3),
                                                                            child: Row(
                                                                                  children: <Widget>[
                                                                                    Text('${intervalos[index].name} : ', style: TextStyle(color: Colors.white ,fontSize: 14,fontWeight: FontWeight.w800), ),
                                                                                    Text(intervalos[index].calculateInterval() , style: TextStyle(color: Color(0xffdcdcdc), fontSize: 14),),
                                                                                  ],
                                                                                ),
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          
                                                        ),
                                                        Container(
                                                          decoration: new BoxDecoration(
                                                              color: Color(0xff00ff32),
                                                              borderRadius: new BorderRadius.only(
                                                                  bottomLeft:  const  Radius.circular(50),
                                                                  bottomRight: const  Radius.circular(50)
                                                                  )
                                                          ),
                                                          height: 70,
                                                          child: Center(
                                                            child: FlatButton(
                                                              onPressed: () {
                                                                /*...*/
                                                                print(unit.id);
                                                                Navigator.of(context).pushReplacement(FadePageRoute(
                                                                  builder: (context) => new AlistamientoScreen(
                                                                    data: unit,
                                                                  ),
                                                                ));
                                                              },
                                                              child: Text("Iniciar Alistamiento",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w900,
                                                                      fontFamily: "Roboto",
                                                                      color: Colors.black,
                                                                      fontSize: 17)),
                                                              ),
                                                            ),
                                                          ),
                                                          
                                                              
                                                        ],
                                                      ),
                                                    
                                                  ),
                                              ],
                                            )
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              "ERROR: " + snapshot.error.toString(),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Color(0xff00ff32),
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                        
                      ],
                    ),
                  
                  ),
                new Container(
                  child: Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned(
                                  child: Container(
                                    padding: new EdgeInsets.fromLTRB(25, 30, 25, 30),
                                    child: Card(
                                      color: Color(0x00000000),
                                      elevation: 20.0,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            decoration: new BoxDecoration(
                                                color: Color(0xff464646),
                                                borderRadius: new BorderRadius.only(
                                                    topLeft:  const  Radius.circular(60.0),
                                                    topRight: const  Radius.circular(60.0)
                                                    )
                                            ),
                                            height: 100,
                                            child: Center(
                                              child: Image.asset('assets/icon/logo.png', width: 200,),
                                            )
                                          ),
                                          Container(
                                            decoration: new BoxDecoration(
                                                color: Color(0xff282828),
                                            ),
                                            height: 230,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 50, bottom: 20, left:40 , right: 40),
                                              child: Column(
                                                children: <Widget>[
                                                  Text("Nosotros somos...",
                                                  style: TextStyle(
                                                      height: 0.7,
                                                      fontWeight: FontWeight.w800,
                                                      color: Color(0xffdcdcdc),
                                                      fontSize: 40)),
                                                  Padding(padding: EdgeInsets.only(top:10)),
                                                  Text("La plataforma #1 del mundo en rastreo satelital GPS para personas y vehículos; Además contamos con los mejores precios de Colombia",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(0xff8c8c8c),
                                                      fontSize: 13)),
                                                ],
                                              ),
                                              ),
                                          ),
                                          Container(
                                            decoration: new BoxDecoration(
                                                color: Color(0xff00ff32),
                                                borderRadius: new BorderRadius.only(
                                                    bottomLeft:  const  Radius.circular(60.0),
                                                    bottomRight: const  Radius.circular(60.0)
                                                    )
                                            ),
                                            height: 70,
                                            child: Center(
                                              child: FlatButton(
                                                onPressed: () {
                                                  /*...*/
                                                  _launchURL();
                                                  
                                                },
                                                child: Text("Ir a sitio web",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                                      fontFamily: "Roboto",
                                                        color: Colors.black,
                                                        fontSize: 17)
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),    
                                    ), 
                                  ),
                                ),                              
                              ],
                            ),
                          ),
                        
                        
                      ],
                    ),
                  ),
                  
                new Container(
                  child: SingleChildScrollView(
                    child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(25, 30, 25, 30),
                              child: Card(
                                color: Color(0x00ffffff),
                                elevation: 20.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: new BoxDecoration(
                                          color: Color(0xff464646),
                                          borderRadius: new BorderRadius.only(
                                              topLeft:  const  Radius.circular(60.0),
                                              topRight: const  Radius.circular(60.0)
                                              )
                                      ),
                                      height: 70,
                                      child: Center(
                                        child: Text("SOPORTE", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),),
                                      )
                                    ),
                                    Container(
                                      decoration: new BoxDecoration(
                                          color: Color(0xff282828),
                                      ),
                                      height: 260,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30, bottom: 20, left:40 , right: 40),
                                        child: Column(
                                          children: <Widget>[
                                            Text("Cómo podemos ayudarle?",
                                            style: TextStyle(
                                                height: 0.9,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xffdcdcdc),
                                                fontSize: 40)),
                                            Padding(padding: EdgeInsets.only(top:10)),
                                            Text("Parece que tiene problemas con nuestro proceso de registro. Estamos aqui para ayudarle, asi que no dude en ponerse en contacto con nosotros.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff8c8c8c),
                                                fontSize: 13)),
                                          ],
                                        ),
                                        ),
                                    ),
                                    Container(
                                      decoration: new BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: new BorderRadius.only(
                                              bottomLeft:  const  Radius.circular(60.0),
                                              bottomRight: const  Radius.circular(60.0)
                                              )
                                      ),
                                      height: 70,
                                      child: Center(
                                        child: FlatButton(
                                          onPressed: () {
                                            /*...*/
                                            whatsappAct();
                                            
                                          },
                                          child: Text("Contáctenos",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: "Roboto",
                                                  color: Colors.black,
                                                  fontSize: 17)
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),    
                              ), 
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                ),
                new Container(
                  child: SingleChildScrollView(
                    child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(25, 30, 25, 30),
                              child: FutureBuilder(
                                future: voidMethod(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    return Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Card(
                                              shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50)
                                              ),
                                              color: Color(0xff282828),
                                              child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                    decoration: new BoxDecoration(
                                                        color: Color(0xff464646),
                                                        borderRadius: new BorderRadius.only(
                                                            topLeft:  const  Radius.circular(50.0),
                                                            topRight: const  Radius.circular(50.0)
                                                            )
                                                      ),
                                                    height: 70,
                                                    child: Center(
                                                      child: Text("HISTORIAL", style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w700),),
                                                    ),
                                                    ),
                                                    alistamientos.isEmpty?Container(
                                                      height: 300,
                                                      child: Center(
                                                        child: Text("Aún no hay alistamientos", style: TextStyle(color: Colors.white30, fontFamily: "Roboto" )),
                                                      ),
                                                    ):Container(
                                                      height: 320,
                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08, top: 26),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                            alistamientos.length==0?Text(""):alistamientos.length==1?Text("Alistamiento cargado satisfactoriamente", style: TextStyle(color: Color(0xff00ff32), fontSize: 12)):Text("Alistamientos cargados satisfactoriamente", style: TextStyle(color: Color(0xff00ff32), fontSize: 9)),
                                                            alistamientos.isEmpty?Text(""):Container(
                                                              padding: EdgeInsets.only(top:15),
                                                              color: Color(0xff282828),
                                                              child: Container(
                                                                color: Color(0xff282828),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top:15, bottom: 15),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: <Widget>[
                                                                          alistamientos.length==0?Text(""):Text("No. Alistamiento: ${alistamientos[0].folio}", style: TextStyle(color: Color(0xff8c8c8c), fontSize: 11.0,)),
                                                                          alistamientos.length==0?Text(""):Text("Fecha: ${dateFormat.format(alistamientos[0].fecha.subtract(Duration(hours: 5)))}", style: TextStyle(color: Color(0xffdcdcdc), fontSize: 11.0,),),
                                                                          alistamientos.length==0?Text(""):Text("Vehiculo: ${alistamientos[0].vehiculo}", style: TextStyle(color: Color(0xff00ff32), fontSize: 11.0,),),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
                                                                      child: alistamientos.length==0?Text(""):alistamientos[0].state=="creado"?Icon(utils.getIconForName('ok'), color: Color(0xff00ff32),):Icon(utils.getIconForName('bad'), color: Color(0xffff0032),),
                                                                    ),
                                                                  ],
                                                                )
                                                              ),
                                                            ),
                                                            alistamientos.isEmpty?Text(""):Container(
                                                              color: Color(0xff282828),
                                                              child: Container(
                                                                color: Color(0xff282828),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top:25, bottom: 15),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: <Widget>[
                                                                          alistamientos.length <= 1?Text(""):Text("No. Alistamiento: ${alistamientos[1].folio}", style: TextStyle(color: Color(0xff8c8c8c), fontSize: 11.0,),),
                                                                          alistamientos.length <= 1?Text(""):Text("Fecha: ${dateFormat.format(alistamientos[1].fecha.subtract(Duration(hours: 5)))}", style: TextStyle(color: Color(0xffdcdcdc), fontSize: 11.0,),),
                                                                          alistamientos.length <= 1?Text(""):Text("Vehiculo: ${alistamientos[1].vehiculo}", style: TextStyle(color: Color(0xff00ff32), fontSize: 11.0,),),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
                                                                      child: alistamientos.length <= 1?Text(""):alistamientos[1].state=="creado"?Icon(utils.getIconForName('ok'), color: Color(0xff00ff32),):Icon(utils.getIconForName('bad'), color: Color(0xffff0032),),
                                                                    ),
                                                                  ],
                                                                )
                                                              ),
                                                            ),
                                                            alistamientos.isEmpty?Text(""):Container(
                                                              color: Color(0xff282828),
                                                              child: Container(
                                                                color: Color(0xff282828),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top:25),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: <Widget>[
                                                                          alistamientos.length <= 2?Text(""):Text("No. Alistamiento: ${alistamientos[2].folio}", style: TextStyle(color: Color(0xff8c8c8c), fontSize: 11.0,),),
                                                                          alistamientos.length <= 2?Text(""):Text("Fecha: ${dateFormat.format(alistamientos[2].fecha.subtract(Duration(hours: 5)))}", style: TextStyle(color: Color(0xffdcdcdc), fontSize: 11.0,),),
                                                                          alistamientos.length <= 2?Text(""):Text("Vehiculo: ${alistamientos[2].vehiculo}", style: TextStyle(color: Color(0xff00ff32), fontSize: 11.0,),),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
                                                                      child: alistamientos.length <= 2?Text(""):alistamientos[2].state=="creado"?Icon(utils.getIconForName('ok'), color: Color(0xff00ff32),):Icon(utils.getIconForName('bad'), color: Color(0xffff0032),),
                                                                    ),
                                                                  ],
                                                                )
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                    
                                                  ],
                                                ),
                                              
                                            ),
                                        ],
                                      )
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        "ERROR: " + snapshot.error.toString(),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Color(0xff00ff32),
                                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
              
                ),
              ],
            ),
            bottomNavigationBar: new TabBar(
              tabs: [
                Tab(
                  icon: new Icon(utils.getIconForName('user'), size: 30.0),
                  text: "INICIO",
                ),
                Tab(
                  icon: new Icon(utils.getIconForName('nosotros'), size: 30.0),
                  text: "NOSOTROS"
                ),
                Tab(
                  icon: new Icon(utils.getIconForName('soporte'), size: 30.0),
                  text: "SOPORTE"
                ),
                Tab(
                  icon: new Icon(utils.getIconForName('historia'), size: 30.0),
                  text: "HISTORIAL",
                  )
              ],
              labelColor: Color(0XFF00FF32),
              labelStyle: TextStyle(fontSize: 11),
              unselectedLabelColor: Color(0xff8c8c8c),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Color(0XFF000000),
            ),
            backgroundColor: Color(0x11000000),
          ),
    
        )),
    );
    }
    _launchURL() async {
      const url = 'https://gpscontrol.co';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
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

  whatsappAct() async{
    var phone = '+573174021086';
    var whatsappUrl ="whatsapp://send?phone=$phone";
    await canLaunch(whatsappUrl)? launch(whatsappUrl):print("abra el enlace de la aplicación de WhatsApp o haga un snack bar con notificación de que no hay WhatsApp instalado");
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
