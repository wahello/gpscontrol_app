import 'dart:wasm';

import 'package:EnlistControl/models/unit.dart';
import 'package:EnlistControl/navigation_home_screen.dart';
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
import '../helper/DatabaseHelper.dart';

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
  var buttonColor = Colors.grey;
  Utils utils = new Utils();
  SlidableController slidableController;
  Alistamiento nuevoAlistamiento;
  SharedPreferences preferences;
  PseudoUnit unit;
  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      var _rotationAnimation = slideAnimation;
      print(nuevoAlistamiento);
      print(_rotationAnimation);
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      var _fabColor = isOpen ? Colors.green : Colors.blue;
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
    var list_preguntas = [
      "Documentos Conductor (Cédula, Licencia Conducción, Carné empresa)",
      "Documentos vehiculo (Licencia transito, tarjeta operación, SOAT, poliza RCC y RCE, Revisión tecnicomecánica anual y bimestral, extracto contrato)",
      "Calcomania ''Como conduzco''",
      "Pito",
      "Dispositivo de velocidad",
      "Estado de escalera puerta de conductor",
      "Estado escalera puerta de pasajero",
      "Equipo de Carretera (Gato, Llave de pernos, 2 señales carretera,   2 Tacos)",
      "Herramientas en buen estado",
      "Linterna",
      "Extintor (vigente, pasador, manometro, corrosión)",
      "Botiquin",
      "Llanta de Repuesto",
      "Espejos retrovisores (3)",
      "Cinturon de seguridad conductor y pasajeros",
      "Motor : No existan fugas",
      "Estado de llantas (desgaste, presion de aire)",
      "Baterias: Niveles de Agua, Ajustes de Bornes, Sulfatacion",
      "Revisar: Transmision, Direccion",
      "Tension de Correas",
      "Tapas: de Radiador, de Combustible, de Hidraulico",
      "Niveles de: Agua radiador, Aceite Hidraulico, Aceite de Motor",
      "Revisión Filtros",
      "Estado limpiaprabrisas y nivel de agua",
      "Sistema de Frenos",
      "Freno emergencias",
      "Estado Aire Acondicionado",
      "Luces (altas, medias, bajas, direccionales, estacionarias y reversa)",
      "Estado silleteria",
      "Estado y alineación asiento conductor",
      "Aseo interno y externo",
      "Avantel o Celular con Minutos",
      "Ruteros",
    ];
    slidableController = new SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    for (var index = 0; index < list_preguntas.length; index++) {
      var pregunta = new Pregunta(index, list_preguntas[index], '', '');
      preguntas.add(pregunta);
      //slidableController.add(controlador);
      values.add(false);
      colores.add(Colors.grey);
      images.add('');
    }
    //_init_alistamiento(values);
  }

  initState() {
    unit = widget.data;
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
    if (colores.contains(Colors.grey)) {
      print('aun pailas brother, faltan preguntas por responder.');
      buttonColor = Colors.grey;
    } else {
      if (colores.contains(Colors.red)) {
        print('aun pailas brother, faltan preguntas por responder.');
        buttonColor = Colors.grey;
      } else {
        setState(() {
          buttonColor = Colors.blue;
        });
      }
    }
  }

  String getBase64image(String imageFilePath) {
    File imageFile = File(imageFilePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  Future<void> guardarAlistamiento() async {
    preferences = await SharedPreferences.getInstance();
    var client = OdooClient("http://66.228.39.68:8069");
    var auth = await client.authenticate('appbot', 'iopunjab1234!', "smart_contro");
    var prefs = unit.user.idWia;
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
    nuevoAlistamiento.setFecha();
    nuevoAlistamiento.setVehicleName(unit.name);
    if (auth.isSuccess) {
      client.create('gpscontrol.alistamientos', map).then((res) {
        if (res.hasError()) {
          print('algo salio mal marica');
          print(res.getError());
          nuevoAlistamiento.setState('creado');
          _saveTodo(nuevoAlistamiento);
          return 'algo salio mal ...';
        } else {
          nuevoAlistamiento.setState('Sincronizado');
          _saveTodo(nuevoAlistamiento);
          print(res.getResult());
          Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => NavigationHomeScreen(
              userData: unit.user.baseUser,
            ),
          ));
          return 'ok';
        }
      });
    } else {
      return 'bad';
    }
  }

  _saveTodo(Alistamiento alis) async {
    var status = await DatabaseHelper.instance.initializeDatabase();
    print(status);
    DatabaseHelper.instance.insertTodo(alis);
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alistamientos"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Expanded(
            child: ListView.builder(
              itemCount: preguntas.length,
              itemBuilder: (context, index) {
                var pregunta = preguntas[index].pregunta;
                var id = preguntas[index].id;
                var desc = preguntas[index].descripcion;
                var color = colores[index];
                var value = values[index];
                return Slidable(
                  key: Key(id),
                  actionPane: new SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  closeOnScroll: false,
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: color,
                        child: Icon(utils.getIconForName(id.toString())),
                        foregroundColor: Colors.white,
                      ),
                      title: Text('$pregunta'),
                      subtitle: desc == null ? Text('') : Text('$desc'),
                      onTap: () => {
                        setState(() {
                          if (values[index] == true) {
                            values[index] = false;
                            _takeInfoSheet(context, index);
                            if (preguntas[index].descripcion == '') {
                              colores[index] = Colors.red;
                              validationButtonColor();
                              values[index] = true;
                            } else {
                              colores[index] = Colors.orange;
                              validationButtonColor();
                              values[index] = false;
                            }
                          } else {
                            values[index] = true;
                            colores[index] = Colors.green;
                            validationButtonColor();
                            preguntas[index].descripcion = '';
                            preguntas[index].base64Image = '';
                          }
                        })
                      },
                    ),
                  ),
                  actions: <Widget>[
                    /*new IconSlideAction(
                        caption: 'OK',
                        color: Colors.green,
                        icon: Icons.assignment_turned_in,
                        closeOnTap: false,
                        onTap: () => {

                        },
                      ),*/
                    new SlideAction(
                      key: Key(id),
                      color: Colors.red,
                      child: IconSlideAction(
                        caption: 'OK',
                        color: Colors.green,
                        icon: Icons.assignment_turned_in,
                        closeOnTap: true,
                        onTap: () => {
                          setState(() {
                            values[index] = true;
                            colores[index] = Colors.green;
                            validationButtonColor();
                            preguntas[index].descripcion = '';
                          })
                        },
                      ),
                    ),
                  ],
                  secondaryActions: <Widget>[
                    new IconSlideAction(
                      caption: 'Tomar Foto',
                      color: Colors.red,
                      icon: Icons.add_a_photo,
                      onTap: () => {
                        _takeInfoSheet(context, index),
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          new Padding(
            padding: EdgeInsets.all(15.0),
            child: MaterialButton(
              child: Text(
                "Finalizar Alistamiento",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: buttonColor == Colors.grey ? Colors.grey : Colors.blue,
              onPressed: () {
                if (buttonColor == Colors.blue) {
                  guardarAlistamiento();
                  /* */
                } else {
                  print('aun no puedes guardar el alistamiento xD');
                }
              },
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
    if (result.desc == null) {
      print('algo salio mal bro, intentelo de nuevo.');
      colores[index] = Colors.red;
      values[index] = true;
    } else {
      var desc = result.desc;
      var imagePath = result.imagePath;
      if (imagePath != null) {
        values[index] = false;
        preguntas[index].descripcion = desc;
        colores[index] = Colors.orange;
        images[index] = imagePath;
        preguntas[index].base64Image = getBase64image(imagePath);
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text("Se añadio correctamente la evidencia!")));
      } else {
        colores[index] = Colors.red;
        values[index] = true;
      }
    }
  }
}
