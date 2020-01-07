class PseudoUnit {
  int id;
  int idUser;
  String name;
  PseudoUnit(int id, int idUser, String name) {
    this.id = id;
    this.idUser = idUser;
    this.name = name;
  }

  PseudoUnit.fromJson(Map json)
      : id = json['id'],
        idUser = json['idUser'],
        name = json['name'];

  Map toJson() {
    return {'id': id, 'idUser': idUser, 'name': name};
  }
}