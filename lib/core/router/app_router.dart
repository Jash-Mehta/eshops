import 'package:eshops/features/auth/ui/screens/login_screen.dart';
import 'package:eshops/features/auth/ui/screens/admin_register_screen.dart';
import 'package:eshops/features/home/ui/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  static const String login = '/login';
  static const String adminRegister = '/admin-register';
  static const String home = '/home';
  static const String newLoanApplication = '/new-loan-application';
  static const String adminDashboard = '/admin-dashboard';
  static const String sellerDashboard = '/seller-dashboard';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: adminRegister,
        name: 'adminRegister',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AdminRegisterScreen(),
        ),
      ),
      GoRoute(
        path: adminDashboard,
        name: 'adminDashboard',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: sellerDashboard,
        name: 'sellerDashboard',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),
      
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
