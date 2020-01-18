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
  List<Vehiculo> vehiculos;

  @override
  void initState() {
    initPseudoUser();
    //user.setVehiculos(vehiculos);
    drawerIndex = DrawerIndex.HOME;
    screenView = MyHomePage(
      user: user,
    );
    super.initState();
  }

  void initPseudoUser() {
    baseUser = widget.userData;
    username = baseUser.name;
    vehiculos = [];
    user = new PseudoUser(baseUser);
    user.setVehiculos(vehiculos);
    var sid;
    var token='53dac8bfe1c32941e9a7b7121196dfe262A6A9DF693E8274C23FD67398B9AFDED9E5FE4F';
    var uri = "https://hst-api.wialon.com/wialon/ajax.html?svc=token/login&params={%22token%22:%22$token%22}";
    http.get(uri).then((res){
      if(res.statusCode == 200){
        var jsonResponse = convert.jsonDecode(res.body);
        sid = jsonResponse['eid'];
        baseUser.setSID(sid);
        user.setVehiculos(vehiculos);
        print('sid: '+sid);
        var id = baseUser.idU;
        var url = "https://hst-api.wialon.com/wialon/ajax.html?svc=core/search_item&params={%22id%22:$id,%22flags%22:4611686018427387903}&sid=$sid";
        http.get(url).then((res){
          if(res.statusCode == 200){
            var jsonResponse = convert.jsonDecode(res.body);
            print('--------');
            print(jsonResponse);
            /*var items = jsonResponse['items'];
        for(var i in items){
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
    var status = await DatabaseHelper.instance.initializeDatabase();
    print(status);
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
      /*client.searchRead('gpscontrol.wialon_pseudouser', [
        ['name', '=', '$username']
      ], [
        'id',
        'id_wia',
        'name'
      ]).then((res) {
        if (res.hasError()) {
          print('algo salio mal marica');
        } else {
          result = res.getResult();
          for (var rec in result['records']) {
            user.setJson(rec);
            print('se guardo ' + user.name);
          }
          //preferences.setInt('id_user', pseudoUser.id);
        }
      });*/

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
