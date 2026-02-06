import 'package:equatable/equatable.dart';
import 'package:eshops/core/utils/methods/constants.dart';
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
      ApiConstants.id: id,
      ApiConstants.uuid: uuid,
      ApiConstants.username: username,
      ApiConstants.email: email,
      ApiConstants.password: password,
      ApiConstants.isAdmin: isAdmin,
      ApiConstants.createdByAdminId: createdByAdminId,
      ApiConstants.isDeactivated: isDeactivated,
  ApiConstants.createdAt: createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map.getInt(ApiConstants.id),
      uuid: map.getString(ApiConstants.uuid),
      username: map.getString(ApiConstants.username),
      email: map.getString(ApiConstants.email),
      password: map.getString(ApiConstants.password),
      isAdmin: map.getInt(ApiConstants.isAdmin),
      createdByAdminId: map.getInt(ApiConstants.createdByAdminId),
      isDeactivated: map.getInt(ApiConstants.isDeactivated),
      createdAt: map.getDateTime(ApiConstants.createdAt) ?? DateTime.now(),
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
