import 'package:logger/logger.dart';
import 'package:sentry/sentry.dart';

class ExceptionManager {

  ExceptionManager._();

  static final ExceptionManager xMan = ExceptionManager._();

  bool print2Logger = false;
  bool capture2Sentry = false;

  final SentryClient sentry = SentryClient(dsn: "NONE");
  final Logger logger = Logger();

  set debugMode(bool mode) {
    capture2Sentry = false;
    print2Logger = mode;
  }

  set releaseMode(bool mode) {
    print2Logger = false;
    capture2Sentry = mode;
  }

  set testMode(bool mode) {
    print2Logger = mode;
    capture2Sentry = mode;
  }

  captureException(dynamic ex, StackTrace stackTrace) {
    if(!print2Logger && !capture2Sentry) {
      logger.w('Logger and Sentry both disabled!');
    } else {
      if(print2Logger) logger.e(ex.toString(), ex, stackTrace);
      if(capture2Sentry) sentry.captureException(
        exception: ex,
        stackTrace: stackTrace,
      );
    }
  }

}