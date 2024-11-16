import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// สร้าง class จัดการข้อมูล
class DatabaseManagement {

  static final DatabaseManagement instance = DatabaseManagement._init();
  static Database? _database;
  final String tableTransaction = "Transactions";
  final String tableBudget = "Budget";
  final String tableTypeTransaction = "Type_transaction";

  DatabaseManagement._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transaction.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    //await deleteDatabase(path); // ลบฐานข้อมูลหากมีอยู่แล้ว
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final columnIdTransaction = 'ID_transaction';
    final columnDateUser = 'date_user';
    final columnAmountTransaction = 'amount_transaction';
    final columnTypeExpense = 'type_expense';
    final columnMemoTransaction = 'memo_transaction';
    final columnReferralCode = 'referral_code';

    final columnIdTypeTransaction = 'ID_type_transaction';
    final columnTypeTransaction = 'type_transaction';

    final columnIdBudget = 'ID_budget';
    final columnCapitalBudget = 'capital_budget';
    final columnDateStart = 'date_start';
    final columnDateEnd = 'date_end';

    await db.execute('''CREATE TABLE $tableTransaction (
      $columnIdTransaction INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnDateUser TEXT NOT NULL,
      $columnAmountTransaction REAL NOT NULL,
      $columnTypeExpense BOOLEAN NOT NULL,
      $columnMemoTransaction TEXT,
      $columnIdTypeTransaction INTEGER,  
      $columnReferralCode TEXT,  
      FOREIGN KEY ($columnIdTypeTransaction) REFERENCES $tableTypeTransaction ($columnIdTypeTransaction)
    )''');

    await db.execute('''CREATE TABLE $tableBudget (
      $columnIdBudget INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnCapitalBudget REAL NOT NULL,
      $columnIdTypeTransaction INTEGER NOT NULL,
      $columnDateStart TEXT NOT NULL,
      $columnDateEnd TEXT NOT NULL,
      FOREIGN KEY ($columnIdTypeTransaction) REFERENCES $tableTypeTransaction ($columnIdTypeTransaction)
    )''');

    await db.execute('''CREATE TABLE $tableTypeTransaction (
      $columnIdTypeTransaction INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTypeTransaction TEXT NOT NULL
    )''');

    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Food' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Travel expenses' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Water bill' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Electricity bill' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Internet cost' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'House cost' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Car fare' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Gasoline cost' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Medical expenses' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Beauty expenses' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Other' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'IC' });



    //----------------------------------{ Mock data }------------------------------------
    // await db.insert(tableBudget, {
    //   columnCapitalBudget: 1000.0,
    //   columnIdTypeTransaction: 1,
    //   columnDateStart: '2024-01-01T00:00:00',
    //   columnDateEnd: '2024-12-31T23:59:59',
    // });

    // await db.insert(tableBudget, {
    //   columnCapitalBudget: 500.0,
    //   columnIdTypeTransaction: 2,
    //   columnDateStart: '2024-02-01T00:00:00',
    //   columnDateEnd: '2024-11-30T23:59:59',
    // });

    // await db.insert(tableBudget, {
    //   columnCapitalBudget: 800.0,
    //   columnIdTypeTransaction: 3,
    //   columnDateStart: '2024-03-01T00:00:00',
    //   columnDateEnd: '2024-10-31T23:59:59',
    // });
    //-----------------------------------------------------------------------------------
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableTransaction, row);
  }

  Future<List<Map<String, dynamic>>> queryAllTransactions() async {
    Database db = await instance.database;
    return await db.query(tableTransaction);
  }

  Future<int> updateTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['ID_transaction'];
    return await db.update(tableTransaction, row, where: 'ID_transaction = ?', whereArgs: [id]);
  }

  Future<int> deleteTransaction(int id) async {
    Database db = await instance.database;
    return await db.delete(tableTransaction, where: 'ID_transaction = ?', whereArgs: [id]);
  }

  Future<int> insertBudget(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableBudget, row);
  }

  Future<List<Map<String, dynamic>>> queryAllBudgets() async {
    Database db = await instance.database;
    return await db.query(tableBudget);
  }

  Future<int> updateBudget(Map<String, dynamic> row, int idBudget) async {
    Database db = await instance.database;
    return await db.update(tableBudget, row, where: 'ID_budget = ?', whereArgs: [idBudget],);
  }

  Future<int> deleteBudget(int id) async {
    Database db = await instance.database;
    return await db.delete(tableBudget, where: 'ID_budget = ?', whereArgs: [id]);
  }

  Future<int> insertTypeTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableTypeTransaction, row);
  }

  Future<List<Map<String, dynamic>>> queryAllTypeTransactions() async {
    Database db = await instance.database;
    return await db.query(tableTypeTransaction);
  }

  Future<int> updateTypeTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['ID_type_transaction'];
    return await db.update(tableTypeTransaction, row, where: 'ID_type_transaction = ?', whereArgs: [id]);
  }

  Future<int> deleteTypeTransaction(int id) async {
    Database db = await instance.database;
    return await db.delete(tableTypeTransaction, where: 'ID_type_transaction = ?', whereArgs: [id]);
  }

  // ---------------------------{ delete ตาราง }----------------------------
  // Future<int> deleteAllTransactions() async {
  //   final db = await instance.database;
  //   return await db.delete('transactions');
  // }

  // Future<int> deleteAllBudgets() async {
  //   final db = await instance.database;
  //   return await db.delete('Budget');
  // }

  // Future close() async {
  //   final db = await instance.database;
  //   db.close();
  // }
  // ------------------------------------------------------

  Future<void> showAllData() async {
    Database db = await instance.database;

    // ดึงข้อมูลจากตาราง transaction
    List<Map<String, dynamic>> transactions = await db.query(tableTransaction);
    print('Transactions:');
    printTable(transactions);

    // ดึงข้อมูลจากตาราง budget
    List<Map<String, dynamic>> budgets = await db.query(tableBudget);
    print('Budgets:');
    printTable(budgets);

    // ดึงข้อมูลจากตาราง type_transaction
    List<Map<String, dynamic>> typeTransactions = await db.query(tableTypeTransaction);
    print('Type Transactions:');
    printTable(typeTransactions);
  }

  // ฟังก์ชันสำหรับแสดงข้อมูลในรูปแบบตาราง
  void printTable(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      print('No data available.');
      return;
    }

    // แสดงชื่อคอลัมน์
    String header = data.first.keys.join(' | ');
    print(header);
    print('-' * header.length); // เส้นใต้ชื่อคอลัมน์

    // แสดงข้อมูล
    for (var row in data) {
      print(row.values.join(' | '));
    }
  }

  Future<Map<int, String>> getTypeTransactionsMap() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(tableTypeTransaction);
    Map<int, String> typeMap = {};
    for (var row in results) {
      typeMap[row['ID_type_transaction']] = row['type_transaction'];
    }
    return typeMap;
  }

  //ดึง ID_type_transaction จาก type_transaction
  Future<int?> getTypeTransactionId(String category) async {
    Database db = await DatabaseManagement.instance.database;
    List<Map<String, dynamic>> results = await db.query(
      'type_transaction',
      columns: ['ID_type_transaction'],
      where: 'type_transaction = ?',
      whereArgs: [category],
    );

    if (results.isNotEmpty) {
      return results.first['ID_type_transaction'];
    }
    return null;
  }

  //ดึง type_transaction จาก ID_type_transaction
  Future<String?> getTypeTransactionNameById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      tableTypeTransaction,
      columns: ['type_transaction'],
      where: 'ID_type_transaction = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first['type_transaction'];
    }
    return null;
  }

  // ตัวอย่างของการกำหนด method สำหรับการดึงข้อมูล budget ตาม ID_budget
  Future<Map<String, dynamic>?> getBudgetById(int idBudget) async {
    final db = await instance.database;

    // Query ข้อมูลจากฐานข้อมูล โดยเลือกจากตาราง budget ที่ ID_budget ตรงกับที่ระบุ
    final result = await db.query(
      'budget',
      where: 'ID_budget = ?',
      whereArgs: [idBudget],
    );

    if (result.isNotEmpty) {
      return result.first; // ถ้าพบข้อมูล จะส่งข้อมูลแถวแรกกลับไป
    } else {
      return null; // ถ้าไม่พบข้อมูล
    }
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query, [List<Object>? arguments]) async {
    final db = await instance.database;
    return await db.rawQuery(query, arguments);
  }

  Future<bool> checkReferralExists(String? referral) async {
    if (referral == null || referral.isEmpty) {
      return false; // ไม่ซ้ำหากค่าเป็น null หรือว่าง
    }

    final db = await instance.database;

    // query เพื่อตรวจสอบความซ้ำซ้อนในฐานข้อมูล
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM transactions WHERE referral_code = ?',
      [referral],
    );

    return Sqflite.firstIntValue(result)! > 0;
  }

}