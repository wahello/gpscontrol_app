import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class Alistamiento {
  static const String TABLENAME = "alistamientos";
  String folio;
  String state;
  String vehiculo;
  DateTime fecha;
  String responsable;
  bool documentos_conductor;
  bool documentos_vehiculo;
  bool calcomania;
  bool pito;
  bool disp_velocidad;
  bool estado_esc_p_conductor;
  bool estado_esc_p_pasajero;
  bool equipo_carretera;
  bool linterna;
  bool extintor;
  bool botiquin;
  bool repuesto;
  bool retrovisores;
  bool cinturones;
  bool motor;
  bool llantas;
  bool baterias;
  bool transmision;
  bool tension;
  bool tapas;
  bool niveles;
  bool filtros;
  bool parabrisas;
  bool frenos;
  bool frenos_emergencia;
  bool aire;
  bool luces;
  bool silleteria;
  bool silla_conductor;
  bool aseo;
  bool celular;
  bool ruteros;
  String desc_documentos_conductor;
  String desc_documentos_vehiculo;
  String desc_calcomania;
  String desc_pito;
  String desc_disp_velocidad;
  String desc_estado_esc_p_conductor;
  String desc_estado_esc_p_pasajero;
  String desc_equipo_carretera;
  String desc_linterna;
  String desc_extintor;
  String desc_botiquin;
  String desc_repuesto;
  String desc_retrovisores;
  String desc_cinturones;
  String desc_motor;
  String desc_llantas;
  String desc_baterias;
  String desc_transmision;
  String desc_tension;
  String desc_tapas;
  String desc_niveles;
  String desc_filtros;
  String desc_parabrisas;
  String desc_frenos;
  String desc_frenos_emergencia;
  String desc_aire;
  String desc_luces;
  String desc_silleteria;
  String desc_silla_conductor;
  String desc_aseo;
  String desc_celular;
  String desc_ruteros;
  String img_documentos_conductor;
  String img_documentos_vehiculo;
  String img_calcomania;
  String img_pito;
  String img_disp_velocidad;
  String img_estado_esc_p_conductor;
  String img_estado_esc_p_pasajero;
  String img_equipo_carretera;
  String img_linterna;
  String img_extintor;
  String img_botiquin;
  String img_repuesto;
  String img_retrovisores;
  String img_cinturones;
  String img_motor;
  String img_llantas;
  String img_baterias;
  String img_transmision;
  String img_tension;
  String img_tapas;
  String img_niveles;
  String img_filtros;
  String img_parabrisas;
  String img_frenos;
  String img_frenos_emergencia;
  String img_aire;
  String img_luces;
  String img_silleteria;
  String img_silla_conductor;
  String img_aseo;
  String img_celular;
  String img_ruteros;

  Alistamiento({
    this.state,
    this.vehiculo,
  });

  Alistamiento.fromJson(Map json)
      : vehiculo = json['vehiculo'].toString(),
        fecha = json['fecha'],
        documentos_conductor = json['documentos_conductor'],
        documentos_vehiculo = json['documentos_vehiculo'],
        calcomania = json['calcomania'],
        pito = json['pito'],
        disp_velocidad = json['disp_velocidad'],
        estado_esc_p_conductor = json['estado_esc_p_conductor'],
        estado_esc_p_pasajero = json['estado_esc_p_pasajero'],
        equipo_carretera = json['equipo_carretera'],
        linterna = json['linterna'],
        extintor = json['extintor'],
        botiquin = json['botiquin'],
        repuesto = json['repuesto'],
        retrovisores = json['retrovisores'],
        cinturones = json['cinturones'],
        motor = json['motor'],
        llantas = json['llantas'],
        baterias = json['baterias'],
        transmision = json['transmision'],
        tapas = json['tapas'],
        niveles = json['niveles'],
        filtros = json['filtros'],
        parabrisas = json['parabrisas'],
        frenos = json['frenos'],
        frenos_emergencia = json['frenos_emergencia'],
        aire = json['aire'],
        luces = json['luces'],
        silleteria = json['silleteria'],
        silla_conductor = json['silla_conductor'],
        aseo = json['aseo'],
        celular = json['celular'],
        ruteros = json['ruteros'],
        desc_documentos_conductor = json['desc_documentos_conductor'],
        desc_documentos_vehiculo = json['desc_documentos_vehiculo'],
        desc_calcomania = json['desc_calcomania'],
        desc_pito = json['desc_pito'],
        desc_disp_velocidad = json['desc_disp_velocidad'],
        desc_estado_esc_p_conductor = json['desc_estado_esc_p_conductor'],
        desc_estado_esc_p_pasajero = json['desc_estado_esc_p_pasajero'],
        desc_equipo_carretera = json['desc_equipo_carretera'],
        desc_linterna = json['desc_linterna'],
        desc_extintor = json['desc_extintor'],
        desc_botiquin = json['desc_botiquin'],
        desc_repuesto = json['desc_repuesto'],
        desc_retrovisores = json['desc_retrovisores'],
        desc_cinturones = json['desc_cinturones'],
        desc_motor = json['desc_motor'],
        desc_llantas = json['desc_llantas'],
        desc_baterias = json['desc_baterias'],
        desc_transmision = json['desc_transmision'],
        desc_tension = json['desc_tension'],
        desc_tapas = json['desc_tapas'],
        desc_niveles = json['desc_niveles'],
        desc_filtros = json['desc_filtros'],
        desc_parabrisas = json['desc_parabrisas'],
        desc_frenos = json['desc_frenos'],
        desc_frenos_emergencia = json['desc_frenos_emergencia'],
        desc_aire = json['desc_aire'],
        desc_luces = json['desc_luces'],
        desc_silleteria = json['desc_silleteria'],
        desc_silla_conductor = json['desc_silla_conductor'],
        desc_aseo = json['desc_aseo'],
        desc_celular = json['desc_celular'],
        desc_ruteros = json['desc_ruteros'],
        img_documentos_conductor = json['img_documentos_conductor'],
        img_documentos_vehiculo = json['img_documentos_vehiculo'],
        img_calcomania = json['img_calcomania'],
        img_pito = json['img_pito'],
        img_disp_velocidad = json['img_disp_velocidad'],
        img_estado_esc_p_conductor = json['img_estado_esc_p_conductor'],
        img_estado_esc_p_pasajero = json['img_estado_esc_p_pasajero'],
        img_equipo_carretera = json['img_equipo_carretera'],
        img_linterna = json['img_linterna'],
        img_extintor = json['img_extintor'],
        img_botiquin = json['img_botiquin'],
        img_repuesto = json['img_repuesto'],
        img_retrovisores = json['img_retrovisores'],
        img_cinturones = json['img_cinturones'],
        img_motor = json['img_motor'],
        img_llantas = json['img_llantas'],
        img_baterias = json['img_baterias'],
        img_transmision = json['img_transmision'],
        img_tension = json['img_tension'],
        img_tapas = json['img_tapas'],
        img_niveles = json['img_niveles'],
        img_filtros = json['img_filtros'],
        img_parabrisas = json['img_parabrisas'],
        img_frenos = json['img_frenos'],
        img_frenos_emergencia = json['img_frenos_emergencia'],
        img_aire = json['img_aire'],
        img_luces = json['img_luces'],
        img_silleteria = json['img_silleteria'],
        img_silla_conductor = json['img_silla_conductor'],
        img_aseo = json['img_aseo'],
        img_celular = json['img_celular'],
        img_ruteros = json['img_ruteros'];

  Alistamiento.basicJson(Map json)
      : vehiculo = json['vehiculo'][1],
        fecha = DateTime.parse(json['fecha']),
       folio = json['folio'],
       responsable = json['partner_id'][1],
       state = json['state'];
             
  Alistamiento.dbJson(Map json)
      : vehiculo = json['vehiculo'],
        fecha = new DateTime.fromMillisecondsSinceEpoch(json['fecha']),
       folio = json['folio'],
       responsable = json['conductor'],
       state = json['estado'];

  String setResponsable(String responsable) {
    this.responsable = responsable;
    return responsable;
  }

  String setVehicleName(String vehiculo) {
    this.vehiculo = vehiculo;
    return vehiculo;
  }

  String setState(String state) {
    this.state = state;
    return state;
  }

  String setFolio(String folio) {
    this.folio = folio;
    return folio;
  }


  Map<String, dynamic> toJson() {
    return {
      "folio": folio,
      "vehiculo": vehiculo,
      "conductor": responsable,
      "estado": state,
      "fecha": fecha.millisecondsSinceEpoch,
    };
  }
}
