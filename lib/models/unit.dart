import 'package:EnlistControl/models/pseudouser.dart';

class PseudoUnit {
  int id;
  int idUser;
  String name;
  PseudoUser user;
  PseudoUnit(int id, int idUser, String name, PseudoUser user) {
    this.id = id;
    this.idUser = idUser;
    this.name = name;
    this.user = user;
  }

  PseudoUnit.fromJson(Map json)
      : id = json['id'],
        idUser = json['idUser'],
        name = json['name'];

  Map toJson() {
    return {'id': id, 'idUser': idUser, 'name': name};
  }

  setId(int id){
    this.id = id;
  }
}