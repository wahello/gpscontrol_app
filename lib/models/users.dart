import 'package:EnlistControl/models/unit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class User {
<<<<<<< HEAD
  int id;
=======
  String id;
>>>>>>> master
  String sid;
  String name;
  int idU;
  String nameU;
  String passwd;
  String token;
  PseudoUnit unidad;
<<<<<<< HEAD
  User(int id, String name, String pass, String token) {
=======
  User(String id, String name, String pass, String token) {
>>>>>>> master
    this.id = id;
    this.name = name;
    this.token = token;
    this.passwd = pass;
  }

  setSID(String sid){
    this.sid = sid;
  }

  setInfoU(int id, String name){
    this.idU = id;
    this.nameU = name;
  }

  User.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        token = json['token'],
        passwd = json['password'];

  Map toJson() {
    return {'id': id, 'name': name, 'token': token, 'password': passwd};
  }

  setUnit(PseudoUnit unit){
    this.unidad = unit;
  }
}
