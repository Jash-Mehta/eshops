// coverage:ignore-file
import 'package:eshops/features/auth/data/repositories/auth_repository.dart';
import 'package:eshops/features/auth/ui/bloc/auth_bloc.dart';
import 'package:eshops/features/home/ui/bloc/home_bloc/home_bloc.dart';
import 'package:eshops/features/home/ui/bloc/product_bloc/product_bloc.dart';
import 'package:eshops/features/home/data/repositories/product_repository.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

initServices() {
  // Register DioClient
  

  // Register AuthRepository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(),
  );

  // Register ProductRepository
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(),
  );

  // Register AuthBloc
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  // Register HomeBloc
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(authRepository: getIt<AuthRepository>()),
  );

  // Register ProductBloc
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(productRepository: getIt<ProductRepository>()),
  );
 
}


