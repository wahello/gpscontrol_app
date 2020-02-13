import 'dart:io';

import 'package:EnlistControl/models/atribute.dart';
import 'package:EnlistControl/models/vehiculos.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:EnlistControl/models/alistamiento.dart';


class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'enlist_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;
  Duration get loginTime => Duration(seconds: 1);

  Future<Database> get database async {
    if (_database != null) {
      print('database != null');
      return _database;
    } else {
      print('database == null iniciando... ');
      _database = await initializeDatabase();
      return _database;
    }

    //
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE alistamientos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, folio TEXT NOT NULL, vehiculo TEXT, conductor TEXT, estado TEXT, fecha INTEGER)");
          
      await db.execute(
          "CREATE TABLE vehiculos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, idWia INTEGER NOT NULL, name TEXT)");
      await db.execute(
          "CREATE TABLE serviceintervals(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, desc TEXT, iK INTEGER, iT INTEGER, iH , pm INTEGER, pt INTEGER, pe INTEGER, c INTEGER, value TEXT, vehiculoId INTEGER, FOREIGN KEY(vehiculoId) REFERENCES vehiculos(idWia))");
      await db.execute(
          "CREATE TABLE atributos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name TEXT, value TEXT, vehiculoId TEXT, FOREIGN KEY(vehiculoId) REFERENCES vehiculos(idWia))");    
    });
  }
  insertTodo(Alistamiento todo) async {
    final db = await database;
    var map = todo.toJson();
    var validation = await db.query(Alistamiento.TABLENAME, where: '"folio" = ?', whereArgs: [todo.folio]);
    if(validation.length >= 1){
      print("el alistamiento ${todo.folio} ya existe");
    }else{
      print("Como no existe, creamos el alistamiento ${todo.folio}");
      var res = await db.insert(Alistamiento.TABLENAME, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
      return res;
    }

    
  }

  insertVehicle(Vehiculo vehiculo) async {
    final db = await database;
    var map = vehiculo.toJson();
    var res = await db.insert(Vehiculo.TABLENAME, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
        print(res);
    return res;
  }

  insertSI(Intervalo intervalo, int id) async {
    //se supone que el intervalo llega con el value calculado.
    final db = await database;
    var map = intervalo.toJson(id);
    var res = await db.insert(Intervalo.TABLENAME, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  insertAttrib(Atribute attr, int id) async {
    final db = await database;
    var map = attr.toJson(id);
    var res = await db.insert(Atribute.TABLENAME, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Alistamiento>> retrieveTodos() async {
    final db = await database;
    print(db);
    List<Map<String, dynamic>> maps = await db.query(Alistamiento.TABLENAME, orderBy: "folio DESC");
    return List.generate(maps.length, (i) {
      Alistamiento alis = new Alistamiento.dbJson(maps[i],);
      return alis;
    });
  }

  Future<List<Vehiculo>> retrieveVehiculos() async {
    final db = await database;
    print(db);
    final List<Map<String, dynamic>> maps =
        await db.query(Vehiculo.TABLENAME);
    print(maps);
    return List.generate(maps.length, (i) {
      var recVehiculo = new Vehiculo( maps[i]['idWia'].toString(), maps[i]['name']);
      return recVehiculo;
    });
  }

  Future<List<Intervalo>> retrieveSI(int id) async {
    if(id!=0){
      final db = await database;
      print(db);
      final List<Map<String, dynamic>> maps =
          await db.query(Intervalo.TABLENAME, where: "vehiculoId == $id");
      print(maps);
      return List.generate(maps.length, (i) {
        var recSI = new Intervalo(name: maps[i]['name'],desc: maps[i]['desc'], iK: maps[i]['ik'] , iD:  maps[i]['iT'], iH:  maps[i]['iH'], pm:  maps[i]['pm'] ,pt: maps[i]['pt'], pe: maps[i]['pe'], c: maps[i]['c']);
        return recSI;
      });
    }else{
      List<Intervalo> fakeInterval = [];
      return fakeInterval;
    }
  }

  Future<List<Atribute>> retrieveAttrs(int id) async {
    if(id!=0){
      final db = await database;
      print(db);
      final List<Map<String, dynamic>> maps =
          await db.query(Atribute.TABLENAME);
      print(maps);
      return List.generate(maps.length, (i) {
        var recAttr = new Atribute(name:  maps[i]['name'], value: maps[i]['value']);
        return recAttr;
      });
    }else{
      List<Atribute> fakeAttr = [];
      return fakeAttr;
    }
  }

  updateTodo(Alistamiento todo) async {
    final db = await database;

    await db.update(Alistamiento.TABLENAME, todo.toJson(),
        where: 'vehiculo = ?',
        whereArgs: [todo.vehiculo],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteTodo(int id) async {
    var db = await database;
    db.delete(Alistamiento.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }

  clearDb() async {
    var db = await database;
    db.delete(Alistamiento.TABLENAME, where: 'id != 0');
    db.delete(Vehiculo.TABLENAME, where: 'id != 0');
    db.delete(Intervalo.TABLENAME, where: 'id != 0');
    db.delete(Vehiculo.TABLENAME, where: 'id != 0');
  }
}
