import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'rss_reader.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE feeds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        url TEXT UNIQUE,
        last_updated INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        feed_id INTEGER,
        title TEXT,
        description TEXT,
        link TEXT,
        pub_date INTEGER,
        is_read INTEGER DEFAULT 0,
        FOREIGN KEY (feed_id) REFERENCES feeds (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertFeed(Map<String, dynamic> feed) async {
    Database db = await database;
    return await db.insert('feeds', feed);
  }

  Future<int> insertItem(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.insert('items', item);
  }

  Future<List<Map<String, dynamic>>> getFeeds() async {
    Database db = await database;
    return await db.query('feeds');
  }

  Future<List<Map<String, dynamic>>> getItemsByFeedId(int feedId) async {
    Database db = await database;
    return await db.query('items', where: 'feed_id = ?', whereArgs: [feedId]);
  }

  Future<void> markItemAsRead(int itemId) async {
    Database db = await database;
    await db.update('items', {'is_read': 1}, where: 'id = ?', whereArgs: [itemId]);
  }

  Future<void> deleteFeed(int feedId) async {
    Database db = await database;
    await db.transaction((txn) async {
      await txn.delete('items', where: 'feed_id = ?', whereArgs: [feedId]);
      await txn.delete('feeds', where: 'id = ?', whereArgs: [feedId]);
    });
  }

  Future<Map<String, dynamic>?> getFeedByUrl(String url) async {
    final db = await database;
    final result = await db.query('feeds', where: 'url = ?', whereArgs: [url]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getItemByLink(String link) async {
    final db = await database;
    final result = await db.query('items', where: 'link = ?', whereArgs: [link]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getFeedById(int id) async {
    final db = await database;
    final result = await db.query('feeds', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateFeedLastUpdated(int feedId, int lastUpdated) async {
    final db = await database;
    await db.update('feeds', {'last_updated': lastUpdated}, where: 'id = ?', whereArgs: [feedId]);
  }
}
