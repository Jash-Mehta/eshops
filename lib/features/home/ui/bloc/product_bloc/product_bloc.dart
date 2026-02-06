import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<ClearProductForm>(_onClearProductForm);
    on<LoadProductDetails>(_onLoadProductDetails);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getSellerProducts(event.sellerId);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to load products: ${e.toString()}'));
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _productRepository.createProduct(
        name: event.name,
        description: event.description,
        price: event.price,
        category: event.category,
        sellerId: event.sellerId,
      );

      if (product != null) {
        emit(ProductOperationSuccess('Product created successfully!'));
        // Reload products after creation
        add(LoadProducts(event.sellerId));
      } else {
        emit(const ProductError('Failed to create product'));
      }
    } catch (e) {
      emit(ProductError('Failed to create product: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final success = await _productRepository.updateProduct(event.product);
      if (success) {
        emit(ProductOperationSuccess('Product updated successfully!'));
        
        add(LoadProducts(event.product.sellerId));
      } else {
        emit(const ProductError('Failed to update product'));
      }
    } catch (e) {
      emit(ProductError('Failed to update product: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      
      final product = await _productRepository.getProductById(event.productId);
      final success = await _productRepository.deleteProduct(event.productId);
      
      if (success) {
        emit(ProductOperationSuccess('Product deleted successfully!'));
        
        if (product != null) {
          add(LoadProducts(product.sellerId));
        }
      } else {
        emit(const ProductError('Failed to delete product'));
      }
    } catch (e) {
      emit(ProductError('Failed to delete product: ${e.toString()}'));
    }
  }

  Future<void> _onClearProductForm(
    ClearProductForm event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductInitial());
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductState> emit,
  ) async {
    
    try {
      final product = await _productRepository.getProductById(event.productId);
      if (product != null) {
        emit(ProductDetailsLoaded(product));
      } else {
        emit(const ProductError('Product not found'));
      }
    } catch (e) {
      emit(ProductError('Failed to load product details: ${e.toString()}'));
    }
  }
}
