import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class User {
  String id;
  String name;
  String passwd;
  String token;
  User(String id, String name, String pass, String token) {
    this.id = id;
    this.name = name;
    this.token = token;
    this.passwd = pass;
  }
  setToken(String token) {
    this.token = token;
  }

  User.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        token = json['token'],
        passwd = json['password'];

  Map toJson() {
    return {'id': id, 'name': name, 'token': token, 'password': passwd};
  }

  getDataOfToken() async {
    if(this.token==null){
      return "No tienes token asignado";
    }else{
      var accesToken = this.token;
      var url = "http://hst-api.wialon.com/wialon/ajax.html?svc=token/login&params={%22token%22:%22$accesToken%22}";
      await http.get(url).then((res){
        if(res.statusCode == 200){
          var jsonResponse = convert.jsonDecode(res.body);
          this.name = jsonResponse["user"]["nm"];
          this.id = jsonResponse["user"]["id"].toString();
        }
      });
      return "Okas";
    }
  }
}
