import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../core/utils/methods/constants.dart';
import '../../../../core/utils/methods/map.dart';

class SellerListItem extends Equatable {
  final int? id;
  final String uuid;
  final String username;
  final String email;
  final int isDeactivated;
  final DateTime createdAt;

  const SellerListItem({
    this.id,
    required this.uuid,
    required this.username,
    required this.email,
    this.isDeactivated = 0,
    required this.createdAt,
  });

  bool get isActive => isDeactivated == 0;

  Map<String, dynamic> toMap() {
    return {
      ApiConstants.id: id,
      ApiConstants.uuid: uuid,
      ApiConstants.username: username,
      ApiConstants.email: email,
      ApiConstants.isDeactivated: isDeactivated,
      ApiConstants.createdAt: createdAt.toIso8601String(),
    };
  }

  factory SellerListItem.fromMap(Map<String, dynamic> map) {
    return SellerListItem(
      id: map.getInt(ApiConstants.id),
      uuid: map.getString(ApiConstants.uuid),
      username: map.getString(ApiConstants.username),
      email: map.getString(ApiConstants.email),
      isDeactivated: map.getInt(ApiConstants.isDeactivated),
      createdAt: map.getDateTime(ApiConstants.createdAt) ?? DateTime.now(),
    );
  }

  factory SellerListItem.fromUser(UserModel user) {
    return SellerListItem(
      id: user.id,
      uuid: user.uuid,
      username: user.username,
      email: user.email,
      isDeactivated: user.isDeactivated,
      createdAt: user.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    uuid,
    username,
    email,
    isDeactivated,
    createdAt,
  ];
}
