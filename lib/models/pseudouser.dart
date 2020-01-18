import 'package:EnlistControl/models/users.dart';
import 'package:EnlistControl/models/vehiculos.dart';

class PseudoUser {
  String idWia;
  String name;
  User baseUser;
  List<Vehiculo> vehiculos;
  PseudoUser(User baseUser) {
    this.idWia = baseUser.id;
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
  }

  Map toJson() {
    return {'idWia': idWia, 'name': name};
  }

  setVehiculos(vehiculos){
    this.vehiculos = vehiculos;
  }

}
