// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bayan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bayan _$BayanFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['link', 'name', 'id', 'playlistId'],
    disallowNullValues: const ['link', 'name', 'id', 'playlistId'],
  );
  return Bayan(
    json['id'] as String,
    json['link'] as String,
    json['name'] as String?,
    json['description'] as String? ?? '',
    json['playlistId'] as String,
  )..filePath = json['filePath'] as String?;
}

Map<String, dynamic> _$BayanToJson(Bayan instance) {
  final val = <String, dynamic>{
    'link': instance.link,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  val['id'] = instance.id;
  val['playlistId'] = instance.playlistId;
  val['description'] = instance.description;
  val['filePath'] = instance.filePath;
  return val;
}
