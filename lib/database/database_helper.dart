import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/diary.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diaries(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        imageLocalPath TEXT NOT NULL,
        userId TEXT NOT NULL,
        date TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertDiary(Diary diary) async {
    final db = await database;
    return await db.insert('diaries', diary.toMap());
  }

  Future<List<Diary>> getAllDiaries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('diaries');
    return List.generate(maps.length, (i) => Diary.fromMap(maps[i]));
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'diary.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;  // 데이터베이스 인스턴스 초기화
  }

  Future<List<Diary>> getDiariesForDate(DateTime date) async {
    final db = await database;
    final startDate = DateTime(date.year, date.month, date.day).toIso8601String();
    final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'diaries',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
    );
    
    return List.generate(maps.length, (i) => Diary.fromMap(maps[i]));
  }
}
