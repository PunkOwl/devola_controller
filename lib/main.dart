import 'dart:async';

import 'package:devola_controller/app_types.dart';
import 'package:devola_controller/data/settings_bloc.dart';
import 'package:devola_controller/data/settings_repository.dart';
import 'package:devola_controller/screens/home/home_screen.dart';
import 'package:devola_controller/screens/settings/settings_screen.dart';
import 'package:devola_controller/theme/devola_style.dart';
import 'package:devola_controller/util/exception_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class DevolaBlocObserver extends BlocObserver {
  Logger logger = Logger();

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    logger.v(event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.v(transition);
  }

  @override
  void onError(Cubit bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    logger.e(error, stacktrace);
  }
}

void main() {
  Bloc.observer = DevolaBlocObserver();
  ExceptionManager.xMan.debugMode = true;

  final SettingsRepository settingsRepository = SettingsRepository();
  final SettingsBloc settingsBloc = SettingsBloc(settingsRepository: settingsRepository);

  Widget devolaControllerApp = MultiBlocProvider(
    providers: [
      BlocProvider<SettingsBloc>(create: (context) => settingsBloc,)
    ],
    child: DevolaControllerApp(),
  );

  runZonedGuarded(
    () => runApp(devolaControllerApp),
    (error, stacktrace) async {
      ExceptionManager.xMan.captureException(error, stacktrace);
    }
  );
}

class DevolaControllerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    Widget homeScreen = HomeScreen(
      settingsBloc: settingsBloc,
    );

    return MaterialApp(
      theme: devolaTheme(),
      initialRoute: AppTypes.SCREEN_HOME,
      home: homeScreen,
      routes: {
        AppTypes.SCREEN_HOME: (context) => homeScreen,
        AppTypes.SCREEN_SETTINGS: (context) => SettingsScreen(
          settingsBloc: settingsBloc,
        ),
      },
    );
  }
}

