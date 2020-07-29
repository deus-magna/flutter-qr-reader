import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  // Un constructor internal nos ayuda a crear solo una vez el ScansBloc, es un singleton
  ScansBloc._internal() {
    // Obtener los Scans de la Base de datos
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validateHttp);

  dispose() {
    _scansController?.close();
  }

  addScan(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScams());
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAll();
    getScans();
  }
}
