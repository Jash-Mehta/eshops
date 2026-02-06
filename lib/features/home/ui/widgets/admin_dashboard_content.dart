import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/assets/assets.dart';

import '../../../../../core/ui/widgets/app_text.dart';
import '../../../auth/ui/bloc/auth_bloc.dart' as auth;
import '../bloc/home_bloc/home_bloc.dart';

class AdminDashboardContent extends StatefulWidget {
  const AdminDashboardContent({super.key});

  @override
  State<AdminDashboardContent> createState() => _AdminDashboardContentState();
}

class _AdminDashboardContentState extends State<AdminDashboardContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<auth.AuthBloc>().state;
      if (authState is auth.AuthAuthenticated) {
        final adminId = authState.user.id;
        if (adminId != null) {
          context.read<HomeBloc>().add(LoadSellersList(adminId));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const AppText(
            'My Sellers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SellersLoaded) {
                if (state.sellers.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Image.asset(Assets.noData, height: 120),
                        const SizedBox(height: 12),
                        const AppText(
                          'No sellers created yet.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.sellers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final seller = state.sellers[index];
                    final sellerId = seller.id;
                    final isDeactivated = !seller.isActive;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: isDeactivated ? Colors.red : Colors.green,
                            width: 4,
                          ),
                        ),

                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                seller.username,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                seller.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              AppText(
                                isDeactivated ? 'Deactivated' : 'Active',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDeactivated
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: !isDeactivated,
                            onChanged: (value) {
                              final authState = context
                                  .read<auth.AuthBloc>()
                                  .state;
                              if (authState is auth.AuthAuthenticated) {
                                final adminId = authState.user.id;
                                if (adminId != null && sellerId != null && sellerId != 0) {
                                  context.read<HomeBloc>().add(
                                    ToggleSellerDeactivated(
                                      adminId: adminId,
                                      sellerId: sellerId,
                                      isDeactivated: !value,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              if (state is HomeError) {
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Image.asset(Assets.somethingWentWrong, height: 120),
                      const SizedBox(height: 12),
                      AppText(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
