import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:GPS_CONTROL/models/preguntas.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:camera/camera.dart';
import 'package:GPS_CONTROL/common/camara.dart';
import 'package:GPS_CONTROL/models/alistamiento.dart';
import 'package:GPS_CONTROL/models/users.dart';
import 'custom_route.dart';

class AlistamientoScreen extends StatefulWidget {
  AlistamientoScreen({this.data});
  final data;
  static const routeName = '/alistamientos';
  @override
  createState() => _AlistamientoScreenState();
}

class _AlistamientoScreenState extends State {
  var preguntas = new List<Pregunta>();
  final values = new List<bool>();
  SlidableController slidableController;
  Alistamiento nuevoAlistamiento;
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
      print('entramos al is open chang '+'$isOpen');
      print(_fabColor);
    });
  }

  _init_alistamiento(List init_state){
     nuevoAlistamiento.set_responsable('Usuario App prueba');
     nuevoAlistamiento.documentos_conductor = init_state[0];
     nuevoAlistamiento.documentos_vehiculo = init_state[1];
     nuevoAlistamiento.calcomania = init_state[2];
     nuevoAlistamiento.pito = init_state[3];
     nuevoAlistamiento.disp_velocidad = init_state[4];
     nuevoAlistamiento.estado_esc_p_conductor = init_state[5];
     nuevoAlistamiento.estado_esc_p_pasajero = init_state[6];
     nuevoAlistamiento.equipo_carretera = init_state[7];
     nuevoAlistamiento.linterna = init_state[8];
     nuevoAlistamiento.extintor = init_state[9];
     nuevoAlistamiento.botiquin = init_state[10];
     nuevoAlistamiento.repuesto = init_state[11];
     nuevoAlistamiento.retrovisores = init_state[12];
     nuevoAlistamiento.cinturones = init_state[13];
     nuevoAlistamiento.motor = init_state[14];
     nuevoAlistamiento.llantas = init_state[15];
     nuevoAlistamiento.baterias = init_state[16];
     nuevoAlistamiento.transmision = init_state[17];
     nuevoAlistamiento.tapas = init_state[18];
     nuevoAlistamiento.niveles = init_state[19];
     nuevoAlistamiento.filtros= init_state[20];
     nuevoAlistamiento.parabrisas = init_state[21];
     nuevoAlistamiento.frenos= init_state[22];
     nuevoAlistamiento.frenos_emergencia = init_state[23];
     nuevoAlistamiento.aire = init_state[24];
     nuevoAlistamiento.luces = init_state[25];
     nuevoAlistamiento.silleteria = init_state[26];
     nuevoAlistamiento.silla_conductor = init_state[27];
     nuevoAlistamiento.aseo = init_state[28];
     nuevoAlistamiento.celular = init_state[29];
     nuevoAlistamiento.ruteros = init_state[30];


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
    slidableController = new  SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    for(var index=0;index<list_preguntas.length;index++){
      var pregunta = new Pregunta(index, list_preguntas[index],'','');
      preguntas.add(pregunta);
      //slidableController.add(controlador);
      values.add(false);
    }
    //_init_alistamiento(values);
  }
  IconData getIconForName(String iconName) {
    switch(iconName) {
      case '0': {
        return FontAwesomeIcons.idCard;
      }
      case '1': {
        return FontAwesomeIcons.idBadge;
      }
      break;
      case '2': {
        return FontAwesomeIcons.question;
      }
      break;
      case '3': {
        return FontAwesomeIcons.volumeUp;
      }
      break;
      case '4': {
        return FontAwesomeIcons.tachometerAlt;
      }
      break;
      case '5': {
        return FontAwesomeIcons.userCircle;
      }
      break;
      case '6': {
        return FontAwesomeIcons.userCheck;
      }
      break;
      case '7': {
        return FontAwesomeIcons.tools;
      }
      break;
      case '8': {
        return FontAwesomeIcons.toolbox;
      }
      break;
      case '9': {
        return FontAwesomeIcons.lowVision;
      }
      break;
      case '10': {
        return FontAwesomeIcons.fireExtinguisher;
      }
      break;
      case '11': {
        return FontAwesomeIcons.medkit;
      }
      break;
      case '12': {
        return FontAwesomeIcons.replyAll;
      }
      break;
      case '13': {
        return FontAwesomeIcons.car;
      }
      break;
      case '14': {
        return FontAwesomeIcons.compressArrowsAlt;
      }
      break;
      case '15': {
        return FontAwesomeIcons.searchengin;
      }
      break;
      case '16': {
        return FlatIcons.stopwatch;
      }
      break;
      case '17': {
        return FontAwesomeIcons.carBattery;
      }
      break;
      case '18': {
        return FontAwesomeIcons.carCrash;
      }
      break;
      case '19': {
        return FontAwesomeIcons.circleNotch;
      }
      break;
      case '20': {
        return FontAwesomeIcons.gasPump;
      }
      break;
      case '21': {
        return FontAwesomeIcons.levelDownAlt;
      }
      break;
      case '22': {
        return FontAwesomeIcons.filter;
      }
      break;
      case '23': {
        return FontAwesomeIcons.water;
      }
      break;
      case '24': {
        return FontAwesomeIcons.solidStopCircle;
      }
      break;
      case '25': {
        return FontAwesomeIcons.userTimes;
      }
      break;
      case '26': {
        return FontAwesomeIcons.airbnb;
      }
      break;
      case '27': {
        return FontAwesomeIcons.trafficLight;
      }
      break;
      case '28': {
        return FontAwesomeIcons.accessibleIcon;
      }
      break;
      case '29': {
        return FontAwesomeIcons.alignCenter;
      }
      break;
      case '30': {
        return FontAwesomeIcons.envira;
      }
      break;
      case '31': {
        return FontAwesomeIcons.mobileAlt;
      }
      break;
      case '32': {
        return FontAwesomeIcons.flagCheckered;
      }
      break;      
      default: {
        return FontAwesomeIcons.home;
      }
    }
  }

  initState() {
    super.initState();
    _getPreguntas();
  }

  dispose() {
    super.dispose();
  }

  Future<void> takeApicture (int index) async {
    print('el indice seleccionado es: '+index.toString());
    // Obtén una lista de las cámaras disponibles en el dispositivo.
    final cameras = await availableCameras();
    // Obtén una cámara específica de la lista de cámaras disponibles
    final firstCamera = cameras.first;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera, index: index,),
      ),
    );

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
            new Expanded(child: ListView.builder(
              itemCount: preguntas.length,
              itemBuilder: (context, index) {
                var pregunta = preguntas[index].pregunta;
                var id = preguntas[index].id;
                var desc = preguntas[index].descripcion;
                var value = values[index];
                return Slidable(
                    key: Key(id),
                    controller: slidableController,
                    actionPane: new SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    closeOnScroll: false,
                    child: Card(
                        child: CheckboxListTile(
                          title: Text('$pregunta'),
                          value: values[index],
                          onChanged: (bool newvalue) {
                            setState(() {
                              values[index] = newvalue;
                            });

                          },
                          secondary: Icon(getIconForName(id.toString())),
                        )
                    ),
                    actions: <Widget>[
                      new IconSlideAction(
                        caption: 'OK',
                        color: Colors.green,
                        icon: Icons.assignment_turned_in,
                        closeOnTap: false,
                        onTap: () => {

                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      new IconSlideAction(
                        caption: 'Tomar Foto',
                        color: Colors.red,
                        icon: Icons.add_a_photo,
                        onTap: () => {
                          takeApicture(index),
                        },
                      ),
                    ]
                );
              },
            )),
            new Padding(
              padding: EdgeInsets.all(15.0),
              child: MaterialButton(
                child: Text(
                  "Finalizar Alistamiento",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                onPressed: () {

                  Navigator.of(context).pushReplacement(FadePageRoute(
                    builder: (context) =>new  AlistamientoScreen(),
                  ));
                  print('Aqui va la accion finish alistamiento');
                  //_saveURL(_urlCtrler.text);
                },
              ),
            ),
          ],
        ),

    );
  }
}
