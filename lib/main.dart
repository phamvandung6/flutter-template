import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/bloc/app_bloc_observer.dart';
import 'core/di/injection.dart';
import 'core/navigation/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'shared/presentation/bloc/base_bloc_state.dart';
import 'shared/presentation/cubit/theme_cubit.dart';
import 'shared/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
            title: 'Flutter Template',
            debugShowCheckedModeBanner: false,

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
