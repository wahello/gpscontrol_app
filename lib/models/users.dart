const mockUsers = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'near.huscarl@gmail.com': 'subscribe to pewdiepie',
  '@.com': '.',
};

class User {
  String id;
  String name;
  String passwd;
  String token;
  User(String id, String name, String pass,String token) {
    this.id = id;
    this.name = name;
    this.token = token;
    this.passwd = pass;
  }

  User.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        token = json['token'],
        passwd = json['password'];

  Map toJson() {
    return {'id': id, 'name': name, 'token': token, 'password': passwd};
  }
}