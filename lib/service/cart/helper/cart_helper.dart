import 'package:sqflite/sqflite.dart';
import 'package:praktikum/service/database/database.dart';

class CartHelper {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // CREATE (Insert item ke cart)
  Future<void> insertCartItem(Map<String, dynamic> item) async {
    final db = await dbHelper.database;
    await db.insert('cart', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // READ (Ambil semua item dari cart)
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await dbHelper.database;
    return await db.query('cart');
  }

  // UPDATE (Perbarui jumlah item di cart)
  Future<void> updateCartItem(int id, int quantity) async {
    final db = await dbHelper.database;
    await db.update(
      'cart',
      {"quantity": quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE (Hapus item berdasarkan id)
  Future<void> deleteCartItem(int id) async {
    final db = await dbHelper.database;
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  // DELETE ALL (Hapus semua item di cart)
  Future<void> clearCart() async {
    final db = await dbHelper.database;
    await db.delete('cart');
  }
}
