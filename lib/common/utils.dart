import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
<<<<<<< HEAD
import 'package:EnlistControl/common/enlist_app_icon_icons.dart';
=======
>>>>>>> master

class Utils {
  String name;

  IconData getIconForName(String iconName) {
    switch (iconName) {
      case '0':
        {
<<<<<<< HEAD
          return EnlistAppIcon.documentos_conductor;
        }
      case '1':
        {
          return EnlistAppIcon.documentos_vehiculo;
=======
          return FontAwesomeIcons.idCard;
        }
      case '1':
        {
          return FontAwesomeIcons.idBadge;
>>>>>>> master
        }
        break;
      case '2':
        {
<<<<<<< HEAD
          return EnlistAppIcon.calcomania;
=======
          return FontAwesomeIcons.question;
>>>>>>> master
        }
        break;
      case '3':
        {
<<<<<<< HEAD
          return EnlistAppIcon.bocina;
=======
          return FontAwesomeIcons.volumeUp;
>>>>>>> master
        }
        break;
      case '4':
        {
<<<<<<< HEAD
          return EnlistAppIcon.dispositivo_de_velocidad;
=======
          return FontAwesomeIcons.tachometerAlt;
>>>>>>> master
        }
        break;
      case '5':
        {
<<<<<<< HEAD
          return EnlistAppIcon.escalera_conductor;
=======
          return FontAwesomeIcons.userCircle;
>>>>>>> master
        }
        break;
      case '6':
        {
<<<<<<< HEAD
          return EnlistAppIcon.escalera_pasajero;
=======
          return FontAwesomeIcons.userCheck;
>>>>>>> master
        }
        break;
      case '7':
        {
<<<<<<< HEAD
          return EnlistAppIcon.equipo_carretera;
=======
          return FontAwesomeIcons.tools;
>>>>>>> master
        }
        break;
      case '8':
        {
<<<<<<< HEAD
          return EnlistAppIcon.herramientas;
=======
          return FontAwesomeIcons.toolbox;
>>>>>>> master
        }
        break;
      case '9':
        {
<<<<<<< HEAD
          return EnlistAppIcon.linterna;
=======
          return FontAwesomeIcons.lowVision;
>>>>>>> master
        }
        break;
      case '10':
        {
<<<<<<< HEAD
          return EnlistAppIcon.extintor;
=======
          return FontAwesomeIcons.fireExtinguisher;
>>>>>>> master
        }
        break;
      case '11':
        {
<<<<<<< HEAD
          return EnlistAppIcon.botiquin;
=======
          return FontAwesomeIcons.medkit;
>>>>>>> master
        }
        break;
      case '12':
        {
<<<<<<< HEAD
          return EnlistAppIcon.llanta_de_repuesto;
=======
          return FontAwesomeIcons.replyAll;
>>>>>>> master
        }
        break;
      case '13':
        {
<<<<<<< HEAD
          return EnlistAppIcon.espejos_retrovisores;
=======
          return FontAwesomeIcons.car;
>>>>>>> master
        }
        break;
      case '14':
        {
<<<<<<< HEAD
          return EnlistAppIcon.cinturon_seguridad;
=======
          return FontAwesomeIcons.compressArrowsAlt;
>>>>>>> master
        }
        break;
      case '15':
        {
<<<<<<< HEAD
          return EnlistAppIcon.goteo_motor;
=======
          return FontAwesomeIcons.searchengin;
>>>>>>> master
        }
        break;
      case '16':
        {
<<<<<<< HEAD
          return EnlistAppIcon.llantas;
=======
          return FlatIcons.stopwatch;
>>>>>>> master
        }
        break;
      case '17':
        {
<<<<<<< HEAD
          return EnlistAppIcon.bateria_niveles_agua;
=======
          return FontAwesomeIcons.carBattery;
>>>>>>> master
        }
        break;
      case '18':
        {
<<<<<<< HEAD
          return EnlistAppIcon.direccion_transmision;
=======
          return FontAwesomeIcons.carCrash;
>>>>>>> master
        }
        break;
      case '19':
        {
<<<<<<< HEAD
          return EnlistAppIcon.tension_correas;
=======
          return FontAwesomeIcons.circleNotch;
>>>>>>> master
        }
        break;
      case '20':
        {
<<<<<<< HEAD
          return EnlistAppIcon.tapas_radiador;
=======
          return FontAwesomeIcons.gasPump;
>>>>>>> master
        }
        break;
      case '21':
        {
<<<<<<< HEAD
          return EnlistAppIcon.agua_radiador_aceite;
=======
          return FontAwesomeIcons.levelDownAlt;
>>>>>>> master
        }
        break;
      case '22':
        {
<<<<<<< HEAD
          return EnlistAppIcon.revision_filtros;
=======
          return FontAwesomeIcons.filter;
>>>>>>> master
        }
        break;
      case '23':
        {
<<<<<<< HEAD
          return EnlistAppIcon.limpia_parabrisas;
=======
          return FontAwesomeIcons.water;
>>>>>>> master
        }
        break;
      case '24':
        {
<<<<<<< HEAD
          return EnlistAppIcon.sistema_frenos;
=======
          return FontAwesomeIcons.solidStopCircle;
>>>>>>> master
        }
        break;
      case '25':
        {
<<<<<<< HEAD
          return EnlistAppIcon.freno_emergencia;
=======
          return FontAwesomeIcons.userTimes;
>>>>>>> master
        }
        break;
      case '26':
        {
<<<<<<< HEAD
          return EnlistAppIcon.aire_acondicionado;
=======
          return FontAwesomeIcons.airbnb;
>>>>>>> master
        }
        break;
      case '27':
        {
<<<<<<< HEAD
          return EnlistAppIcon.luces;
=======
          return FontAwesomeIcons.trafficLight;
>>>>>>> master
        }
        break;
      case '28':
        {
<<<<<<< HEAD
          return EnlistAppIcon.silleteria;
=======
          return FontAwesomeIcons.accessibleIcon;
>>>>>>> master
        }
        break;
      case '29':
        {
<<<<<<< HEAD
          return EnlistAppIcon.silla_conductor;
=======
          return FontAwesomeIcons.alignCenter;
>>>>>>> master
        }
        break;
      case '30':
        {
<<<<<<< HEAD
          return EnlistAppIcon.aseo_interno_externo;
=======
          return FontAwesomeIcons.envira;
>>>>>>> master
        }
        break;
      case '31':
        {
<<<<<<< HEAD
          return EnlistAppIcon.avantel_celular;
=======
          return FontAwesomeIcons.mobileAlt;
>>>>>>> master
        }
        break;
      case '32':
        {
<<<<<<< HEAD
          return EnlistAppIcon.ruteros;
        }
        break;
      case 'ok':
        {
          return EnlistAppIcon.listo_ok;
        }
        break;
      case 'foto':
        {
          return EnlistAppIcon.tomar_foto;
        }
        break;
      case 'salir':
        {
          return EnlistAppIcon.salir;
        }
        break;
      case 'nosotros':
        {
          return EnlistAppIcon.nosotros;
        }
        break;  
      case 'soporte':
        {
          return EnlistAppIcon.soporte;
        }
        break;  
      case 'historia':
        {
          return EnlistAppIcon.historial;
        }
        break;
      case 'user':
        {
          return EnlistAppIcon.usuario;
        }
        break;
      case 'bad':
        {
          return EnlistAppIcon.soporte2;
        }
        break;    
=======
          return FontAwesomeIcons.flagCheckered;
        }
        break;
>>>>>>> master
      default:
        {
          return FontAwesomeIcons.home;
        }
    }
  }
}
