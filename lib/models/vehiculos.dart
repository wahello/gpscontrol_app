import 'dart:convert';
import 'package:EnlistControl/helper/DatabaseHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:EnlistControl/models/atribute.dart';

class Vehiculo {
  static const String TABLENAME = "vehiculos";
  String id;
  int oID;
  String name;
  List<Atribute> atributos;
  List<Intervalo> intervalos;
  Vehiculo(String id, String name) {
    this.id = id;
    this.name = name;
  }

  Vehiculo.fromJson(Map json)
    : id = json['id'],
      name = json['nm'];

  Map<String, dynamic> toJson(){
    return {
      'idWia': int.parse(this.id),
      'name': this.name,
    };
  }

  getData(sid) async {
    List<Atribute> lista = [];
    List<Intervalo> intervals = [];
    if(this.id==null){
      return "No tienes ID asignado";
    }else{
      var url ='https://hst-api.wialon.com/wialon/ajax.html?svc=core/search_item&params={%22id%22:';
      var complement = ',%22flags%22:4611686018427387903}&sid=';
      var idWia = this.id;
      var response = await http.get(url + '$idWia' + complement + sid);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['item'].containsKey("aflds")) {
          Map atributos = jsonResponse['item']['aflds'];
          for (var i in atributos.values) {
            var atribute = new Atribute(name: i['n'], value: i['v']);
            _saveAttrib(atribute, int.parse(this.id));
            lista.add(atribute);
          }
        } else {
          print('el objeto no tiene la clave aflds');
        }
        /*if (jsonResponse['item'].containsKey("pflds")) {
          Map atributos = jsonResponse['item']['pflds'];
          for (var i in atributos.values) {
            var atribute = new Atribute(name: i['n'], value: i['v']);
            _saveAttrib(atribute, int.parse(this.id));
            lista.add(atribute);
          }
        } else {
          print('el objeto no tiene la clave aflds');
        }*/
        if (jsonResponse['item'].containsKey("si")) {
          Map atributos = jsonResponse['item']['si'];
          for (var i in atributos.values) {
            print(i);
            var interval = new Intervalo(
                name: i['n'],
                desc: i['t'],
                iK: i['im'],
                iD: i['it'],
                iH: i['ie'],
                pm: i['pm'],
                pt: i['pt'],
                pe: i['pe'],
                c: i['c']);
            interval.calculateInterval();
            _saveSI(interval, int.parse(this.id));
            intervals.add(interval);
          }
        } else {
          print('el objeto no tiene la clave si');
        }
        intervalos = intervals;
        atributos = lista;
        return lista;
      } else {
        lista = [];
        return lista;
      }
    }
  }

  setOid(int id){
    this.oID = id;
  }

  _saveAttrib(Atribute attr, int id) async {
    var status = await DatabaseHelper.instance.initializeDatabase();
    print(status);
    DatabaseHelper.instance.insertAttrib(attr, id);
  }

  _saveSI(Intervalo interv, int id) async {
    var status = await DatabaseHelper.instance.initializeDatabase();
    print(status);
    DatabaseHelper.instance.insertSI(interv, id);
  }

}
