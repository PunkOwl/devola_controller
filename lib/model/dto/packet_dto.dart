// To parse this JSON data, do
//
//     final packetDto = packetDtoFromJson(jsonString);

import 'dart:convert';

class PacketDto {
  PacketDto({
    this.scaleFactor,
    this.isCameraOn,
    this.extra,
  });

  double scaleFactor;
  bool isCameraOn;
  String extra;

  factory PacketDto.fromRawJson(String str) => PacketDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PacketDto.fromJson(Map<String, dynamic> json) => PacketDto(
    scaleFactor: json["scaleFactor"] == null ? null : json["scaleFactor"].toDouble(),
    isCameraOn: json["isCameraOn"] == null ? null : json["isCameraOn"],
    extra: json["extra"] == null ? null : json["extra"],
  );

  Map<String, dynamic> toJson() => {
    "scaleFactor": scaleFactor == null ? null : scaleFactor,
    "isCameraOn": isCameraOn == null ? null : isCameraOn,
    "extra": extra == null ? null : extra,
  };
}
