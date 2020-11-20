import 'package:devola_controller/data/db_provider.dart';
import 'package:devola_controller/model/entity/devola_settings_entity.dart';

class SettingsRepository {

  Future<bool> updateSettings(DevolaSettingsEntity entity) async {
    await DBProvider.db.updateSettings(entity);
    return true;
  }

  Future<DevolaSettingsEntity> getSettings() {
    return DBProvider.db.getSettings();
  }

}