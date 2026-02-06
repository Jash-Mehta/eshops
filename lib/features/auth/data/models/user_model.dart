import 'package:equatable/equatable.dart';
import 'package:eshops/core/utils/methods/map.dart';

class UserModel extends Equatable {
  final int? id;
  final String uuid;
  final String username;
  final String email;
  final String password;
  final int isAdmin; // 1 for admin, 0 for seller
  final int? createdByAdminId;
  final int isDeactivated;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.uuid,
    required this.username,
    required this.email,
    required this.password,
    required this.isAdmin,
    this.createdByAdminId,
    this.isDeactivated = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'username': username,
      'email': email,
      'password': password,
      'is_admin': isAdmin,
      'created_by_admin_id': createdByAdminId,
      'is_deactivated': isDeactivated,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map.getInt('id'),
      uuid: map.getString('uuid'),
      username: map.getString('username'),
      email: map.getString('email'),
      password: map.getString('password'),
      isAdmin: map.getInt('is_admin'),
      createdByAdminId: map.getInt('created_by_admin_id'),
      isDeactivated: map.getInt('is_deactivated'),
      createdAt: map.getDateTime('created_at') ?? DateTime.now(),
    );
  }

  bool get isAdminUser => isAdmin == 1;
  bool get isSeller => isAdmin == 0;
  bool get isActive => isDeactivated == 0;

  @override
  
  List<Object?> get props => [
    id,
    uuid,
    username,
    email,
    password,
    isAdmin,
    createdByAdminId,
    isDeactivated,
    createdAt,
  ];
}
