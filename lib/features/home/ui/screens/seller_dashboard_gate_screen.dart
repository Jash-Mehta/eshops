import 'package:eshops/core/router/app_router.dart';
import 'package:eshops/features/auth/ui/bloc/auth_bloc.dart';
import 'package:eshops/features/home/data/services/seller_profile_database_service.dart';
import 'package:eshops/features/home/ui/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SellerDashboardGateScreen extends StatefulWidget {
  const SellerDashboardGateScreen({super.key});

  @override
  State<SellerDashboardGateScreen> createState() =>
      _SellerDashboardGateScreenState();
}

class _SellerDashboardGateScreenState extends State<SellerDashboardGateScreen> {
  final _sellerProfileDb = SellerProfileDatabaseService();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkProfile();
    });
  }

  Future<void> _checkProfile() async {
    final state = context.read<AuthBloc>().state;
    if (state is! AuthAuthenticated) {
      if (mounted) {
        context.go(AppRouter.login);
      }
      return;
    }

    final user = state.user;
    if (user.isAdminUser) {
      if (mounted) {
        context.go(AppRouter.adminDashboard);
      }
      return;
    }

    final sellerId = user.id;
    if (sellerId == null) {
      if (mounted) {
        context.go(AppRouter.login);
      }
      return;
    }

    final completed = await _sellerProfileDb.isProfileCompleted(sellerId);

    if (!mounted) {
      return;
    }

    if (!completed) {
      context.go(AppRouter.sellerProfileSetup);
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return const DashboardScreen();
  }
}
