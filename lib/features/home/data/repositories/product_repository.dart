import '../models/product_model.dart';
import '../services/product_database_service.dart';

class ProductRepository {
  final ProductDatabaseService _databaseService;

  ProductRepository() : _databaseService = ProductDatabaseService();

  Future<ProductModel?> createProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required int sellerId,
  }) async {
    try {
      final product = ProductModel(
        name: name,
        description: description,
        price: price,
        category: category,
        sellerId: sellerId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final id = await _databaseService.createProduct(product);
      return product.copyWith(id: id);
    } catch (e) {
      throw Exception('Failed to create product: ${e.toString()}');
    }
  }

  Future<List<ProductModel>> getSellerProducts(int sellerId) async {
    try {
      return await _databaseService.getProductsBySellerId(sellerId);
    } catch (e) {
      throw Exception('Failed to get seller products: ${e.toString()}');
    }
  }

  Future<ProductModel?> getProductById(int id) async {
    try {
      return await _databaseService.getProductById(id);
    } catch (e) {
      throw Exception('Failed to get product: ${e.toString()}');
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    try {
      final updatedProduct = product.copyWith(
        updatedAt: DateTime.now(),
      );
      final rowsAffected = await _databaseService.updateProduct(updatedProduct);
      return rowsAffected > 0;
    } catch (e) {
      throw Exception('Failed to update product: ${e.toString()}');
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final rowsAffected = await _databaseService.deleteProduct(id);
      return rowsAffected > 0;
    } catch (e) {
      throw Exception('Failed to delete product: ${e.toString()}');
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      return await _databaseService.getAllProducts();
    } catch (e) {
      throw Exception('Failed to get all products: ${e.toString()}');
    }
  }
}
