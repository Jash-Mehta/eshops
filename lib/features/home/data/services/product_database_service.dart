import 'package:sqflite/sqflite.dart';
import '../../../auth/data/services/database_service.dart';
import '../models/product_model.dart';

class ProductDatabaseService {
  static const String _tableName = 'products';

  Future<void> _ensureProductsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category TEXT,
        seller_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<Database> get database async => DatabaseService.database;

  Future<int> createProduct(ProductModel product) async {
    final db = await database;
    await _ensureProductsTable(db);
    return await db.insert(_tableName, product.toMap());
  }

  Future<List<ProductModel>> getProductsBySellerId(int sellerId) async {
    final db = await database;
    await _ensureProductsTable(db);
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'seller_id = ?',
      whereArgs: [sellerId],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  Future<ProductModel?> getProductById(int id) async {
    final db = await database;
    await _ensureProductsTable(db);
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ProductModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateProduct(ProductModel product) async {
    final db = await database;
    await _ensureProductsTable(db);
    return await db.update(
      _tableName,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    await _ensureProductsTable(db);
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ProductModel>> getAllProducts() async {
    final db = await database;
    await _ensureProductsTable(db);
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }
}
