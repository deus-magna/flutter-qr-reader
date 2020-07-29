import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  // Constructor privado
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    // Path de la base de datos, diferente para iOS y para Android
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Unimos el directorio con el nombre de la base de datos.
    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')');
    });
  }

  // CREAR Registros
  newScanRaw(ScanModel newScan) async {
    final db = await database;

    final res = await db.rawInsert("INSERT INTO Scans (id, tipo, valor) "
        "VALUES (${newScan.id}, '${newScan.tipo}', '${newScan.valor}' )");
    return res;
  }

  newScan(ScanModel newScan) async {
    final db = await database;
    final res = await db.insert('Scans', newScan.toJson());
    return res;
  }

  // SELECT - Obtener información
  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScams() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ScanModel>> getScansByType(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];

    return list;
  }

  // Actualizar Registros
  Future<int> updateScan(ScanModel newScan) async {

    final db = await database;

    final res = await db.update('Scans', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id] );
    return res;
  }

  // Eliminar Registros
  Future<int> deleteScan( int id) async {
    
    final db = await database;
    final res = await db.delete('Scans', where: 'id=?', whereArgs: [id]);
    return res;
  }

   Future<int> deleteAll() async {
    
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }

}
