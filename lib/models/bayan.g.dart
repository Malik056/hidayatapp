// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bayan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bayan _$BayanFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['name', 'id', 'playlistId'],
      disallowNullValues: const ['name', 'id', 'playlistId']);
  return Bayan(
    json['id'] as String,
    json['link'] as String,
    json['name'] as String,
    json['description'] as String ?? '',
    json['playlistId'] as String,
  )..filePath = json['filePath'] as String;
}

Map<String, dynamic> _$BayanToJson(Bayan instance) => <String, dynamic>{
      'link': instance.link,
      'name': instance.name,
      'id': instance.id,
      'playlistId': instance.playlistId,
      'description': instance.description,
      'filePath': instance.filePath,
    };
