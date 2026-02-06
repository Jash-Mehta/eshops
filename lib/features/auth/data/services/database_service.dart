import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'users';
  static const String _productsTableName = 'products';
  static const String _sellerProfilesTableName = 'seller_profiles';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'eshops.db');

    return await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uuid TEXT NOT NULL,
            username TEXT NOT NULL UNIQUE,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            is_admin INTEGER NOT NULL DEFAULT 0,
            created_by_admin_id INTEGER,
            is_deactivated INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute(
          'CREATE UNIQUE INDEX IF NOT EXISTS idx_users_uuid ON $_tableName(uuid)',
        );

        await db.execute('''
          CREATE TABLE IF NOT EXISTS $_productsTableName(
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

        await db.execute('''
          CREATE TABLE IF NOT EXISTS $_sellerProfilesTableName (
            seller_id INTEGER PRIMARY KEY,
            shop_name TEXT NOT NULL,
            address TEXT NOT NULL,
            photo_path TEXT,
            is_profile_completed INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $_productsTableName(
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

        if (oldVersion < 3) {
          try {
            await db.execute('ALTER TABLE $_tableName ADD COLUMN uuid TEXT');
          } catch (_) {}
          try {
            await db.execute(
              'ALTER TABLE $_tableName ADD COLUMN created_by_admin_id INTEGER',
            );
          } catch (_) {}

          await db.execute(
            'UPDATE $_tableName SET uuid = lower(hex(randomblob(16))) WHERE uuid IS NULL OR uuid = ""',
          );

          await db.execute(
            'CREATE UNIQUE INDEX IF NOT EXISTS idx_users_uuid ON $_tableName(uuid)',
          );
        }

        if (oldVersion < 4) {
          try {
            await db.execute(
              'ALTER TABLE $_tableName ADD COLUMN is_deactivated INTEGER NOT NULL DEFAULT 0',
            );
          } catch (_) {}
        }

        if (oldVersion < 5) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $_sellerProfilesTableName (
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
      },
    );
  }

  static Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(_tableName, user.toMap());
  }

  static Future<UserModel?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<UserModel?> authenticateUser(String username, String password) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'created_at DESC');
    
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  static Future<int> setUserDeactivated({
    required int userId,
    required int isDeactivated,
  }) async {
    final db = await database;
    return await db.update(
      _tableName,
      {'is_deactivated': isDeactivated},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  static Future<List<UserModel>> getSellersCreatedByAdminId(int adminId) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'is_admin = 0 AND created_by_admin_id = ?',
      whereArgs: [adminId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  static Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      _tableName,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
