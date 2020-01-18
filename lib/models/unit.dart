import 'package:EnlistControl/models/pseudouser.dart';

class PseudoUnit {
  int id;
  int idUser;
  String name;
  PseudoUser user;
  PseudoUnit(int id, String name) {
    this.id = id;
    this.name = name;
  }

  PseudoUnit.fromJson(Map json)
      : id = json['id'],
        name = json['name'];

  Map toJson() {
    return {'id': id, 'name': name};
  }

  setId(int id) {
    this.id = id;
  }

  setIdUser(int id){
    this.idUser = id;
  }

  setUser(PseudoUser user){
    this.user = user;
  }
}
