import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:EnlistControl/common/enlist_app_icon_icons.dart';

class Utils {
  String name;

  IconData getIconForName(String iconName) {
    switch (iconName) {
      case '0':
        {
          return EnlistAppIcon.documentos_conductor;
        }
      case '1':
        {
          return EnlistAppIcon.documentos_vehiculo;
        }
        break;
      case '2':
        {
          return EnlistAppIcon.calcomania;
        }
        break;
      case '3':
        {
          return EnlistAppIcon.bocina;
        }
        break;
      case '4':
        {
          return EnlistAppIcon.dispositivo_de_velocidad;
        }
        break;
      case '5':
        {
          return EnlistAppIcon.escalera_conductor;
        }
        break;
      case '6':
        {
          return EnlistAppIcon.escalera_pasajero;
        }
        break;
      case '7':
        {
          return EnlistAppIcon.equipo_carretera;
        }
        break;
      case '8':
        {
          return EnlistAppIcon.herramientas;
        }
        break;
      case '9':
        {
          return EnlistAppIcon.linterna;
        }
        break;
      case '10':
        {
          return EnlistAppIcon.extintor;
        }
        break;
      case '11':
        {
          return EnlistAppIcon.botiquin;
        }
        break;
      case '12':
        {
          return EnlistAppIcon.llanta_de_repuesto;
        }
        break;
      case '13':
        {
          return EnlistAppIcon.espejos_retrovisores;
        }
        break;
      case '14':
        {
          return EnlistAppIcon.cinturon_seguridad;
        }
        break;
      case '15':
        {
          return EnlistAppIcon.goteo_motor;
        }
        break;
      case '16':
        {
          return EnlistAppIcon.llantas;
        }
        break;
      case '17':
        {
          return EnlistAppIcon.bateria_niveles_agua;
        }
        break;
      case '18':
        {
          return EnlistAppIcon.direccion_transmision;
        }
        break;
      case '19':
        {
          return EnlistAppIcon.tension_correas;
        }
        break;
      case '20':
        {
          return EnlistAppIcon.tapas_radiador;
        }
        break;
      case '21':
        {
          return EnlistAppIcon.agua_radiador_aceite;
        }
        break;
      case '22':
        {
          return EnlistAppIcon.revision_filtros;
        }
        break;
      case '23':
        {
          return EnlistAppIcon.limpia_parabrisas;
        }
        break;
      case '24':
        {
          return EnlistAppIcon.sistema_frenos;
        }
        break;
      case '25':
        {
          return EnlistAppIcon.freno_emergencia;
        }
        break;
      case '26':
        {
          return EnlistAppIcon.aire_acondicionado;
        }
        break;
      case '27':
        {
          return EnlistAppIcon.luces;
        }
        break;
      case '28':
        {
          return EnlistAppIcon.silleteria;
        }
        break;
      case '29':
        {
          return EnlistAppIcon.silla_conductor;
        }
        break;
      case '30':
        {
          return EnlistAppIcon.aseo_interno_externo;
        }
        break;
      case '31':
        {
          return EnlistAppIcon.avantel_celular;
        }
        break;
      case '32':
        {
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
      default:
        {
          return FontAwesomeIcons.home;
        }
    }
  }
}
