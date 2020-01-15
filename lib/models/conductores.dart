import 'dart:convert';

class Conductor {
  String id;
  String nombre;
  String doc_id;

  Conductor(
    String id,
    String nombre,
    String doc_id,
  ) {
    this.id = id;
    this.nombre = nombre;
    this.doc_id = doc_id;
  }

  Conductor.fromJson(Map json)
      : id = json['id'],
        nombre = json['nombre'],
        doc_id = json['doc_idS'];

  Map toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'doc_id': doc_id,
    };
  }
}
