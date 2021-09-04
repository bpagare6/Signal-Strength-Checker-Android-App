import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:SignalStrengthChecker/models/result.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton Database Helper
  static Database _database;

  String historyTable = "history_table";
  String colId = "id";
  String colDate = "date";
  String colTime = "time";
  String colAvgNetworType = "avgNetworkType";
  String colAvgSignalStrength = "avgSignalStrength";
  String colProgressBarData = "progressBarData";
  String colOperatorName = "operatorName";
  String colLatitude = "latitude";
  String colLongitude = "longitude";
  String colAddress = "address";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database != null)
      return _database;
    _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'history.db';
    Database historyDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return historyDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $historyTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDate TEXT, $colTime TEXT, $colAvgNetworType TEXT, $colAvgSignalStrength TEXT, $colProgressBarData TEXT, $colOperatorName TEXT, $colLatitude TEXT, $colLongitude TEXT, $colAddress TEXT)');
  }

  // Fetch Operation
  Future<List<Map<String, dynamic>>> getHistoryMapList() async {
    Database db = await this.database;
    var result = db.query(historyTable, orderBy: '$colId DESC');
    return result;
  }

  Future<List<Result>> getHistoryList() async {
    var historyMapList = await getHistoryMapList();
    int count = historyMapList.length;
    List<Result> historyList = List<Result>();
    for (int i = 0; i < count; i++) {
      historyList.add(Result.fromMapObject(historyMapList[i]));
    }
    return historyList;
  }

  // Insert Operation
  Future<int> insertResult(Result r) async {
    Database db = await this.database;
    print('Insert: ${r.toString()}');
    var result = await db.rawInsert(
      'INSERT INTO $historyTable($colDate, $colTime, $colAvgNetworType, $colAvgSignalStrength, $colProgressBarData, $colOperatorName, $colLatitude, $colLongitude, $colAddress) VALUES ("${r.date}", "${r.time}", "${r.avgNetworkType}", "${r.avgSignalStrength}", "${r.progressBarData}", "${r.operatorName}", "${r.latitude}", "${r.longitude}", "${r.address}")'
    );
    print('Result inserted $result');
    // var result = await db.insert(historyTable, r.toMap(), nullColumnHack: colId);
    return result;
  }
}
