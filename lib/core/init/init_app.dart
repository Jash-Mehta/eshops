import 'package:bloc/bloc.dart';
import 'package:eshops/core/bloc_observer/app_bloc_observer.dart';
import 'package:eshops/core/di/service_locator.dart';
import 'package:eshops/core/ui/theme/colors.dart';
import 'package:eshops/core/ui/widgets/app_loader_animated.dart';
import 'package:eshops/core/ui/widgets/error_widget.dart';
import 'package:eshops/core/utils/assets/assets.dart';
import 'package:eshops/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:talker_flutter/talker_flutter.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  final talker = TalkerFlutter.init();


  Future(() => initServices());

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  EasyLoading.instance
    ..indicatorWidget = appLoaderAnimated()
    ..indicatorSize = 80.0
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..textColor = AppColors.white
    ..loadingStyle = EasyLoadingStyle.custom
    ..boxShadow = <BoxShadow>[]
    ..radius = 8.0;

  FlutterError.onError = (FlutterErrorDetails details) {
    talker.handle(details.exception, details.stack);
  };

  Bloc.observer = AppBlocObserver(talker);

  ErrorWidget.builder = (errorDetails) {
    return AppErrorWidget(
      topSpacing: 100,
      errorTitle: "Oops! Something went wrong",
      errorMessage: 'An unexpected error occurred. Please try again later.',
      stack: errorDetails.stack.toString(),
      assetsImage: Assets.somethingWentWrong,
      buttonText: 'Reload App',
      onTap: () {},
    );
  };

  runApp(const MyApp());
}
