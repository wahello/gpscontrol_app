import 'dart:convert';
import '../models/users.dart';
import '../common/wialon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:GPS_CONTROL/models/preguntas.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:camera/camera.dart';
import 'package:GPS_CONTROL/common/camara.dart';

class AlistamientoScreen extends StatefulWidget {
  AlistamientoScreen({this.data});
  final data;
  static const routeName = '/alistamientos';
  @override
  createState() => _AlistamientoScreenState();
}

class _AlistamientoScreenState extends State {
  var preguntas = new List<Pregunta>();

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
    for(var index=0;index<list_preguntas.length;index++){
      var pregunta = new Pregunta(index, list_preguntas[index],'');
      preguntas.add(pregunta);
    }
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

  Future<void> takeApicture () async {
    // Obtén una lista de las cámaras disponibles en el dispositivo.
    final cameras = await availableCameras();

    // Obtén una cámara específica de la lista de cámaras disponibles
    final firstCamera = cameras.first;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera),
      ),
    );

  }

  @override
  build(context) {
    // Ensure the camera is initialized
    return Scaffold(
        appBar: AppBar(
          title: Text("Alistamientos"),
        ),
        body: ListView.builder(
          itemCount: preguntas.length,
          itemBuilder: (context, index) {
            final pregunta = preguntas[index].pregunta;
            final id = preguntas[index].id;
            final desc = preguntas[index].descripcion;
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              closeOnScroll: false,
              child: Card(
                child: ListTile(
                  leading: Icon(getIconForName(id)),
                  title: Text('$pregunta'),
                  subtitle: Text(
                      '$desc'
                  ),
                  //trailing: Icon(Icons.more_vert),
                  isThreeLine: false,
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'OK',
                  color: Colors.green,
                  icon: Icons.assignment_turned_in,
                  closeOnTap: false,
                  onTap: () => {},
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Tomar Foto',
                  color: Colors.red,
                  icon: Icons.add_a_photo,
                  onTap: () => {
                      takeApicture(),
                  },
                ),
              ],
            );
          },
        ));
  }
}
