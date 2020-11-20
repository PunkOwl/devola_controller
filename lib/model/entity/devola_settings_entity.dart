import 'dart:convert';

class DevolaSettingsEntity {
  DevolaSettingsEntity({
    this.id,
    this.appVersion,
    this.devolaAddr,
  });

  int id;
  String appVersion;
  String devolaAddr;

  factory DevolaSettingsEntity.fromJson(String str) => DevolaSettingsEntity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DevolaSettingsEntity.fromMap(Map<String, dynamic> json) => DevolaSettingsEntity(
    id: json["id"] == null ? null : json["id"],
    appVersion: json["app_version"] == null ? null : json["app_version"],
    devolaAddr: json["devola_addr"] == null ? null : json["devola_addr"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "app_version": appVersion == null ? null : appVersion,
    "devola_addr": devolaAddr == null ? null : devolaAddr,
  };
}
