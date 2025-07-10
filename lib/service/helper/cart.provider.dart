import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'cart.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY,
            name TEXT,
            quantity INTEGER,
            price INTEGER,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertCartItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert('cart', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('cart', orderBy: 'timestamp DESC');
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }
}
