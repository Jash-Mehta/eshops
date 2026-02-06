import '../models/user_model.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';

class AuthRepository {
  static const Uuid _uuid = Uuid();

  Future<UserModel?> login(String username, String password) async {
    try {
      return await DatabaseService.authenticateUser(username, password);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel?> loginByEmail(String email, String password) async {
    try {
      final user = await DatabaseService.getUserByEmail(email);
      if (user != null && user.password == password) {
        if (user.isSeller && !user.isActive) {
          throw Exception('Account is deactivated. Please contact admin.');
        }
        return user;
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel?> register({
    required String username,
    required String email,
    required String password,
    required int isAdmin,
    int? createdByAdminId,
  }) async {
    try {
      // Check if username already exists
      final existingUserByUsername = await DatabaseService.getUserByUsername(username);
      if (existingUserByUsername != null) {
        throw Exception('Username already exists');
      }

      // Check if email already exists
      final existingUserByEmail = await DatabaseService.getUserByEmail(email);
      if (existingUserByEmail != null) {
        throw Exception('Email already exists');
      }

      final user = UserModel(
        uuid: _uuid.v4(),
        username: username,
        email: email,
        password: password,
        isAdmin: isAdmin,
        createdByAdminId: createdByAdminId,
        createdAt: DateTime.now(),
      );

      final id = await DatabaseService.insertUser(user);
      return user.copyWith(id: id);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<UserModel?> getUserByUsername(String username) async {
    try {
      return await DatabaseService.getUserByUsername(username);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      return await DatabaseService.getAllUsers();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  Future<List<UserModel>> getSellersCreatedByAdminId(int adminId) async {
    try {
      return await DatabaseService.getSellersCreatedByAdminId(adminId);
    } catch (e) {
      throw Exception('Failed to get sellers: $e');
    }
  }

  Future<void> setSellerDeactivated({
    required int sellerId,
    required bool isDeactivated,
  }) async {
    try {
      await DatabaseService.setUserDeactivated(
        userId: sellerId,
        isDeactivated: isDeactivated ? 1 : 0,
      );
    } catch (e) {
      throw Exception('Failed to update seller status: $e');
    }
  }
}

extension UserModelCopy on UserModel {
  UserModel copyWith({
    int? id,
    String? uuid,
    String? username,
    String? email,
    String? password,
    int? isAdmin,
    int? createdByAdminId,
    int? isDeactivated,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      isAdmin: isAdmin ?? this.isAdmin,
      createdByAdminId: createdByAdminId ?? this.createdByAdminId,
      isDeactivated: isDeactivated ?? this.isDeactivated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
