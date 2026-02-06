import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../core/ui/widgets/app_input_field.dart';
import '../../../../core/ui/widgets/app_text.dart';
import '../../data/models/product_model.dart';
import '../bloc/product_bloc/product_bloc.dart';

class AddEditProductScreen extends StatefulWidget {
  final int? productId;
  final int sellerId;

  const AddEditProductScreen({
    super.key,
    this.productId,
    required this.sellerId,
  });

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      // Load existing product for editing
      context.read<ProductBloc>().add(LoadProductDetails(widget.productId!));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (widget.productId != null) {
        // Update existing product
        context.read<ProductBloc>().add(
          UpdateProduct(
            ProductModel(
              id: widget.productId,
              name: nameController.text.trim(),
              description: descriptionController.text.trim(),
              price: double.parse(priceController.text),
              category: categoryController.text.trim(),
              sellerId: widget.sellerId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ),
        );
      } else {
        // Create new product
        context.read<ProductBloc>().add(
          CreateProduct(
            name: nameController.text.trim(),
            description: descriptionController.text.trim(),
            price: double.parse(priceController.text),
            category: categoryController.text.trim(),
            sellerId: widget.sellerId,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          context.read<ProductBloc>().add(LoadProducts(widget.sellerId));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.read<ProductBloc>().add(LoadProducts(widget.sellerId));
              context.pop();
            },
          ),
         
        title: AppText(
          widget.productId != null ? 'Edit Product' : 'Add Product',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.chineseBlue,
        foregroundColor: Colors.white,
        ),
        body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductLoading) {}

          if (state is ProductDetailsLoaded) {
            // Populate form with existing product data
            nameController.text = state.product.name;
            descriptionController.text = state.product.description;
            priceController.text = state.product.price.toString();
            categoryController.text = state.product.category;
          } else if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                AppInputField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  labelText: 'Product Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  labelText: 'Description',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  labelText: 'Price',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: categoryController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  labelText: 'Category',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter category';
                    }
                    return null;
                  },
                  onFieldSubmit: (_) => _saveProduct(),
                ),
                const SizedBox(height: 30),
                CommonButton(
                  title: _isLoading
                      ? (widget.productId != null
                            ? 'Updating...'
                            : 'Creating...')
                      : (widget.productId != null
                            ? 'Update Product'
                            : 'Create Product'),
                  backgroundColor: AppColors.chineseBlue,
                  onPressed: _isLoading ? null : _saveProduct,
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
