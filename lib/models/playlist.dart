import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidayat/models/bayan.dart';
import 'package:json_annotation/json_annotation.dart';

import 'category.dart';

part 'playlist.g.dart';

@JsonSerializable(nullable: true)
class Playlist {
  @JsonKey(required: true, nullable: false, disallowNullValue: true)
  String name;
  String imageUrl;
  @JsonKey(required: true, nullable: false, disallowNullValue: true)
  String categoryId;
  String description;
  @JsonKey(ignore: true)
  List<Bayan> bayans;
  @JsonKey(required: true, nullable: false, disallowNullValue: true)
  String id;

  Playlist(
      this.id, this.name, this.imageUrl, this.description, this.categoryId);
  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
  factory Playlist.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data());
    data.putIfAbsent('id', () => snapshot.id);
    return Playlist.fromJson(data);
  }
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

  bool equals(Playlist other) {
    return id == other.id &&
        name == other.name &&
        imageUrl == other.imageUrl &&
        description == other.description &&
        categoryId == other.categoryId;
  }

  @JsonKey(ignore: true)
  static const String tableName = "playlist";
  static String get getSQLString => '''
  CREATE TABLE IF NOT EXISTS $tableName (
    id STRING PRIMARY KEY,
    name TEXT NOT NULL,
    imageUrl TEXT,
    description TEXT,
    categoryId TEXT NOT NULL,
    FOREIGN KEY (categoryId)
       REFERENCES ${Category.tableName} (id)
       ON DELETE CASCADE
  );
  ''';
}
