import 'package:eshops/core/router/app_router.dart';
import 'package:eshops/core/ui/theme/colors.dart';
import 'package:eshops/core/ui/widgets/app_button.dart';
import 'package:eshops/core/ui/widgets/app_input_field.dart';
import 'package:eshops/core/ui/widgets/app_text.dart';
import 'package:eshops/core/utils/validators.dart';
import 'package:eshops/features/auth/ui/bloc/auth_bloc.dart';
import 'package:eshops/features/home/data/models/seller_profile_model.dart';
import 'package:eshops/features/home/data/services/seller_profile_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SellerProfileSetupScreen extends StatefulWidget {
  const SellerProfileSetupScreen({super.key});

  @override
  State<SellerProfileSetupScreen> createState() =>
      _SellerProfileSetupScreenState();
}

class _SellerProfileSetupScreenState extends State<SellerProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _shopNameController = TextEditingController();
  final _addressController = TextEditingController();

  final _sellerProfileDb = SellerProfileDatabaseService();

  bool _saving = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      context.go(AppRouter.login);
      return;
    }

    final user = authState.user;
    if (user.isAdminUser) {
      context.go(AppRouter.adminDashboard);
      return;
    }

    final sellerId = user.id;
    if (sellerId == null) {
      context.go(AppRouter.login);
      return;
    }

    setState(() {
      _saving = true;
    });

    final now = DateTime.now();
    final profile = SellerProfileModel(
      sellerId: sellerId,
      shopName: _shopNameController.text.trim(),
      address: _addressController.text.trim(),
      photoPath: null,
      isCompleted: 1,
      createdAt: now,
      updatedAt: now,
    );

    await _sellerProfileDb.upsertProfile(profile);

    if (!mounted) {
      return;
    }

    setState(() {
      _saving = false;
    });

    context.go(AppRouter.sellerDashboard);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const AppText(
            'Setup Your Shop',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.chineseBlue,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.chineseBlue,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.store,
                          size: 40,
                          color: AppColors.chineseBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const AppText(
                        'Profile photo (placeholder)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AppInputField(
                  controller: _shopNameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  labelText: 'Shop Name',
                  focusedBorderColor: AppColors.chineseBlue,
                  validator: (value) => Validators.validateRequired(value, 'shop name'),
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: _addressController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  labelText: 'Address',
                  focusedBorderColor: AppColors.chineseBlue,
                  validator: (value) => Validators.validateRequired(value, 'address'),
                  onFieldSubmit: (_) => _save(),
                ),
                const SizedBox(height: 30),
                CommonButton(
                  title: _saving ? 'Saving...' : 'Continue',
                  backgroundColor: AppColors.chineseBlue,
                  onPressed: _saving ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
