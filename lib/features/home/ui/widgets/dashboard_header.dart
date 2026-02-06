import 'package:flutter/material.dart';

import '../../../../../core/ui/theme/colors.dart';
import '../../../../../core/ui/widgets/app_text.dart';

import '../../../auth/data/models/user_model.dart';

class DashboardHeader extends StatelessWidget implements PreferredSizeWidget {
  final UserModel user;
  final VoidCallback? onLogout;

  const DashboardHeader({
    super.key,
    required this.user,
    this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppText(
        user.isAdminUser ? 'Admin Dashboard' : 'Seller Dashboard',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.chineseBlue,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: onLogout ?? () {
            // Default logout behavior
          },
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ],
    );
  }
}
