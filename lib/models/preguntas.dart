
import 'package:flutter/cupertino.dart';

class Pregunta {
  String id;
  String pregunta;
  String descripcion;

  Pregunta(int id, String pregunta, String descripcion) {
    this.id = id.toString();
    this.pregunta = pregunta;
    this.descripcion = descripcion;
  }

  Pregunta.fromJson(Map json)
      : id = json['id'],
        pregunta = json['pregunta'],
        descripcion = json['desc'];

  Map toJson() {
    return {'id': id, 'pregunta': pregunta, 'desc': descripcion};
  }
}