import 'package:devola_controller/data/settings_repository.dart';
import 'package:devola_controller/model/entity/devola_settings_entity.dart';
import 'package:devola_controller/util/exception_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ======================= SETTINGS EVENT ======================= //
abstract class SettingsEvent extends Equatable {}

class GetSettings extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class UpdateSettings extends SettingsEvent {
  final DevolaSettingsEntity entity;

  UpdateSettings(this.entity);

  @override
  List<Object> get props => [entity];
}

// ======================= SETTINGS STATE ======================= //
abstract class SettingsState extends Equatable {}

class SettingsEmpty extends SettingsState {
  @override
  List<Object> get props => [];
}

class GetSettingsLoading extends SettingsState {
  @override
  List<Object> get props => [];
}

class GetSettingsLoaded extends SettingsState {
  final DevolaSettingsEntity settings;

  GetSettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

class GetSettingsError extends SettingsState {
  final String error;

  GetSettingsError(this.error);

  @override
  List<Object> get props => [error];
}

class UpdateSettingsLoading extends SettingsState {
  @override
  List<Object> get props => [];
}

class UpdateSettingsLoaded extends SettingsState {
  @override
  List<Object> get props => [];
}

class UpdateSettingsError extends SettingsState {
  final String error;

  UpdateSettingsError(this.error);

  @override
  List<Object> get props => [error];
}

// ======================= SETTINGS BLOC ======================= //
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  final SettingsRepository settingsRepository;

  SettingsBloc({
    @required this.settingsRepository
  }) : assert(settingsRepository != null), super(SettingsEmpty());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if(event is GetSettings) {
      yield GetSettingsLoading();
      try {
        DevolaSettingsEntity entity = await settingsRepository.getSettings();
        yield GetSettingsLoaded(entity);
      } catch(ex, stacktrace) {
        ExceptionManager.xMan.captureException(ex, stacktrace);
        yield GetSettingsError(ex.toString());
      }
    } else if(event is UpdateSettings) {
      yield UpdateSettingsLoading();
      try {
        await settingsRepository.updateSettings(event.entity);
        yield UpdateSettingsLoaded();
      } catch(ex, stacktrace) {
        ExceptionManager.xMan.captureException(ex, stacktrace);
        yield UpdateSettingsError(ex.toString());
      }
    }
  }

}