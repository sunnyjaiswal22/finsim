import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/models/investment.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static const dbName = 'finsim.db';
  static const version = 1;

  static Future<void> createDatabase(sql.Database db, version) async {
    await db.execute('''CREATE TABLE income (
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  name TEXT, 
                  frequency INTEGER, 
                  amount INTEGER, 
                  yearlyAppreciationPercentage INTEGER);''');
    await db.execute('''CREATE TABLE expenditure (
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  name TEXT, 
                  frequency INTEGER, 
                  amount INTEGER, 
                  yearlyAppreciationPercentage INTEGER);''');
    await db.execute('''CREATE TABLE investment (
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  startDate TEXT,
                  endDate TEXT,
                  name TEXT, 
                  frequency INTEGER, 
                  amount INTEGER, 
                  profitPercentage INTEGER);''');
    return;
  }

  static Future<sql.Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, dbName),
      onCreate: createDatabase,
      version: version,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await getDatabase();

    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fetch(String table) async {
    final db = await getDatabase();

    return db.query(table);
  }

  static Future<void> saveIncome(Income income) async {
    return await insert('income', income.toMap());
  }

  static Future<void> saveExpenditure(Expenditure expenditure) async {
    return await insert('expenditure', expenditure.toMap());
  }

  static Future<int> deleteExpenditure(int id) async {
    final db = await getDatabase();

    return await db.delete('expenditure', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteIncome(int id) async {
    final db = await getDatabase();

    return await db.delete('income', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteInvestment(int id) async {
    final db = await getDatabase();

    return await db.delete('investment', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Income>> getIncome() async {
    final mapList = await fetch('income');
    List<Income> list = [];
    mapList.forEach((map) {
      list.add(Income.fromMap(map));
    });

    return list;
  }

  static Future<List<Expenditure>> getExpenditure() async {
    final mapList = await fetch('expenditure');
    List<Expenditure> list = [];
    mapList.forEach((map) {
      list.add(Expenditure.fromMap(map));
    });

    return list;
  }

  static Future<List<Investment>> getInvestment() async {
    final mapList = await fetch('investment');
    List<Investment> list = [];
    mapList.forEach((map) {
      list.add(Investment.fromMap(map));
    });

    return list;
  }
}
