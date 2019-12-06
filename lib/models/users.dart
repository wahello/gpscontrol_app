const mockUsers = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'near.huscarl@gmail.com': 'subscribe to pewdiepie',
  '@.com': '.',
};

class User {
  String id;
  String name;
  String email;
  String passwd;

  User(String id, String name, String email,String pass) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.passwd = pass;
  }

  User.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        passwd = json['password'];

  Map toJson() {
    return {'id': id, 'name': name, 'email': email, 'password': passwd};
  }
}