// coverage:ignore-file

import 'package:eshops/features/home/ui/bloc/home_bloc/home_bloc.dart';
import 'package:eshops/features/home/ui/bloc/product_bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eshops/core/di/service_locator.dart';
import 'package:eshops/features/auth/ui/bloc/auth_bloc.dart';

class BlocProviderWrapper extends StatelessWidget {
  const BlocProviderWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<HomeBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProductBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return child;
        },
      ),
    );
  }
}
