import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:CatatDong/models/transaksi.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String DATE = 'date';
  static const String NOTE = 'note';
  static const String TXCATEGORY = 'txCategory';
  static const String CATEGORY = 'category';
  static const String PRICE = 'price';
  static const String TABLE = 'Transaksi';
  static const String DB_NAME = 'transaction.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute('CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $DATE TEXT, $NOTE TEXT, $TXCATEGORY TEXT, $CATEGORY TEXT, $PRICE REAL)');
  }

  Future<Transaksi> save(Transaksi transaction) async {
    var dbClient = await db;
    transaction.id = await dbClient.insert(TABLE, transaction.toMap());
    return transaction;
    // await dbClient.transaction((txn) async {
    //   var query = 'INSERT INTO $TABLE ($NAME) VALUES (\'" + transaction.name + "\')'
    // });
  }

  Future<List<Transaksi>> getTransaction() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, DATE, NOTE, TXCATEGORY, CATEGORY, PRICE]);
    // List<Map> maps = await dbClient.rawQuery('SELECT * FROM $TABLE');
    List<Transaksi> transaction = [];
    if (maps.length > 0) {
      maps.forEach((maps) {
        transaction.add(Transaksi.fromMap(maps));
      });
    }
    return transaction;
  }

  Future<List<Transaksi>> getExpenses() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, DATE, NOTE, TXCATEGORY, CATEGORY, PRICE]);
    List<Transaksi> transaction = [];
    if (maps.length > 0) {
      maps.forEach((maps) {
        if (maps['txCategory'] == 'Pengeluaran') {
          transaction.add(Transaksi.fromMap(maps));
        }
      });
    }
    return transaction;
  }

  Future<double> getTotalExpenses() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, DATE, NOTE, TXCATEGORY, CATEGORY, PRICE]);
    double transaction = 0.0;
    if (maps.length > 0) {
      maps.forEach((maps) {
        if (maps['txCategory'] == 'Pengeluaran') {
          transaction += maps['price'];
        }
      });
    }
    return transaction;
  }

  Future<double> getTotalIncome() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, DATE, NOTE, TXCATEGORY, CATEGORY, PRICE]);
    double transaction = 0.0;
    if (maps.length > 0) {
      maps.forEach((maps) {
        if (maps['txCategory'] == 'Pemasukan') {
          transaction += maps['price'];
        }
      });
    }
    return transaction;
  }

  Future<List<Transaksi>> getIncome() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, DATE, NOTE, TXCATEGORY, CATEGORY, PRICE]);
    List<Transaksi> transaction = [];
    if (maps.length > 0) {
      maps.forEach((maps) {
        if (maps['txCategory'] == 'Pemasukan') {
          transaction.add(Transaksi.fromMap(maps));
        }
      });
    }
    return transaction;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Transaksi transaction) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, transaction.toMap(), where: '$ID = ?', whereArgs: [transaction.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
