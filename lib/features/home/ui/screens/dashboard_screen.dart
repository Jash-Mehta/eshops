import 'package:eshops/features/home/ui/widgets/dashboard_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/ui/bloc/auth_bloc.dart';
import '../bloc/home_bloc/home_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/theme/colors.dart';
import '../widgets/admin_dashboard_content.dart';
import '../widgets/seller_dashboard_content.dart';
import '../widgets/seller_creation_form.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          return Scaffold(
            appBar: DashboardHeader(
              user: user,
              onLogout: () {
                context.read<AuthBloc>().add(LogoutRequested());
                context.go('/login');
              },
            ),
            body: user.isAdminUser
                ? const AdminDashboardContent()
                : const SellerDashboardContent(),
            floatingActionButton: user.isAdminUser
                ? FloatingActionButton(
                    backgroundColor: AppColors.chineseBlue,
                    child: const Icon(Icons.add, color: Colors.white),
                    onPressed: () async {
                      final adminId = user.id;
                      if (adminId == null) {
                        return;
                      }
    
                      await showModalBottomSheet<void>(
                        backgroundColor: Colors.white,
                        context: context,
                        isScrollControlled: true,
                        builder: (sheetContext) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              top: 16,
                              
                            ),
                            child: const SingleChildScrollView(
                              child: SellerCreationForm(),
                            ),
                          );
                        },
                      );
    
                      if (context.mounted) {
                        context.read<HomeBloc>().add(LoadSellersList(adminId));
                      }
                    },
                  )
                : null,
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
