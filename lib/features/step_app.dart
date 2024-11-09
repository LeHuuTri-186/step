import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:step/core/themes/app_theme.dart';
import 'package:step/features/home/presentation/bloc/search/search_bloc.dart';
import 'package:step/features/home/presentation/home_screen.dart';
import '../lang/app_localizations_delegate.dart';
import 'home/di/home_di.dart';
import 'home/domain/usecases/crud_usecases.dart';
import 'home/presentation/bloc/all/all_bloc.dart';
import 'home/presentation/bloc/home_bloc.dart';
import 'home/presentation/bloc/flower_display_cubit.dart';
import 'home/presentation/bloc/today/todo_bloc.dart';
import 'home/presentation/bloc/upcoming/upcoming_bloc.dart';

class StepApp extends StatelessWidget {
  const StepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(
            create: (_) => TodoBloc(crudUseCases: getIt<CrudUseCases>())),
        BlocProvider(create: (_) => FlowerDisplayCubit()),
        BlocProvider(
            create: (_) => UpcomingBloc(crudUseCases: getIt<CrudUseCases>())),
        BlocProvider(
            create: (_) => SearchBloc(crudUseCases: getIt<CrudUseCases>())),
        BlocProvider(
            create: (_) => AllBloc(crudUseCases: getIt<CrudUseCases>())),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('vi', 'VN'), // Spanish
        ],
        title: "STEP",
        home: const HomeScreen(),
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(
          useMaterial3: true,
        ),
      ),
    );
  }
}
