import 'package:sqflite/sqflite.dart';

import '../../../auth/data/services/database_service.dart';
import '../models/seller_profile_model.dart';

class SellerProfileDatabaseService {
  static const String _tableName = 'seller_profiles';

  Future<Database> get database async => DatabaseService.database;

  Future<void> _ensureTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        seller_id INTEGER PRIMARY KEY,
        shop_name TEXT NOT NULL,
        address TEXT NOT NULL,
        photo_path TEXT,
        is_profile_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<SellerProfileModel?> getProfileBySellerId(int sellerId) async {
    final db = await database;
    await _ensureTable(db);

    final maps = await db.query(
      _tableName,
      where: 'seller_id = ?',
      whereArgs: [sellerId],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return SellerProfileModel.fromMap(maps.first);
  }

  Future<bool> isProfileCompleted(int sellerId) async {
    final profile = await getProfileBySellerId(sellerId);
    return profile?.completed == true;
  }

  Future<void> upsertProfile(SellerProfileModel profile) async {
    final db = await database;
    await _ensureTable(db);

    await db.insert(
      _tableName,
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
