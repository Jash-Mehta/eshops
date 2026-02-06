import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/widgets/app_text.dart';
import '../../../auth/ui/bloc/auth_bloc.dart';
import '../bloc/product_bloc/product_bloc.dart';
import '../widgets/product_list_widget.dart';
import '../screens/add_edit_product_screen.dart';

class SellerDashboardContent extends StatelessWidget {
  const SellerDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          final sellerId = authState.user.id!;
          
          return Scaffold(
            
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const AppText(
                    'My Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    'Manage your product inventory',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                 SizedBox(height: 20),
                  ProductListWidget(sellerId: sellerId),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditProductScreen(
                      sellerId: sellerId,
                    ),
                  ),
                );

                if (context.mounted) {
                  context.read<ProductBloc>().add(LoadProducts(sellerId));
                }
              },
              backgroundColor: AppColors.chineseBlue,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        }
        
        return const Center(
          child: AppText('Loading seller data...'),
        );
      },
    );
  }
}
