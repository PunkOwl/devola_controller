import 'dart:convert';

class DevolaSettingsEntity {
  DevolaSettingsEntity({
    this.id,
    this.appVersion,
    this.devolaAddr,
    this.devolaAddrPort
  });

  int id;
  String appVersion;
  String devolaAddr;
  int devolaAddrPort;

  factory DevolaSettingsEntity.fromJson(String str) => DevolaSettingsEntity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DevolaSettingsEntity.fromMap(Map<String, dynamic> json) => DevolaSettingsEntity(
    id: json["id"] == null ? null : json["id"],
    appVersion: json["app_version"] == null ? null : json["app_version"],
    devolaAddr: json["devola_addr"] == null ? null : json["devola_addr"],
    devolaAddrPort: json["devola_addr_port"] == null ? null : json["devola_addr_port"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "app_version": appVersion == null ? null : appVersion,
    "devola_addr": devolaAddr == null ? null : devolaAddr,
    "devola_addr_port": devolaAddrPort == null ? null : devolaAddrPort,
  };
}
