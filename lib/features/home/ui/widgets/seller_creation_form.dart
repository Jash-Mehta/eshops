import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_input_field.dart';
import '../../../auth/ui/bloc/auth_bloc.dart' as auth;
import '../bloc/home_bloc/home_bloc.dart';

class SellerCreationForm extends StatefulWidget {
  const SellerCreationForm({super.key});

  @override
  State<SellerCreationForm> createState() => _SellerCreationFormState();
}

class _SellerCreationFormState extends State<SellerCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _createSeller() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<auth.AuthBloc>().state;
      if (authState is! auth.AuthAuthenticated) {
        return;
      }

      final adminId = authState.user.id;
      if (adminId == null) {
        return;
      }

      context.read<HomeBloc>().add(
            CreateSellerRequested(
              username: usernameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text,
              createdByAdminId: adminId,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Create Seller Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          'Create login credentials for sellers',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Form(
          key: _formKey,
          child: Column(
            children: [
              AppInputField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                labelText: 'Username',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter username';
                  }
                  if (value.trim().length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value.trim())) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputField(
                controller: passwordController,
                focusNode: _passwordFocusNode,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                labelText: 'Password',
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputField(
                controller: confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                labelText: 'Confirm Password',
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onFieldSubmit: (_) => _createSeller(),
              ),
              const SizedBox(height: 30),
              CommonButton(
                title: _isLoading ? 'Creating Seller...' : 'Create Seller Account',
                onPressed: _isLoading ? null : _createSeller,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
