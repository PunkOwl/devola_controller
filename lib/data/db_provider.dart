import 'dart:io';

import 'package:devola_controller/model/entity/devola_settings_entity.dart';
import 'package:devola_controller/util/exception_manager.dart';
import 'package:path/path.dart';
import 'package:devola_controller/app_const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, AppConst.DB_NAME);

    return await openDatabase(
        path,
        version: 1,
        readOnly: false,
        onOpen: (db) async {
          await syncExistingTables(db);
        },
        onCreate: (Database db, int version) async {
          await createTables(db);
        }
    );
  }

  createTables(Database db) async {
    await db.execute('''
      CREATE TABLE devola_settings(
        id INTEGER PRIMARY KEY,
        app_version TEXT,
        devola_addr TEXT
      )
    ''');
  }

  syncExistingTables(Database db) async {
    DevolaSettingsEntity entity = DevolaSettingsEntity(
      id: 0,
      appVersion: AppConst.APP_VERSION,
      devolaAddr: '',
    );
    try {
      var res = await db.query('devola_settings', where: 'id = ?', whereArgs: [0]);
      DevolaSettingsEntity localEntity = res.isNotEmpty ? DevolaSettingsEntity.fromMap(res.first) : null;
      if(localEntity.appVersion != entity.appVersion) {
        await reloadTables(db, entity);
      }
    } catch(ex, stacktrace) {
      ExceptionManager.xMan.captureException(ex, stacktrace);
      await reloadTables(db, entity);
    }
  }

  reloadTables(Database db, DevolaSettingsEntity entity) async {
    await db.execute('DROP TABLE IF EXISTS devola_settings');
    await createTables(db);
    await db.insert('devola_settings', entity.toMap());
  }

  // =========================== SETTINGS ============================== //
  Future<DevolaSettingsEntity> getSettings() async {
    final db = await database;
    var res = await db.query('devola_settings');
    List<DevolaSettingsEntity> app = res.isNotEmpty? res.map((user) =>
        DevolaSettingsEntity.fromMap(user)).toList() : [];
    if(app.length > 0) {
      return app.first;
    }
    return null;
  }

  updateSettings(DevolaSettingsEntity entity) async {
    final db = await database;
    var res = await db.update('devola_settings', entity.toMap(), where: 'id = ?', whereArgs: [entity.id]);
    return res;
  }

  deleteSettings() async {
    final db = await database;
    db.delete('devola_settings');
  }
}