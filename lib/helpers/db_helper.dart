import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<void> insert(String table, Map<String, Object> data) async {
    final dbPath = await sql.getDatabasesPath();
    sql.openDatabase(
      path.join(dbPath, 'finsim.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE income(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, frequency INTEGER, amount INTEGER, yearlyAppreciationPercentage INTEGER)');
      },
      version: 1,
    );
  }
}
