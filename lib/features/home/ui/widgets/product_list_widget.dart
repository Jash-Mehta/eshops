import 'package:eshops/features/home/ui/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ui/widgets/app_text.dart';
import '../../../../core/utils/assets/assets.dart';
import '../bloc/product_bloc/product_bloc.dart';
import '../screens/add_edit_product_screen.dart';

class ProductListWidget extends StatefulWidget {
  final int sellerId;

  const ProductListWidget({
    super.key,
    required this.sellerId,
  });

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts(widget.sellerId));
  }

  @override
  void didUpdateWidget(covariant ProductListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sellerId != widget.sellerId) {
      context.read<ProductBloc>().add(LoadProducts(widget.sellerId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProductListView(sellerId: widget.sellerId);
  }
}

class ProductListView extends StatelessWidget {
  final int sellerId;

  const ProductListView({
    super.key,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProductsLoaded) {
          if (state.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.noData,
                    height: 120,
                  ),
                  SizedBox(height: 20),
                  AppText(
                    'No Products Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  AppText(
                    'Click the + button to create your first product',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  
                  
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductCard(product: product);
            },
          );
        } else if (state is ProductError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.somethingWentWrong,
                  height: 120,
                ),
                const SizedBox(height: 20),
                AppText(
                  'Error Loading Products',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                AppText(
                  state.message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProductBloc>().add(LoadProducts(sellerId));
                  },
                  child: const AppText('Retry'),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: AppText('Loading products...'),
        );
      },
    );
  }
}
