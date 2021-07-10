import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_income_screen.dart' show IncomeFrequency;
import 'package:finsim/screens/add_expenditure_screen.dart'
    show ExpenditureFrequency;
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

  static Future<void> saveIncome(Income income) {
    return insert(
      'income',
      {
        'name': income.name,
        'frequency': IncomeFrequency.values
            .indexOf(income.frequency), //Storing enum index in database
        'amount': income.amount,
        'yearlyAppreciationPercentage': income.yearlyAppreciationPercentage,
      },
    );
  }

  static Future<void> saveExpenditure(Expenditure expenditure) {
    return insert(
      'expenditure',
      {
        'name': expenditure.name,
        'frequency': ExpenditureFrequency.values
            .indexOf(expenditure.frequency), //Storing enum index in database
        'amount': expenditure.amount,
        'yearlyAppreciationPercentage':
            expenditure.yearlyAppreciationPercentage,
      },
    );
  }

  static Future<List<Income>> getIncome() async {
    final incomeMapList = await fetch('income');
    List<Income> incomeList = [];
    incomeMapList.forEach((incomeMap) {
      var income = Income();
      income.name = incomeMap['name'];
      income.frequency = IncomeFrequency.values[incomeMap['frequency']];
      income.amount = incomeMap['amount'];
      income.yearlyAppreciationPercentage =
          incomeMap['yearlyAppreciationPercentage'];

      incomeList.add(income);
    });

    return incomeList;
  }

  static Future<List<Expenditure>> getExpenditure() async {
    final expenditureMapList = await fetch('expenditure');
    List<Expenditure> expenditureList = [];
    expenditureMapList.forEach((expenditureMap) {
      var expenditure = Expenditure();
      expenditure.name = expenditureMap['name'];
      expenditure.frequency =
          ExpenditureFrequency.values[expenditureMap['frequency']];
      expenditure.amount = expenditureMap['amount'];
      expenditure.yearlyAppreciationPercentage =
          expenditureMap['yearlyAppreciationPercentage'];

      expenditureList.add(expenditure);
    });

    return expenditureList;
  }
}
