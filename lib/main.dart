import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_template/core/bloc/app_bloc_observer.dart';
import 'package:flutter_template/core/config/app_config.dart';
import 'package:flutter_template/core/di/injection.dart';
import 'package:flutter_template/core/navigation/app_router.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_template/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc_state.dart';
import 'package:flutter_template/shared/presentation/cubit/theme_cubit.dart';
import 'package:flutter_template/shared/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  await AppConfig.initialize(
    logger: AppLogger(),
  );

  // Initialize dependency injection
  await configureDependencies();

  // Set global BLoC observer
  Bloc.observer = getIt<AppBlocObserver>();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global BLoCs
        BlocProvider<AuthBloc>(
          create: (_) =>
              getIt<AuthBloc>()..add(const CheckAuthStatus(silent: true)),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => getIt<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, BaseBlocState<AppThemeData>>(
        builder: (context, themeState) {
          final themeData = themeState.data;
          final isDark = themeData?.isDark ?? false;

          return MaterialApp.router(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: AppConfig.isDebugModeEnabled,

            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

            // Router configuration
            routerConfig: getIt<AppRouter>().createRouter(context),
          );
        },
      ),
    );
  }
}
