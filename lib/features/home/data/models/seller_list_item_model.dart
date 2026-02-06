import 'package:equatable/equatable.dart';

import '../../../auth/data/models/user_model.dart';

class SellerListItem extends Equatable {
  final int id;
  final String uuid;
  final String username;
  final String email;
  final int isDeactivated;
  final DateTime createdAt;

  const SellerListItem({
    required this.id,
    required this.uuid,
    required this.username,
    required this.email,
    required this.isDeactivated,
    required this.createdAt,
  });

  bool get isActive => isDeactivated == 0;

  factory SellerListItem.fromUser(UserModel user) {
    return SellerListItem(
      id: user.id ?? 0,
      uuid: user.uuid,
      username: user.username,
      email: user.email,
      isDeactivated: user.isDeactivated,
      createdAt: user.createdAt,
    );
  }

  @override
  List<Object> get props => [
    id,
    uuid,
    username,
    email,
    isDeactivated,
    createdAt,
  ];
}
