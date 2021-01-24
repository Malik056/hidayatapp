import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidayat/mixin/downloadable.dart';
import 'package:hidayat/models/playlist.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bayan.g.dart';

@JsonSerializable(nullable: true)
class Bayan extends Downloadable {
  String link;
  @JsonKey(required: true, nullable: false, disallowNullValue: true)
  String name;
  @JsonKey(required: true, nullable: false, disallowNullValue: true)
  String id;
  @JsonKey(required: true, nullable: false, disallowNullValue: true)
  String playlistId;
  @JsonKey(defaultValue: "")
  String description;
  @JsonKey(defaultValue: null)
  String filePath;

  Bayan(this.id, this.link, this.name, this.description, this.playlistId);
  factory Bayan.fromJson(Map<String, dynamic> json) => _$BayanFromJson(json);
  factory Bayan.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data());
    data.putIfAbsent('id', () => snapshot.id);
    return Bayan.fromJson(data);
  }
  Map<String, dynamic> toJson() => _$BayanToJson(this);

  String getUniqueFileName() {
    var split = name.split('.');
    if (split.length <= 1) {
      return id;
    }
    String ext = split[split.length - 1];
    if (ext.contains(' ')) {
      return id;
    }
    return id + ext;
  }

  bool equals(Bayan other) {
    return id == other.id &&
        name == other.name &&
        link == other.link &&
        description == other.description &&
        playlistId == other.playlistId;
  }

  @JsonKey(ignore: true)
  static const String tableName = "bayan";
  static String get getSQLString => '''
  CREATE TABLE IF NOT EXISTS $tableName (
    id STRING PRIMARY KEY,
    name TEXT NOT NULL,
    link TEXT NOT NULL,
    description TEXT,
    playlistId TEXT NOT NULL,
    filePath TEXT,
    FOREIGN KEY (playlistId)
       REFERENCES ${Playlist.tableName} (id)
       ON DELETE CASCADE
  );
  ''';
}
