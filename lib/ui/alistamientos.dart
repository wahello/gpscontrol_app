import 'dart:wasm';

import 'package:EnlistControl/models/unit.dart';
import 'package:EnlistControl/ui/init_alistamiento.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:EnlistControl/models/preguntas.dart';
import 'package:camera/camera.dart';
import 'package:EnlistControl/common/camara.dart';
import 'package:EnlistControl/models/alistamiento.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_route.dart';
import 'package:EnlistControl/common/utils.dart';
import 'package:EnlistControl/models/caption.dart';
import 'package:odoo_api/odoo_api.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:toast/toast.dart';

class AlistamientoScreen extends StatefulWidget {
  AlistamientoScreen({this.data});
  final data;
  static const routeName = '/alistamientos';
  @override
  _AlistamientoScreenState createState() => _AlistamientoScreenState();
}

class _AlistamientoScreenState extends State<AlistamientoScreen> {
  var preguntas = new List<Pregunta>();
  final values = new List<bool>();
  var colores = new List<Color>();
  var images = new List<String>();
  var buttonColor;
  Utils utils = new Utils();
  SlidableController slidableController = new SlidableController();
  Alistamiento nuevoAlistamiento;
  SharedPreferences preferences;
  PseudoUnit unit;
  bool saving;
  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      var _rotationAnimation = slideAnimation;
      print(nuevoAlistamiento);
      print(_rotationAnimation);
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      var _fabColor = isOpen ? Color(0xff00ff32) : Colors.blue;
      print('entramos al is open chang ' + '$isOpen');
      if (isOpen == true) {
        print('Abrio!');
      } else {
        print('Cerro!!!');
      }
      print(_fabColor);
    });
  }

  _getPreguntas() {
    //API.getUsers().then((response) {
    //  setState(() {
    //    Iterable list = json.decode(response.body);
    //    users = list.map((model) => User.fromJson(model)).toList();
    //  });
    //});
    var list_instructions = [
"Confirme que lleva con usted cédula, licencia de conducción y carnet corporativo.",
"Revise licencia de transito, tarjeta de operación, SOAT, etc.",
"Verifique que la calcomanía esté bien adherida, en buen estado y sea legible.",
"Confirme que la bocina funciona correctamente.",
"Verifique estado y funcionamiento del dispositivo.",
"Confirme que se encuentra en estado óptimo.",
"Confirme que se encuentra en estado óptimo.",
"Revise que cuenta con gato, llave de pernos, 2 señales de carretera y 2 tacos.",
"Confirme que todas las herramientas están en estado óptimo.",
"Verifique estado y funcionalidad de la linterna.",
"Confirme que tiene vigencia, pasador y manómetro. No debe presentar corrosión.",
"Verifique vigencia y estado de todos los elementos.",
"Revise presión de aire, desgaste y que esté asegurada.",
"Verifique estado, claridad y posición de todos los espejos.",
"Revise funcionalidad y estado de todos los cinturones de seguridad.",
"Verifique que el motor no presente fugas ni anomalías.",
"Revise desgaste, presión de aire y ajuste de tuercas.",
"Revise niveles de agua y ajuste de bornes. No debe haber sulfatación.",
"Compruebe estado, funcionamiento y anomalías.",
"Revise que las correas tengan la tensión adecuada.",
"Verifique el ajuste de las tapas del radiador, tanque de combustible y aceite hidráulico.",
"Revise los niveles de agua en el radiador, de aceite hidráulico y de aceite en el motor.",
"Verifique el estado de los filtros de gasolina, aceite y aire.",
"Verifique funcionamiento, estado y nivel de agua.",
"Revise desgaste, estado y funcionamiento.",
"Confirme estado óptimo y funcionamiento correcto.",
"Revise operación y funcionamiento.",
"Verifique luces altas, medias, bajas y de reversa. Revise direccionales y estacionarias.",
"Confirme integridad, limpieza y funcionalidad de toda la silletería.",
"Verifique estado, alineación y limpieza de su silla.",
"Compruebe higiene, integridad y pulcritud del vehículo.",
"Confirme que porta un dispositivo de comunicación con minutos.",
"Revise que exhibe el rutero correcto.",
    ];
    var list_preguntas = [
      "Documentos Conductor",
      "Documentos Vehiculo",
      "Calcomania",
      "Bocinas",
      "Dispositivo de velocidad",
      "Escalera puerta de conductor",
      "Escalera puerta de pasajero",
      "Equipo de Carretera",
      "Herramientas en buen estado",
      "Linterna",
      "Extintor",
      "Botiquin",
      "Llanta de Repuesto",
      "Espejos retrovisores (3)",
      "Cinturones de seguridad",
      "Motor",
      "Llantas",
      "Baterias",
      "Transmision, Direccion",
      "Tension de Correas",
      "Tapas",
      "Niveles",
      "Filtros",
      "Limpiaparabrisas y nivel de agua",
      "Frenos",
      "Freno emergencias",
      "Aire Acondicionado",
      "Luces",
      "Silleteria",
      "Asiento conductor",
      "Aseo interno y externo",
      "Celular con Minutos",
      "Ruteros",
    ];
    slidableController = new SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    for (var index = 0; index < list_preguntas.length; index++) {
      var pregunta = new Pregunta(index, list_preguntas[index], list_instructions[index], null, null);
      preguntas.add(pregunta);
      //slidableController.add(controlador);
      values.add(null);
      colores.add(Colors.white);
      images.add('');
    }
    //_init_alistamiento(values);
  }

  initState() {
    saving = false;
    unit = widget.data;
    buttonColor = Colors.grey;
    super.initState();

    _getPreguntas();
  }

  dispose() {
    super.dispose();
  }

  Future<void> takeApicture(int index) async {
    print('el indice seleccionado es: ' + index.toString());
    // Obtén una lista de las cámaras disponibles en el dispositivo.
    final cameras = await availableCameras();
    // Obtén una cámara específica de la lista de cámaras disponibles
    final firstCamera = cameras.first;
    Caption caption = new Caption(index: index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          camera: firstCamera,
          caption: caption,
        ),
      ),
    );
  }

  validationButtonColor() {
    if(colores.contains(Colors.white)){
      buttonColor = Colors.grey;
    }else if(colores.contains(Colors.grey)){
      buttonColor = Colors.grey;
    }else {
      buttonColor = Color(0xff00ff32);
    }
  }

  String getBase64image(String imageFilePath) {
    File imageFile = File(imageFilePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  Future<void> guardarAlistamiento() async {
    saving = true;
    preferences = await SharedPreferences.getInstance();
    var client = OdooClient("http://66.228.39.68:8069");
    var auth = await client.authenticate('appbot', 'iopunjab1234!', 'smart_contro');
    var prefs = unit.idUser;
    print('este es el id $prefs');
    var vehiculo = unit.id;
    print('el id del vehiculo..'+vehiculo.toString());
    Map<String, dynamic> map = {
      "partner_id": prefs,
      "documentos_conductor": values[0],
      "documentos_vehiculo": values[1],
      "calcomania": values[2],
      "pito": values[3],
      "disp_velocidad": values[4],
      "estado_esc_p_conductor": values[5],
      "estado_esc_p_pasajero": values[6],
      "equipo_carretera": values[7],
      "herramientas": values[8],
      "linterna": values[9],
      "extintor": values[10],
      "botiquin": values[11],
      "repuesto": values[12],
      "retrovisores": values[13],
      "cinturones": values[14],
      "motor": values[15],
      "llantas": values[16],
      "baterias": values[17],
      "transmision": values[18],
      "tension": values[19],
      "tapas": values[20],
      "niveles": values[21],
      "filtros": values[22],
      "parabrisas": values[23],
      "frenos": values[24],
      "frenos_emergencia": values[25],
      "aire": values[26],
      "luces": values[27],
      "silleteria": values[28],
      "silla_conductor": values[29],
      "aseo": values[30],
      "celular": values[31],
      "ruteros": values[32],
      "desc_documentos_conductor": preguntas[0].descripcion,
      "desc_documentos_vehiculo": preguntas[1].descripcion,
      "desc_calcomania": preguntas[2].descripcion,
      "desc_pito": preguntas[3].descripcion,
      "desc_disp_velocidad": preguntas[4].descripcion,
      "desc_estado_esc_p_conductor": preguntas[5].descripcion,
      "desc_estado_esc_p_pasajero": preguntas[6].descripcion,
      "desc_equipo_carretera": preguntas[7].descripcion,
      "desc_herramientas": preguntas[8].descripcion,
      "desc_linterna": preguntas[9].descripcion,
      "desc_extintor": preguntas[10].descripcion,
      "desc_botiquin": preguntas[11].descripcion,
      "desc_repuesto": preguntas[12].descripcion,
      "desc_retrovisores": preguntas[13].descripcion,
      "desc_cinturones": preguntas[14].descripcion,
      "desc_motor": preguntas[15].descripcion,
      "desc_llantas": preguntas[16].descripcion,
      "desc_baterias": preguntas[17].descripcion,
      "desc_transmision": preguntas[18].descripcion,
      "desc_tension": preguntas[19].descripcion,
      "desc_tapas": preguntas[20].descripcion,
      "desc_niveles": preguntas[21].descripcion,
      "desc_filtros": preguntas[22].descripcion,
      "desc_parabrisas": preguntas[23].descripcion,
      "desc_frenos": preguntas[24].descripcion,
      "desc_frenos_emergencia": preguntas[25].descripcion,
      "desc_aire": preguntas[26].descripcion,
      "desc_luces": preguntas[27].descripcion,
      "desc_silleteria": preguntas[28].descripcion,
      "desc_silla_conductor": preguntas[29].descripcion,
      "desc_aseo": preguntas[30].descripcion,
      "desc_celular": preguntas[31].descripcion,
      "desc_ruteros": preguntas[32].descripcion,
      "img_documentos_conductor": preguntas[0].base64Image,
      "img_documentos_vehiculo": preguntas[1].base64Image,
      "img_calcomania": preguntas[2].base64Image,
      "img_pito": preguntas[3].base64Image,
      "img_disp_velocidad": preguntas[4].base64Image,
      "img_estado_esc_p_conductor": preguntas[5].base64Image,
      "img_estado_esc_p_pasajero": preguntas[6].base64Image,
      "img_equipo_carretera": preguntas[7].base64Image,
      "img_herramientas": preguntas[8].base64Image,
      "img_linterna": preguntas[9].base64Image,
      "img_extintor": preguntas[10].base64Image,
      "img_botiquin": preguntas[11].base64Image,
      "img_repuesto": preguntas[12].base64Image,
      "img_retrovisores": preguntas[13].base64Image,
      "img_cinturones": preguntas[14].base64Image,
      "img_motor": preguntas[15].base64Image,
      "img_llantas": preguntas[16].base64Image,
      "img_baterias": preguntas[17].base64Image,
      "img_transmision": preguntas[18].base64Image,
      "img_tension": preguntas[19].base64Image,
      "img_tapas": preguntas[20].base64Image,
      "img_niveles": preguntas[21].base64Image,
      "img_filtros": preguntas[22].base64Image,
      "img_parabrisas": preguntas[23].base64Image,
      "img_frenos": preguntas[24].base64Image,
      "img_frenos_emergencia": preguntas[25].base64Image,
      "img_aire": preguntas[26].base64Image,
      "img_luces": preguntas[27].base64Image,
      "img_silleteria": preguntas[28].base64Image,
      "img_silla_conductor": preguntas[29].base64Image,
      "img_aseo": preguntas[30].base64Image,
      "img_celular": preguntas[31].base64Image,
      "img_ruteros": preguntas[32].base64Image,
      "vehiculo": vehiculo,
    };
    nuevoAlistamiento = new Alistamiento.fromJson(map);
    nuevoAlistamiento.setVehicleName(unit.name);
    if (auth.isSuccess) {
      client.create('gpscontrol.alistamientos', map).then((res) {
        if (res.hasError()) {
          print('algo salio mal marica');
          print(res.getError());
          print(res.getErrorMessage());
          nuevoAlistamiento.setState('creado');
          //_saveTodo(nuevoAlistamiento);
          Toast.show("algo salio mal y no se sincronizo. Se guardo en la base de datos local.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          Navigator.of(context).pushReplacement(FadePageRoute(
                        builder: (context) => InitAlistamiento(
                          data: unit.user.baseUser,
                        ),
                      ));
        } else {
          nuevoAlistamiento.setState('Sincronizado');
          //_saveTodo(nuevoAlistamiento);
          print(res.getResult());
          Toast.show("Se sincronizo correctamente", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          Navigator.of(context).pushReplacement(FadePageRoute(
                        builder: (context) => InitAlistamiento(
                          data: unit.user.baseUser,
                        ),
          ));
        }
      });
    } else {
      Toast.show("No se pudo conectar con el servidor", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
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
                print("se pulso el boton salir");
              },
              child: Text(
                "Salir",
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


  @override
  build(context) {
    return Scaffold(
      // No appBar property provided, only the body.
      body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                 backgroundColor: Color(0xff000000),
                  expandedHeight: 180.0,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(top:25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Image.asset('assets/logo2.png', height: 100, ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverFixedExtentList(
                  itemExtent: 100.0,
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        height: 10,
                          color: Color(0xff000000),
                          child: Container(
                            decoration: new BoxDecoration(
                                color: Color(0xff464646),
                                borderRadius: new BorderRadius.only(
                                    topLeft:  const  Radius.circular(60.0),
                                    topRight: const  Radius.circular(60.0)
                                    )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left:25, top:10, right: 25),
                              child: Center(
                                    child: Text('Alistamiento', style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.w800)),
                                  ),
                            ),
                          ),
                        ),
                      
                      //Slide  
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(0.toString()), size: 50,),
                                          foregroundColor: colores[0],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[0].pregunta , style: TextStyle(fontSize: 17 ,color: colores[0], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[0].instruction , style: TextStyle(fontSize: 12, color: colores[0]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[0].descripcion == null ? '' : preguntas[0].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[0] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[0]==null){
                                                values[0] = true;
                                                colores[0] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[0].descripcion = '';
                                                preguntas[0].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[0] = true;
                                                      colores[0] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[0].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 0);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(1.toString()), size: 50,),
                                          foregroundColor: colores[1],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[1].pregunta , style: TextStyle(fontSize: 17 ,color: colores[1], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[1].instruction , style: TextStyle(fontSize: 12, color: colores[1]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[1].descripcion == null ? '' : preguntas[1].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[1] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[1]==null){
                                                values[1] = true;
                                                colores[1] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[1].descripcion = '';
                                                preguntas[1].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[1] = true;
                                                      colores[1] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[1].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 1);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(2.toString()), size: 50,),
                                          foregroundColor: colores[2],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[2].pregunta , style: TextStyle(fontSize: 17 ,color: colores[2], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[2].instruction , style: TextStyle(fontSize: 12, color: colores[2]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[2].descripcion == null ? '' : preguntas[2].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[2] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[2]==null){
                                                values[2] = true;
                                                colores[2] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[2].descripcion = '';
                                                preguntas[2].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[2] = true;
                                                      colores[2] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[2].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 2);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(3.toString()), size: 50,),
                                          foregroundColor: colores[3],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[3].pregunta , style: TextStyle(fontSize: 17 ,color: colores[3], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[3].instruction , style: TextStyle(fontSize: 12, color: colores[3]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[3].descripcion == null ? '' : preguntas[3].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[3] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[3]==null){
                                                values[3] = true;
                                                colores[3] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[3].descripcion = '';
                                                preguntas[3].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[3] = true;
                                                      colores[3] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[3].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 3);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(4.toString()), size: 50,),
                                          foregroundColor: colores[4],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[4].pregunta , style: TextStyle(fontSize: 17 ,color: colores[4], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[4].instruction , style: TextStyle(fontSize: 12, color: colores[4]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[4].descripcion == null ? '' : preguntas[4].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[4] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[4]==null){
                                                values[4] = true;
                                                colores[4] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[4].descripcion = '';
                                                preguntas[4].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[4] = true;
                                                      colores[4] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[4].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800)),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 4);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(5.toString()), size: 50,),
                                          foregroundColor: colores[5],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[5].pregunta , style: TextStyle(fontSize: 17 ,color: colores[5], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[5].instruction , style: TextStyle(fontSize: 12, color: colores[5]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[5].descripcion == null ? '' : preguntas[5].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[5] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[5]==null){
                                                values[5] = true;
                                                colores[5] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[5].descripcion = '';
                                                preguntas[5].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[5] = true;
                                                      colores[5] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[5].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 5);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(6.toString()), size: 50,),
                                          foregroundColor: colores[6],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[6].pregunta , style: TextStyle(fontSize: 17 ,color: colores[6], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[6].instruction , style: TextStyle(fontSize: 12, color: colores[6]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[6].descripcion == null ? '' : preguntas[6].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[6] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[6]==null){
                                                values[6] = true;
                                                colores[6] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[6].descripcion = '';
                                                preguntas[6].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[6] = true;
                                                      colores[6] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[6].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 6);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(7.toString()), size: 50,),
                                          foregroundColor: colores[7],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[7].pregunta , style: TextStyle(fontSize: 17 ,color: colores[7], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[7].instruction , style: TextStyle(fontSize: 12, color: colores[7]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[7].descripcion == null ? '' : preguntas[7].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[7] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[7]==null){
                                                values[7] = true;
                                                colores[7] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[7].descripcion = '';
                                                preguntas[7].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[7] = true;
                                                      colores[7] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[7].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 7);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(8.toString()), size: 50,),
                                          foregroundColor: colores[8],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[8].pregunta , style: TextStyle(fontSize: 17 ,color: colores[8], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[8].instruction , style: TextStyle(fontSize: 12, color: colores[8]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[8].descripcion == null ? '' : preguntas[8].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[8] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[8]==null){
                                                values[8] = true;
                                                colores[8] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[8].descripcion = '';
                                                preguntas[8].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[8] = true;
                                                      colores[8] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[8].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 8);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(9.toString()), size: 50,),
                                          foregroundColor: colores[9],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[9].pregunta , style: TextStyle(fontSize: 17 ,color: colores[9], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[9].instruction , style: TextStyle(fontSize: 12, color: colores[9]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[9].descripcion == null ? '' : preguntas[9].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[9] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[9]==null){
                                                values[9] = true;
                                                colores[9] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[9].descripcion = '';
                                                preguntas[9].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[9] = true;
                                                      colores[9] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[9].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 9);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(10.toString()), size: 50,),
                                          foregroundColor: colores[10],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[10].pregunta , style: TextStyle(fontSize: 17 ,color: colores[10], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[10].instruction , style: TextStyle(fontSize: 12, color: colores[10]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[10].descripcion == null ? '' : preguntas[10].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[10] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[10]==null){
                                                values[10] = true;
                                                colores[10] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[10].descripcion = '';
                                                preguntas[10].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[10] = true;
                                                      colores[10] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[10].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 10);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(11.toString()), size: 50,),
                                          foregroundColor: colores[11],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[11].pregunta , style: TextStyle(fontSize: 17 ,color: colores[11], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[11].instruction , style: TextStyle(fontSize: 12, color: colores[11]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[11].descripcion == null ? '' : preguntas[11].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[11] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[11]==null){
                                                values[11] = true;
                                                colores[11] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[11].descripcion = '';
                                                preguntas[11].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[11] = true;
                                                      colores[11] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[11].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 11);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(12.toString()), size: 50,),
                                          foregroundColor: colores[12],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[12].pregunta , style: TextStyle(fontSize: 17 ,color: colores[12], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[12].instruction , style: TextStyle(fontSize: 12, color: colores[12]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[12].descripcion == null ? '' : preguntas[12].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[12] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[12]==null){
                                                values[12] = true;
                                                colores[12] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[12].descripcion = '';
                                                preguntas[12].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[12] = true;
                                                      colores[12] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[12].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 12);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(13.toString()), size: 50,),
                                          foregroundColor: colores[13],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[13].pregunta , style: TextStyle(fontSize: 17 ,color: colores[13], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[13].instruction , style: TextStyle(fontSize: 12, color: colores[13]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[13].descripcion == null ? '' : preguntas[13].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[13] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[13]==null){
                                                values[13] = true;
                                                colores[13] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[13].descripcion = '';
                                                preguntas[13].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[13] = true;
                                                      colores[13] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[13].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 13);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(14.toString()), size: 50,),
                                          foregroundColor: colores[14],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[14].pregunta , style: TextStyle(fontSize: 17 ,color: colores[14], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[14].instruction , style: TextStyle(fontSize: 12, color: colores[14]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[14].descripcion == null ? '' : preguntas[14].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[14] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[14]==null){
                                                values[14] = true;
                                                colores[14] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[14].descripcion = '';
                                                preguntas[14].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[14] = true;
                                                      colores[14] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[14].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 14);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(15.toString()), size: 50,),
                                          foregroundColor: colores[15],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[15].pregunta , style: TextStyle(fontSize: 17 ,color: colores[15], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[15].instruction , style: TextStyle(fontSize: 12, color: colores[15]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[15].descripcion == null ? '' : preguntas[15].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[15] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[15]==null){
                                                values[15] = true;
                                                colores[15] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[15].descripcion = '';
                                                preguntas[15].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[15] = true;
                                                      colores[15] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[15].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 15);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(16.toString()), size: 50,),
                                          foregroundColor: colores[16],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[16].pregunta , style: TextStyle(fontSize: 17 ,color: colores[16], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[16].instruction , style: TextStyle(fontSize: 12, color: colores[16]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[16].descripcion == null ? '' : preguntas[16].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[16] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[16]==null){
                                                values[16] = true;
                                                colores[16] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[16].descripcion = '';
                                                preguntas[16].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[16] = true;
                                                      colores[16] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[16].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 16);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(17.toString()), size: 50,),
                                          foregroundColor: colores[17],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[17].pregunta , style: TextStyle(fontSize: 17 ,color: colores[17], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[17].instruction , style: TextStyle(fontSize: 12, color: colores[17]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[17].descripcion == null ? '' : preguntas[17].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[17] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[17]==null){
                                                values[17] = true;
                                                colores[17] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[17].descripcion = '';
                                                preguntas[17].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[17] = true;
                                                      colores[17] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[17].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 17);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(18.toString()), size: 50,),
                                          foregroundColor: colores[18],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[18].pregunta , style: TextStyle(fontSize: 17 ,color: colores[18], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[18].instruction , style: TextStyle(fontSize: 12, color: colores[18]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[18].descripcion == null ? '' : preguntas[18].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[18] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[18]==null){
                                                values[18] = true;
                                                colores[18] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[18].descripcion = '';
                                                preguntas[18].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[18] = true;
                                                      colores[18] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[18].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 18);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(19.toString()), size: 50,),
                                          foregroundColor: colores[19],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[19].pregunta , style: TextStyle(fontSize: 17 ,color: colores[19], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[19].instruction , style: TextStyle(fontSize: 12, color: colores[19]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[19].descripcion == null ? '' : preguntas[19].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[19] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[19]==null){
                                                values[19] = true;
                                                colores[19] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[19].descripcion = '';
                                                preguntas[19].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[19] = true;
                                                      colores[19] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[19].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 19);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(20.toString()), size: 50,),
                                          foregroundColor: colores[20],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[20].pregunta , style: TextStyle(fontSize: 17 ,color: colores[20], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[20].instruction , style: TextStyle(fontSize: 12, color: colores[20]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[20].descripcion == null ? '' : preguntas[20].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[20] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[20]==null){
                                                values[20] = true;
                                                colores[20] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[20].descripcion = '';
                                                preguntas[20].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[20] = true;
                                                      colores[20] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[20].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 20);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(21.toString()), size: 50,),
                                          foregroundColor: colores[21],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[21].pregunta , style: TextStyle(fontSize: 17 ,color: colores[21], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[21].instruction , style: TextStyle(fontSize: 12, color: colores[21]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[21].descripcion == null ? '' : preguntas[21].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[21] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[21]==null){
                                                values[21] = true;
                                                colores[21] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[21].descripcion = '';
                                                preguntas[21].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[21] = true;
                                                      colores[21] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[21].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 21);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(22.toString()), size: 50,),
                                          foregroundColor: colores[22],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[22].pregunta , style: TextStyle(fontSize: 17 ,color: colores[22], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[22].instruction , style: TextStyle(fontSize: 12, color: colores[22]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[22].descripcion == null ? '' : preguntas[22].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[22] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[22]==null){
                                                values[22] = true;
                                                colores[22] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[22].descripcion = '';
                                                preguntas[22].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[22] = true;
                                                      colores[22] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[22].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 22);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(23.toString()), size: 50,),
                                          foregroundColor: colores[23],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[23].pregunta , style: TextStyle(fontSize: 17 ,color: colores[23], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[23].instruction , style: TextStyle(fontSize: 12, color: colores[23]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[23].descripcion == null ? '' : preguntas[23].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[23] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[23]==null){
                                                values[23] = true;
                                                colores[23] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[23].descripcion = '';
                                                preguntas[23].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[23] = true;
                                                      colores[23] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[23].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 23);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(24.toString()), size: 50,),
                                          foregroundColor: colores[24],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[24].pregunta , style: TextStyle(fontSize: 17 ,color: colores[24], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[24].instruction , style: TextStyle(fontSize: 12, color: colores[24]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[24].descripcion == null ? '' : preguntas[24].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[24] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[24]==null){
                                                values[24] = true;
                                                colores[24] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[24].descripcion = '';
                                                preguntas[24].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[24] = true;
                                                      colores[24] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[24].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 24);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(25.toString()), size: 50,),
                                          foregroundColor: colores[25],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[25].pregunta , style: TextStyle(fontSize: 17 ,color: colores[25], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[25].instruction , style: TextStyle(fontSize: 12, color: colores[25]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[25].descripcion == null ? '' : preguntas[25].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[25] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[25]==null){
                                                values[25] = true;
                                                colores[25] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[25].descripcion = '';
                                                preguntas[25].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[25] = true;
                                                      colores[25] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[25].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 25);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(26.toString()), size: 50,),
                                          foregroundColor: colores[26],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[26].pregunta , style: TextStyle(fontSize: 17 ,color: colores[26], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[26].instruction , style: TextStyle(fontSize: 12, color: colores[26]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[26].descripcion == null ? '' : preguntas[26].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[26] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[26]==null){
                                                values[26] = true;
                                                colores[26] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[26].descripcion = '';
                                                preguntas[26].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[26] = true;
                                                      colores[26] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[26].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 26);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(27.toString()), size: 50,),
                                          foregroundColor: colores[27],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[27].pregunta , style: TextStyle(fontSize: 17 ,color: colores[27], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[27].instruction , style: TextStyle(fontSize: 12, color: colores[27]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[27].descripcion == null ? '' : preguntas[27].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[27] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[27]==null){
                                                values[27] = true;
                                                colores[27] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[27].descripcion = '';
                                                preguntas[27].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[27] = true;
                                                      colores[27] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[27].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 27);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(28.toString()), size: 50,),
                                          foregroundColor: colores[28],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[28].pregunta , style: TextStyle(fontSize: 17 ,color: colores[28], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[28].instruction , style: TextStyle(fontSize: 12, color: colores[28]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[28].descripcion == null ? '' : preguntas[28].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[28] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[28]==null){
                                                values[28] = true;
                                                colores[28] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[28].descripcion = '';
                                                preguntas[28].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[28] = true;
                                                      colores[28] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[28].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 28);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(29.toString()), size: 50,),
                                          foregroundColor: colores[29],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[29].pregunta , style: TextStyle(fontSize: 17 ,color: colores[29], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[29].instruction , style: TextStyle(fontSize: 12, color: colores[29]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[29].descripcion == null ? '' : preguntas[29].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[29] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[29]==null){
                                                values[29] = true;
                                                colores[29] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[29].descripcion = '';
                                                preguntas[29].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[29] = true;
                                                      colores[29] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[29].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 29);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(30.toString()), size: 50,),
                                          foregroundColor: colores[30],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[30].pregunta , style: TextStyle(fontSize: 17 ,color: colores[30], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[30].instruction , style: TextStyle(fontSize: 12, color: colores[30]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[30].descripcion == null ? '' : preguntas[30].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[30] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[30]==null){
                                                values[30] = true;
                                                colores[30] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[30].descripcion = '';
                                                preguntas[30].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[30] = true;
                                                      colores[30] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[30].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 30);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(31.toString()), size: 50,),
                                          foregroundColor: colores[31],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[31].pregunta , style: TextStyle(fontSize: 17 ,color: colores[31], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[31].instruction , style: TextStyle(fontSize: 12, color: colores[31]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[31].descripcion == null ? '' : preguntas[31].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[31] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[31]==null){
                                                values[31] = true;
                                                colores[31] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[31].descripcion = '';
                                                preguntas[31].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[31] = true;
                                                      colores[31] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[31].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 31);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          decoration: new BoxDecoration(
                                color: Color(0xff282828),
                                
                            ),
                          child: Slidable(
                                    controller: slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    closeOnScroll: false,
                                    child: Container(
                                      alignment: Alignment(0.0,0.0),
                                      color: Color(0xff282828),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: Color(0xff282828),
                                          child: Icon(utils.getIconForName(32.toString()), size: 50,),
                                          foregroundColor: colores[32],
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          child:Text(preguntas[32].pregunta , style: TextStyle(fontSize: 17 ,color: colores[32], fontWeight: FontWeight.w800)),
                                        ),
                                        subtitle: ListView(
                                          padding: EdgeInsets.all(1),
                                          physics: NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            Text(preguntas[32].instruction , style: TextStyle(fontSize: 12, color: colores[32]==Colors.white?Color(0xffbcbcbc):Colors.grey)),
                                            Text(preguntas[32].descripcion == null ? '' : preguntas[32].descripcion,  style: TextStyle(fontSize: 12, color: Color(0xffff0032)) ),
                                            
                                          ],
                                        ),
                                        onTap: () => {
                                          setState(() {
                                            if (values[32] == true) {
                                              //esta ok
                                              print('pailas .. nononononon !!!');
                                            } else {
                                              //esta en false
                                              if(values[32]==null){
                                                values[32] = true;
                                                colores[32] = Color(0xff00ff32);
                                                validationButtonColor();
                                                preguntas[32].descripcion = '';
                                                preguntas[32].base64Image = '';
                                              }else{
                                                print('pailas... no puedes tapear');
                                              }
                                              
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xff00ff32),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "holis",
                                                    icon: Icon(utils.getIconForName('ok'), size: 30.0,),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      values[32] = true;
                                                      colores[32] = Color(0xff00ff32);
                                                      validationButtonColor();
                                                      preguntas[32].descripcion = '';
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('LISTO!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                    secondaryActions: <Widget>[
                                      Container(
                                       decoration: BoxDecoration(
                                          color: Color(0xffff0032),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              )
                                      ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           IconButton(
                                                    tooltip: "REPORTAR",
                                                    icon: Icon(utils.getIconForName('foto'), size: 30.0),
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      _takeInfoSheet(context, 32);
                                                      slidableController.activeState = null;
                                                    },
                                                  ),
                                          Text('REPORTAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                        ),
                      ),
                      //final containers
                      Container(
                        height: 10,
                        color: Colors.black,
                        child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(40.0), bottomRight: Radius.circular(40.0)),
                                    side: BorderSide(color: Color(0x09282828))),
                                onPressed: () {
                                  print(unit.id);
                                  if (buttonColor == Color(0xff00ff32) && saving==false) {
                                    guardarAlistamiento();
                                    /* */
                                  } else {
                                    print('aun no puedes guardar el alistamiento xD');
                                  }

                                },
                                color: buttonColor,
                                textColor: Colors.black,
                                child: Text("Finalizar Alistamiento",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                            ),
                      ),
                      Container(
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
          ),
      );
    
  }

  void _takeInfoSheet(context, index) async {
    print('el indice seleccionado es: ' + index.toString());
    // Obtén una lista de las cámaras disponibles en el dispositivo.
    final cameras = await availableCameras();
    // Obtén una cámara específica de la lista de cámaras disponibles
    final firstCamera = cameras.first;
    Caption caption = new Caption(index: index);
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                  camera: firstCamera,
                  caption: caption,
                )));

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if (result == null) {
      print('algo salio mal bro, intentelo de nuevo.');
      colores[index] = Colors.grey;
      values[index] = true;
      validationButtonColor();
    } else {
      var desc = result.desc;
      var imagePath = result.imagePath;
      if (imagePath != null && desc != null){
        values[index] = false;
        preguntas[index].descripcion = desc;
        colores[index] = Color(0xffff0032);
        images[index] = imagePath;
        validationButtonColor();
        preguntas[index].base64Image = getBase64image(imagePath);
         Toast.show("Se guardo la evidencia!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        colores[index] = Colors.grey;
        validationButtonColor();
        values[index] = true;
      }
    }
  }
}
