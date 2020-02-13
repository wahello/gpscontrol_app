import 'package:EnlistControl/models/atribute.dart';
import 'package:EnlistControl/models/users.dart';
import 'package:EnlistControl/models/vehiculos.dart';

class PseudoUser {
  int id;
  String idWia;
  String name;
  User baseUser;
  Vehiculo vehiculo;
  String imgUri;
  List<Intervalo> intervalos;
  List<Atribute> atributos;
  PseudoUser(User baseUser) {
<<<<<<< HEAD
    this.idWia = baseUser.id.toString();
=======
    this.idWia = baseUser.id;
>>>>>>> master
    this.name = baseUser.name;
    this.baseUser = baseUser;
  }

  PseudoUser.fromJson(Map json, User baseUser)
      : idWia = json['idWia'],
        name = json['name'],
        baseUser = baseUser;

  setJson(Map json) {
    this.idWia = json['idWia'];
    this.name = json['name'];
    this.id = json['id'];
  }

  Map toJson() {
    return {'idWia': idWia, 'name': name};
  }

  setVehiculo(vehiculo){
    this.vehiculo = vehiculo;
<<<<<<< HEAD
  }
  setIntervals(List<Intervalo> intervals){
    this.intervalos = intervals;
  }
=======
  }
  setIntervals(List<Intervalo> intervals){
    this.intervalos = intervals;
  }
>>>>>>> master
  setAttrib(List<Atribute> atrribs){
    this.atributos = atrribs;
  }

  setImg(String img){
    this.imgUri = img;
  }
  setID(int id){
    this.id = id;
  }
<<<<<<< HEAD
  setBaseUser(User user){
    this.baseUser = user;
  }
=======
>>>>>>> master

}
