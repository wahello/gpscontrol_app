import 'dart:convert';
class Vehiculo {
  String id;
  String movil;
  String placa;
  String marca;
  String modelo;
  String year;

  Vehiculo(String id,
  String movil,
  String placa,
  String marca,
  String modelo,
  String year
      )
  {
    this.id = id;
    this.movil = movil;
    this.placa = placa;
    this.marca = marca;
    this.modelo = modelo;
    this.year = year;


  }

  Vehiculo.fromJson(Map json)
      : id = json['id'],
        movil = json['movil'],
        placa = json['placa'],
        marca = json['marca'],
        modelo = json['modelo'],
        year = json['year'];

  Map toJson() {
    return {
      'id':id,
      'movil':movil,
      'placa':placa,
      'marca': marca,
      'modelo':modelo,
      'year':year,
    };
  }
}