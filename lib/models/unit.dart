class PseudoUnit {
  String id;
  String name;
  PseudoUnit(String id, String name) {
    this.id = id;
    this.name = name;
  }

  PseudoUnit.fromJson(Map json)
      : id = json['id'],
        name = json['name'];

  Map toJson() {
    return {'id': id, 'name': name};
  }
}