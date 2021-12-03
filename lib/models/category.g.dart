// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'id'],
    disallowNullValues: const ['name', 'id'],
  );
  return Category(
    json['id'] as String,
    json['name'] as String? ?? '',
    json['description'] as String? ?? '',
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'description': instance.description,
    };
