
import 'dart:html';

import 'package:flutter/material.dart';

class Alistamiento {
  bool folio;
  bool state;
  bool vehiculo;
  bool fecha;
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
  List<File> images;
  List<Text> descripciones;

  Alistamiento(
      bool folio,
      bool state,
      bool vehiculo,
      bool fecha,
      bool documentos_conductor,
      bool documentos_vehiculo,
      bool calcomania,
      bool pito,
      bool disp_velocidad,
      bool estado_esc_p_conductor,
      bool estado_esc_p_pasajero,
      bool equipo_carretera,
      bool linterna,
      bool extintor,
      bool botiquin,
      bool repuesto,
      bool retrovisores,
      bool cinturones,
      bool motor,
      bool llantas,
      bool baterias,
      bool transmision,
      bool tapas,
      bool niveles,
      bool filtros,
      bool parabrisas,
      bool frenos,
      bool frenos_emergencia,
      bool aire,
      bool luces,
      bool silleteria,
      bool silla_conductor,
      bool aseo,
      bool celular,
      bool ruteros,
      List<File> images,
      List<Text> descripciones) {
    this.folio = folio;
    this.state = state;
    this.vehiculo = vehiculo;
    this.fecha = fecha;
    this.documentos_conductor = documentos_conductor;
    this.documentos_vehiculo = documentos_vehiculo;
    this.calcomania = calcomania;
    this.pito = pito;
    this.disp_velocidad = disp_velocidad;
    this.estado_esc_p_conductor = estado_esc_p_conductor;
    this.estado_esc_p_pasajero = estado_esc_p_pasajero;
    this.equipo_carretera = equipo_carretera;
    this.linterna = linterna;
    this.extintor = extintor;
    this.botiquin = botiquin;
    this.repuesto = repuesto;
    this.retrovisores = retrovisores;
    this.cinturones = cinturones;
    this.motor = motor;
    this.llantas = llantas;
    this.baterias = baterias;
    this.transmision = transmision;
    this.tapas = tapas;
    this.niveles = niveles;
    this.filtros = filtros;
    this.parabrisas = parabrisas;
    this.frenos = frenos;
    this.frenos_emergencia = frenos_emergencia;
    this.aire = aire;
    this.luces = luces;
    this.silleteria = silleteria;
    this.silla_conductor = silla_conductor;
    this.aseo = aseo;
    this.celular = celular;
    this.ruteros = ruteros;
    this.images = images;
    this.descripciones = descripciones;
  }

  Alistamiento.fromJson(Map json)
      : folio = json['folio'],
        state = json['state'],
        vehiculo = json['vehiculo'],
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
        images = json['images'],
        descripciones = json['descripciones'];


  Map toJson() {
    return {'folio':folio,
      'state':state,
      'vehiculo':vehiculo,
      'fecha':fecha,
      'documentos_conductor':documentos_conductor,
      'documentos_vehiculo':documentos_vehiculo,
      'calcomania':calcomania,
      'pito':pito,
      'disp_velocidad':disp_velocidad,
      'estado_esc_p_conductor':estado_esc_p_conductor,
      'estado_esc_p_pasajero':estado_esc_p_pasajero,
      'equipo_carretera':equipo_carretera,
      'linterna':linterna,
      'extintor':extintor,
      'botiquin':botiquin,
      'repuesto':repuesto,
      'retrovisores':retrovisores,
      'cinturones':cinturones,
      'motor':motor,
      'llantas':llantas,
      'baterias':baterias,
      'transmision':transmision,
      'tapas':tapas,
      'niveles':niveles,
      'filtros':filtros,
      'parabrisas':parabrisas,
      'frenos':frenos,
      'frenos_emergencia':frenos_emergencia,
      'aire':aire,
      'luces':luces,
      'silleteria':silleteria,
      'silla_conductor':silla_conductor,
      'aseo':aseo,
      'celular':celular,
      'ruteros':ruteros,
      'images':images,
      'descripciones':descripciones,
    };
  }
}