import 'dart:convert';
import '../models/users.dart';
import '../common/wialon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:GPS_CONTROL/models/preguntas.dart';

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

  initState() {
    super.initState();
    _getPreguntas();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alistamientos"),
        ),
        body: ListView.builder(
          itemCount: preguntas.length,
          itemBuilder: (context, index) {
            final pregunta = preguntas[index].pregunta;
            final id = preguntas[index].id;
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigoAccent,
                    child: Text('$id'),
                    foregroundColor: Colors.white,
                  ),
                  title: Text('$pregunta'),
                  //subtitle: Text('<---- No / Si ---> '),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'OK',
                  color: Colors.green,
                  icon: Icons.assignment_turned_in,
                  onTap: () => {},
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Tomar Foto',
                  color: Colors.red,
                  icon: Icons.add_a_photo,
                  onTap: () => {},
                ),
              ],
            );
          },
        ));
  }
}
