import 'package:equatable/equatable.dart';

import '../../../../core/utils/methods/constants.dart';
import '../../../../core/utils/methods/map.dart';

class SellerProfileModel extends Equatable {
  final int sellerId;
  final String shopName;
  final String address;
  final String? photoPath;
  final int isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SellerProfileModel({
    required this.sellerId,
    required this.shopName,
    required this.address,
    this.photoPath,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      ApiConstants.sellerId: sellerId,
      ApiConstants.shopName: shopName,
      ApiConstants.address: address,
      ApiConstants.photoPath: photoPath,
      ApiConstants.isProfileCompleted: isCompleted,
      ApiConstants.createdAt: createdAt.toIso8601String(),
      ApiConstants.updatedAt: updatedAt.toIso8601String(),
    };
  }

  factory SellerProfileModel.fromMap(Map<String, dynamic> map) {
    return SellerProfileModel(
      sellerId: map.getInt(ApiConstants.sellerId),
      shopName: map.getString(ApiConstants.shopName),
      address: map.getString(ApiConstants.address),
      photoPath: map.getString(ApiConstants.photoPath),
      isCompleted: map.getInt(ApiConstants.isProfileCompleted),
      createdAt: map.getDateTime(ApiConstants.createdAt) ?? DateTime.now(),
      updatedAt: map.getDateTime(ApiConstants.updatedAt) ?? DateTime.now(),
    );
  }

  bool get completed => isCompleted == 1;

  SellerProfileModel copyWith({
    int? sellerId,
    String? shopName,
    String? address,
    String? photoPath,
    int? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SellerProfileModel(
      sellerId: sellerId ?? this.sellerId,
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      photoPath: photoPath ?? this.photoPath,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    sellerId,
    shopName,
    address,
    photoPath,
    isCompleted,
    createdAt,
    updatedAt,
  ];
}
