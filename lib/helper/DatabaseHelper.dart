import 'dart:io';

import 'package:EnlistControl/models/atribute.dart';
import 'package:EnlistControl/models/vehiculos.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:EnlistControl/models/alistamiento.dart';

import '../model/Todo.dart';

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'enlist_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

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
          "CREATE TABLE alistamientos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, state TEXT, vehiculo TEXT, fecha INTEGER, responsable INTEGER, documentos_conductor INTEGER,  documentos_vehiculo INTEGER,  calcomania INTEGER,  pito INTEGER,  disp_velocidad INTEGER,  estado_esc_p_conductor INTEGER,  estado_esc_p_pasajero INTEGER,  equipo_carretera INTEGER,  linterna INTEGER,  extintor INTEGER,  botiquin INTEGER,  repuesto INTEGER,  retrovisores INTEGER,  cinturones INTEGER,  motor INTEGER,  llantas INTEGER, baterias INTEGER, transmision INTEGER, tension INTEGER, tapas INTEGER, niveles INTEGER,filtros INTEGER,parabrisas INTEGER, frenos INTEGER, frenos_emergencia INTEGER, aire INTEGER, luces INTEGER, silleteria INTEGER, silla_conductor INTEGER,aseo INTEGER, celular INTEGER, ruteros INTEGER, desc_documentos_conductor TEXT,  desc_documentos_vehiculo TEXT,  desc_calcomania TEXT,  desc_pito TEXT,  desc_disp_velocidad TEXT,  desc_estado_esc_p_conductor TEXT,  desc_estado_esc_p_pasajero TEXT,  desc_equipo_carretera TEXT,  desc_linterna TEXT,  desc_extintor TEXT,  desc_botiquin TEXT,  desc_repuesto TEXT,  desc_retrovisores TEXT,  desc_cinturones TEXT,  desc_motor TEXT,  desc_llantas TEXT, desc_baterias TEXT, desc_transmision TEXT, desc_tension TEXT, desc_tapas TEXT, desc_niveles TEXT, desc_filtros TEXT, desc_parabrisas TEXT, desc_frenos TEXT, desc_frenos_emergencia TEXT, desc_aire TEXT, desc_luces TEXT, desc_silleteria TEXT, desc_silla_conductor TEXT, desc_aseo TEXT, desc_celular TEXT, desc_ruteros TEXT, img_documentos_conductor TEXT,  img_documentos_vehiculo TEXT,  img_calcomania TEXT,  img_pito TEXT,  img_disp_velocidad TEXT,  img_estado_esc_p_conductor TEXT,  img_estado_esc_p_pasajero TEXT,  img_equipo_carretera TEXT,  img_linterna TEXT,  img_extintor TEXT,  img_botiquin TEXT,  img_repuesto TEXT,  img_retrovisores TEXT,  img_cinturones TEXT,  img_motor TEXT,  img_llantas TEXT, img_baterias TEXT, img_transmision TEXT, img_tension TEXT, img_tapas TEXT, img_niveles TEXT, img_filtros TEXT, img_parabrisas TEXT, img_frenos TEXT, img_frenos_emergencia TEXT, img_aire TEXT, img_luces TEXT, img_silleteria TEXT, img_silla_conductor TEXT, img_aseo TEXT, img_celular TEXT, img_ruteros TEXT)");
      await db.execute(
          "CREATE TABLE vehiculos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, idWia INTEGER NOT NULL, name TEXT)");
      await db.execute(
          "CREATE TABLE serviceintervals(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, desc TEXT, iK INTEGER, iT INTEGER, iH , pm INTEGER, pt INTEGER, pe INTEGER, c INTEGER, value TEXT, vehiculoId INTEGER, FOREIGN KEY(vehiculoId) REFERENCES vehiculos(idWia))");
      await db.execute(
          "CREATE TABLE atributos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name TEXT, value TEXT, vehiculoId INTEGER, FOREIGN KEY(vehiculoId) REFERENCES vehiculos(idWia))");    
    });
  }

  insertTodo(Alistamiento todo) async {
    final db = await database;
    var map = todo.toJson();
    var res = await db.insert(Alistamiento.TABLENAME, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
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
    final List<Map<String, dynamic>> maps =
        await db.query(Alistamiento.TABLENAME);
    print(maps);
    return List.generate(maps.length, (i) {
      return Alistamiento(
        vehiculo: maps[i]['vehiculo'],
        state: maps[i]['state'],
      );
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
