import 'package:equatable/equatable.dart';
import '../../../../core/utils/methods/constants.dart';
import '../../../../core/utils/methods/map.dart';

class ProductModel extends Equatable{
  final int? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int sellerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.sellerId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      ApiConstants.id: id,
      ApiConstants.name: name,
      ApiConstants.description: description,
      ApiConstants.price: price,
      ApiConstants.category: category,
      ApiConstants.sellerId: sellerId,
      ApiConstants.createdAt: createdAt.toIso8601String(),
      ApiConstants.updatedAt: updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map.getInt(ApiConstants.id),
      name: map.getString(ApiConstants.name),
      description: map.getString(ApiConstants.description),
      price: map.getDouble(ApiConstants.price),
      category: map.getString(ApiConstants.category),
      sellerId: map.getInt(ApiConstants.sellerId),
      createdAt: map.getDateTime(ApiConstants.createdAt) ?? DateTime.now(),
      updatedAt: map.getDateTime(ApiConstants.updatedAt) ?? DateTime.now(),
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? category,
    int? sellerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      sellerId: sellerId ?? this.sellerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    category,
    sellerId,
    createdAt,
    updatedAt
  ];
}
