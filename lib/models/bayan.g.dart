// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bayan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bayan _$BayanFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['title', 'id', 'playlistId'],
      disallowNullValues: const ['title', 'id', 'playlistId']);
  return Bayan(
    json['id'] as String,
    json['url'] as String,
    json['title'] as String,
    json['description'] as String ?? '',
    json['playlistId'] as String,
  );
}

Map<String, dynamic> _$BayanToJson(Bayan instance) => <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'id': instance.id,
      'playlistId': instance.playlistId,
      'description': instance.description,
    };
