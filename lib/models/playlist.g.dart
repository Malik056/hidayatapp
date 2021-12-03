// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'categoryId', 'id'],
    disallowNullValues: const ['name', 'categoryId', 'id'],
  );
  return Playlist(
    json['id'] as String,
    json['name'] as String?,
    json['image'] as String?,
    json['description'] as String,
    json['categoryId'] as String,
  );
}

Map<String, dynamic> _$PlaylistToJson(Playlist instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  val['image'] = instance.image;
  val['categoryId'] = instance.categoryId;
  val['description'] = instance.description;
  val['id'] = instance.id;
  return val;
}
