import 'package:EnlistControl/models/users.dart';
class PseudoUser {
  int id;
  String id_wia;
  String name;
  User baseUser;  
  PseudoUser(int id, String id_wia, String name, User baseUser) {
    this.id = id;
    this.id_wia = id_wia;
    this.name = name;
    this.baseUser = baseUser;
  }

  PseudoUser.fromJson(Map json, User baseUser)
      : id = json['id'],
        id_wia = json['id_wia'],
        name = json['name'],
        baseUser = baseUser;

  setJson(Map json){
    this.id = json['id'];
    this.id_wia = json['id_wia'];
    this.name = json['name'];
  }
  Map toJson() {
    return {'id': id, 'id_wia': id_wia ,'name': name};
  }
}