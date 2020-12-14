import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidayat/models/playlist.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bayan.g.dart';

@JsonSerializable(nullable: true)
class Bayan {
  String url;
  @JsonKey(required: true, nullable: false, disallowNullValue: true)
  String title;
  @JsonKey(required: true, nullable: false, disallowNullValue: true)
  String id;
  @JsonKey(required: true, nullable: false, disallowNullValue: true)
  String playlistId;
  @JsonKey(defaultValue: "")
  String description;

  Bayan(this.id, this.url, this.title, this.description, this.playlistId);
  factory Bayan.fromJson(Map<String, dynamic> json) => _$BayanFromJson(json);
  factory Bayan.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data());
    data.putIfAbsent('id', () => snapshot.id);
    return Bayan.fromJson(data);
  }
  Map<String, dynamic> toJson() => _$BayanToJson(this);

  bool equals(Bayan other) {
    return id == other.id &&
        title == other.title &&
        url == other.url &&
        description == other.description &&
        playlistId == other.playlistId;
  }

  @JsonKey(ignore: true)
  static const String tableName = "bayan";
  static String get getSQLString => '''
  CREATE TABLE IF NOT EXISTS $tableName (
    id STRING PRIMARY KEY,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    description TEXT,
    playlistId TEXT NOT NULL,
    FOREIGN KEY (playlistId)
       REFERENCES ${Playlist.tableName} (id)
       ON DELETE CASCADE
  );
  ''';
}
