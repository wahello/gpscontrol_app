import 'package:EnlistControl/app_theme.dart';
import 'package:EnlistControl/custom_drawer/drawer_user_controller.dart';
import 'package:EnlistControl/custom_drawer/home_drawer.dart';
import 'package:EnlistControl/feedback_screen.dart';
import 'package:EnlistControl/help_screen.dart';
import 'package:EnlistControl/helper/DatabaseHelper.dart';
import 'package:EnlistControl/home_screen.dart';
import 'package:EnlistControl/invite_friend_screen.dart';
import 'package:EnlistControl/models/atribute.dart';
import 'package:EnlistControl/models/vehiculos.dart';
import 'package:flutter/material.dart';
import 'package:EnlistControl/models/users.dart';
import 'package:EnlistControl/models/pseudouser.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NavigationHomeScreen extends StatefulWidget {
  final User userData;
  NavigationHomeScreen({this.userData});
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  User baseUser;
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;
  PseudoUser user;
  String username;
  List<Intervalo> intervalos;
  List<Atribute> atributos;

  @override
  void initState() {
    baseUser = widget.userData;
    username = baseUser.name;
    initPseudoUser();
    //user.setVehiculos(vehiculos);
    drawerIndex = DrawerIndex.HOME;
    screenView = MyHomePage(
      user: user,
    );
    super.initState();
  }

  void initPseudoUser() {
    user = new PseudoUser(baseUser);
    intervalos = [];
    atributos = [];
    var sid;
    var token='53dac8bfe1c32941e9a7b7121196dfe262A6A9DF693E8274C23FD67398B9AFDED9E5FE4F';
    var uri = "https://hst-api.wialon.com/wialon/ajax.html?svc=token/login&params={%22token%22:%22$token%22}";
    http.get(uri).then((res){
      if(res.statusCode == 200){
        var jsonResponse = convert.jsonDecode(res.body);
        sid = jsonResponse['eid'];
        baseUser.setSID(sid);
        print('sid: '+sid);
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
            var vehCap = new Vehiculo(vehId.toString(), vehName);
            user.setVehiculo(vehCap);
            _saveVehicle(vehCap);
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
            user.setJson(rec);
            print(rec);
            //print('se guardo ' + user.name);
            }
          }else{
            print('no se encontraron registros por lo cual crearemos el nuevo driver');
            Map<String, dynamic> map = {
              'id_wia': int.parse(baseUser.id),
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
                user.setID(int.parse(res.getResult()));
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: FutureBuilder(
          future: conexionPrincipal(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                backgroundColor: AppTheme.nearlyWhite,
                body: DrawerUserController(
                  screenIndex: drawerIndex,
                  drawerWidth: MediaQuery.of(context).size.width * 0.75,
                  animationController:
                      (AnimationController animationController) {
                    sliderAnimationController = animationController;
                  },
                  onDrawerCall: (DrawerIndex drawerIndexdata) {
                    changeIndex(drawerIndexdata);
                  },
                  screenView: screenView,
                ),
              );
            } else if (snapshot.hasError) {
              throw snapshot.error;
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = MyHomePage(
            user: user,
          );
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteFriend();
        });
      } else {
        //do in your way......
      }
    }
  }
}
