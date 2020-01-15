import 'package:flutter/material.dart';

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

  setFecha() {
    this.fecha = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      "state": state,
      "vehiculo": vehiculo,
      "fecha": fecha.millisecondsSinceEpoch,
      "documentos_conductor": documentos_conductor == true ? 1 : 0,
      "documentos_vehiculo": documentos_vehiculo == true ? 1 : 0,
      "calcomania": calcomania == true ? 1 : 0,
      "pito": pito == true ? 1 : 0,
      "disp_velocidad": disp_velocidad == true ? 1 : 0,
      "estado_esc_p_conductor": estado_esc_p_conductor == true ? 1 : 0,
      "estado_esc_p_pasajero": estado_esc_p_pasajero == true ? 1 : 0,
      "equipo_carretera": equipo_carretera == true ? 1 : 0,
      "linterna": linterna == true ? 1 : 0,
      "extintor": extintor == true ? 1 : 0,
      "botiquin": botiquin == true ? 1 : 0,
      "repuesto": repuesto == true ? 1 : 0,
      "retrovisores": retrovisores == true ? 1 : 0,
      "cinturones": cinturones == true ? 1 : 0,
      "motor": motor == true ? 1 : 0,
      "llantas": llantas == true ? 1 : 0,
      "baterias": baterias == true ? 1 : 0,
      "transmision": transmision == true ? 1 : 0,
      "tapas": tapas == true ? 1 : 0,
      "niveles": niveles == true ? 1 : 0,
      "filtros": filtros == true ? 1 : 0,
      "parabrisas": parabrisas == true ? 1 : 0,
      "frenos": frenos == true ? 1 : 0,
      "frenos_emergencia": frenos_emergencia == true ? 1 : 0,
      "aire": aire == true ? 1 : 0,
      "luces": luces == true ? 1 : 0,
      "silleteria": silleteria == true ? 1 : 0,
      "silla_conductor": silla_conductor == true ? 1 : 0,
      "aseo": aseo == true ? 1 : 0,
      "celular": celular == true ? 1 : 0,
      "ruteros": ruteros == true ? 1 : 0,
      "desc_documentos_conductor": desc_documentos_conductor,
      "desc_documentos_vehiculo": desc_documentos_vehiculo,
      "desc_calcomania": desc_calcomania,
      "desc_pito": desc_pito,
      "desc_disp_velocidad": desc_disp_velocidad,
      "desc_estado_esc_p_conductor": desc_estado_esc_p_conductor,
      "desc_estado_esc_p_pasajero": desc_estado_esc_p_pasajero,
      "desc_equipo_carretera": desc_equipo_carretera,
      "desc_linterna": desc_linterna,
      "desc_extintor": desc_extintor,
      "desc_botiquin": desc_botiquin,
      "desc_repuesto": desc_repuesto,
      "desc_retrovisores": desc_retrovisores,
      "desc_cinturones": desc_cinturones,
      "desc_motor": desc_motor,
      "desc_llantas": desc_llantas,
      "desc_baterias": desc_baterias,
      "desc_transmision": desc_transmision,
      "desc_tension": desc_tension,
      "desc_tapas": desc_tapas,
      "desc_niveles": desc_niveles,
      "desc_filtros": desc_filtros,
      "desc_parabrisas": desc_parabrisas,
      "desc_frenos": desc_frenos,
      "desc_frenos_emergencia": desc_frenos_emergencia,
      "desc_aire": desc_aire,
      "desc_luces": desc_luces,
      "desc_silleteria": desc_silleteria,
      "desc_silla_conductor": desc_silla_conductor,
      "desc_aseo": desc_aseo,
      "desc_celular": desc_celular,
      "desc_ruteros": desc_ruteros,
      "img_documentos_conductor": img_documentos_conductor,
      "img_documentos_vehiculo": img_documentos_vehiculo,
      "img_calcomania": img_calcomania,
      "img_pito": img_pito,
      "img_disp_velocidad": img_disp_velocidad,
      "img_estado_esc_p_conductor": img_estado_esc_p_conductor,
      "img_estado_esc_p_pasajero": img_estado_esc_p_pasajero,
      "img_equipo_carretera": img_equipo_carretera,
      "img_linterna": img_linterna,
      "img_extintor": img_extintor,
      "img_botiquin": img_botiquin,
      "img_repuesto": img_repuesto,
      "img_retrovisores": img_retrovisores,
      "img_cinturones": img_cinturones,
      "img_motor": img_motor,
      "img_llantas": img_llantas,
      "img_baterias": img_baterias,
      "img_transmision": img_transmision,
      "img_tension": img_tension,
      "img_tapas": img_tapas,
      "img_niveles": img_niveles,
      "img_filtros": img_filtros,
      "img_parabrisas": img_parabrisas,
      "img_frenos": img_frenos,
      "img_frenos_emergencia": img_frenos_emergencia,
      "img_aire": img_aire,
      "img_luces": img_luces,
      "img_silleteria": img_silleteria,
      "img_silla_conductor": img_silla_conductor,
      "img_aseo": img_aseo,
      "img_celular": img_celular,
      "img_ruteros": img_ruteros,
    };
  }
}
