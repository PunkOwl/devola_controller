import 'dart:async';

import 'package:devola_controller/app_types.dart';
import 'package:devola_controller/screens/home/home_screen.dart';
import 'package:devola_controller/screens/loading/loading_screen.dart';
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

  Widget devolaControllerApp = DevolaControllerApp();

  runZonedGuarded(
      () => runApp(devolaControllerApp),
      (error, stacktrace) async {
        ExceptionManager.xMan.captureException(error, stacktrace);
      }
  );
}

class DevolaControllerApp extends StatelessWidget {

  Future<bool> initializeApp() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeApp(),
      builder: (context, snapshot) {
        if(snapshot.data) {
          return MaterialApp(
            theme: devolaTheme(),
            initialRoute: AppTypes.SCREEN_HOME,
            home: HomeScreen(),
            routes: {
              AppTypes.SCREEN_HOME: (context) => HomeScreen(),
              AppTypes.SCREEN_SETTINGS: (context) => SettingsScreen(),
            },
          );
        }
        return MaterialApp(
          home: LoadingScreen(),
        );
      },
    );
  }
}
