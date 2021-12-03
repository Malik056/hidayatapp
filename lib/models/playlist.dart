import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:hidayat/models/bayan.dart';

import 'category.dart';

part 'playlist.g.dart';

@JsonSerializable()
class Playlist with Comparable<Playlist> {
  @JsonKey(required: true, disallowNullValue: true)
  String? name;
  String? image;
  @JsonKey(required: true, disallowNullValue: true)
  String categoryId;
  String description;
  @JsonKey(ignore: true)
  List<Bayan>? bayans;
  @JsonKey(required: true, disallowNullValue: true)
  String id;

  Playlist(this.id, this.name, this.image, this.description, this.categoryId);
  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
  factory Playlist.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data.putIfAbsent('id', () => snapshot.id);
    return Playlist.fromJson(data);
  }
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

  bool equals(Playlist other) {
    return id == other.id &&
        name == other.name &&
        image == other.image &&
        description == other.description &&
        categoryId == other.categoryId;
  }

  @JsonKey(ignore: true)
  static const String tableName = "playlist";
  static String get getSQLString => '''
  CREATE TABLE IF NOT EXISTS $tableName (
    id STRING PRIMARY KEY,
    name TEXT NOT NULL,
    image TEXT,
    description TEXT,
    categoryId TEXT NOT NULL,
    FOREIGN KEY (categoryId)
       REFERENCES ${Category.tableName} (id)
       ON DELETE CASCADE
  );
  ''';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Playlist && other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        image.hashCode ^
        categoryId.hashCode ^
        description.hashCode ^
        bayans.hashCode ^
        id.hashCode;
  }

  @override
  int compareTo(Playlist other) {
    if (name == other.name) return 0;
    if (name == null) return -1;
    if (other.name == null) return 1;
    return name!.compareTo(other.name!);
  }
}
