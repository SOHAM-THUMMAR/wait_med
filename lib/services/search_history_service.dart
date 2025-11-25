import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SearchHistoryService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'search_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            keyword TEXT NOT NULL,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
  }

  // Save search keyword
  static Future<void> saveSearch(String keyword) async {
    if (keyword.trim().isEmpty) return;

    final db = await database;

    await db.insert('history', {
      'keyword': keyword,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get recent searches
  static Future<List<String>> getSearchHistory() async {
    final db = await database;

    final result = await db.query(
      'history',
      orderBy: 'timestamp DESC',
      limit: 10,
    );

    return result.map((e) => e['keyword'] as String).toList();
  }

  // Clear all
  static Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
