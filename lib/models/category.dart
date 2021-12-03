import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:hidayat/models/playlist.dart';

part 'category.g.dart';

@JsonSerializable()
class Category with Comparable<Category> {
  @JsonKey(required: true, disallowNullValue: true)
  String name;
  @JsonKey(ignore: true)
  List<Playlist>? playlists;
  @JsonKey(required: true, disallowNullValue: true)
  String id;
  @JsonKey(defaultValue: "")
  String description;

  Category(this.id, [this.name = '', this.description = '']);

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data.putIfAbsent('id', () => snapshot.id);
    return Category.fromJson(data);
  }

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  bool equals(Category category) {
    return category.id == id &&
        category.name == name &&
        category.description == description;
  }

  @JsonKey(ignore: true)
  static const String tableName = "category";
  static String get getSQLString => '''
  CREATE TABLE IF NOT EXISTS $tableName (
    id STRING PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
  );
  ''';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category && other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        playlists.hashCode ^
        id.hashCode ^
        description.hashCode;
  }

  @override
  int compareTo(Category other) {
    return name.compareTo(other.name);
  }
}
