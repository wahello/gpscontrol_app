class PseudoUser {
  int id;
  String id_wia;
  String name;
  PseudoUser(int id, String id_wia, String name) {
    this.id = id;
    this.id_wia = id_wia;
    this.name = name;
  }

  PseudoUser.fromJson(Map json)
      : id = json['id'],
        id_wia = json['id_wia'],
        name = json['name'];

  Map toJson() {
    return {'id': id, 'id_wia': id_wia ,'name': name};
  }
}