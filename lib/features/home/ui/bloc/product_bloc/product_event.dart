part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final int sellerId;

  const LoadProducts(this.sellerId);

  @override
  List<Object> get props => [sellerId];
}

class CreateProduct extends ProductEvent {
  final String name;
  final String description;
  final double price;
  final String category;
  final int sellerId;

  const CreateProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.sellerId,
  });

  @override
  List<Object> get props => [
        name,
        description,
        price,
        category,
        sellerId,
      ];
}

class UpdateProduct extends ProductEvent {
  final ProductModel product;

  const UpdateProduct(this.product);

  @override
  List<Object> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final int productId;

  const DeleteProduct(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearProductForm extends ProductEvent {}

class LoadProductDetails extends ProductEvent {
  final int productId;

  const LoadProductDetails(this.productId);

  @override
  List<Object> get props => [productId];
}
