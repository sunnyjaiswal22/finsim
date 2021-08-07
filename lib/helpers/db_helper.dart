import 'package:finsim/models/asset.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static const dbName = 'finsim.db';
  static const version = 1;

  static Future<void> _onCreate(sql.Database db, version) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS income (
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  name TEXT, 
                  frequency INTEGER, 
                  amount INTEGER, 
                  yearlyAppreciationPercentage INTEGER, 
                  startDate TEXT, 
                  endDate TEXT, 
                  belongsToAsset INTEGER);''');
    await db.execute('''CREATE TABLE IF NOT EXISTS expenditure (
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  name TEXT, 
                  frequency INTEGER, 
                  amount INTEGER, 
                  yearlyAppreciationPercentage INTEGER, 
                  startDate TEXT, 
                  endDate TEXT, 
                  belongsToAsset INTEGER);''');
    await db.execute('''CREATE TABLE IF NOT EXISTS asset (
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  name TEXT, 
                  startDate TEXT, 
                  endDate TEXT, 
                  yearlyAppreciationPercentage INTEGER, 
                  expenditure_id INTEGER, 
                  generatesIncome INTEGER, 
                  income_id INTEGER, 
                  FOREIGN KEY(expenditure_id) REFERENCES expenditure(id), 
                  FOREIGN KEY(income_id) REFERENCES income(id));''');
    return;
  }

  static Future<void> _onConfigure(sql.Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static Future<sql.Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, dbName),
      onCreate: _onCreate,
      onConfigure: _onConfigure,
      version: version,
    );
  }

  static Future<int> insert(
    String table,
    Map<String, Object> data, [
    sql.Transaction? txn,
  ]) async {
    final db = txn != null ? txn : await getDatabase();

    return await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchWhere(
    String table,
    String? where,
    List<Object?>? whereArgs,
  ) async {
    final db = await getDatabase();

    return db.query(table, where: where, whereArgs: whereArgs);
  }

  static Future<int> saveIncome(
    Income income, [
    sql.Transaction? txn,
  ]) async {
    return await insert('income', income.toMap(), txn);
  }

  static Future<int> saveExpenditure(
    Expenditure expenditure, [
    sql.Transaction? txn,
  ]) async {
    return await insert('expenditure', expenditure.toMap(), txn);
  }

  static Future<int> saveAsset(Asset asset) async {
    final db = await getDatabase();

    return await db.transaction((txn) async {
      asset.expenditure.id = await saveExpenditure(asset.expenditure, txn);
      asset.income.id = await saveIncome(asset.income, txn);
      return await insert('asset', asset.toMap(), txn);
    });
  }

  static Future<int> deleteExpenditure(int id, [sql.Transaction? txn]) async {
    var db = txn != null ? txn : await getDatabase();

    return await db.delete('expenditure', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteIncome(int id, [sql.Transaction? txn]) async {
    final db = txn != null ? txn : await getDatabase();

    return await db.delete('income', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteAsset(Asset asset) async {
    final db = await getDatabase();

    return await db.transaction((txn) async {
      var deleteStatus =
          await txn.delete('asset', where: 'id = ?', whereArgs: [asset.id]);
      if (asset.expenditure.id != 0) {
        await deleteExpenditure(asset.expenditure.id, txn);
      }
      if (asset.income.id != 0) {
        await deleteIncome(asset.income.id, txn);
      }
      return deleteStatus;
    });
  }

  static Future<List<Income>> getIncomes() async {
    final db = await getDatabase();

    List<Income> list = [];
    final mapList = await db.query('income');
    mapList.forEach((map) {
      list.add(Income.fromMap(map));
    });

    return list;
  }

  static Future<List<Expenditure>> getExpenditures() async {
    final db = await getDatabase();

    final mapList = await db.query('expenditure');
    List<Expenditure> list = [];
    mapList.forEach((map) {
      list.add(Expenditure.fromMap(map));
    });

    return list;
  }

  static Future<Expenditure> getExpenditure(int id) async {
    final mapList = await fetchWhere('expenditure', '"id" = ?', [id]);
    final map = mapList[0];
    return Expenditure.fromMap(map);
  }

  static Future<Income> getIncome(int id) async {
    final mapList = await fetchWhere('income', '"id" = ?', [id]);
    final map = mapList[0];
    return Income.fromMap(map);
  }

  static Future<List<Asset>> getAssets() async {
    final db = await getDatabase();

    final mapList = await db.query('asset');
    List<Asset> list = [];
    for (var map in mapList) {
      var asset = Asset.fromMap(map);
      list.add(asset);
      //Get Expenditure data
      asset.expenditure = await getExpenditure(
        int.parse(map['expenditure_id'].toString()),
      );
      //Get Income data
      asset.income = await getIncome(
        int.parse(map['income_id'].toString()),
      );
    }

    return list;
  }
}
