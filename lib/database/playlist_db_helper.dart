import 'package:hidayat/models/playlist.dart';
import 'package:sqflite/sqflite.dart';

class PlaylistDbHelper {
  final Database database;

  PlaylistDbHelper(this.database);
  addPlaylist(Playlist playlist) {
    database.insert(Playlist.tableName, playlist.toJson());
  }

  addPlaylists(List<Playlist> playlists) {
    playlists.forEach((playlist) {
      addPlaylist(playlist);
    });
  }

  updatePlaylist(Playlist playlist) {
    database.update(Playlist.tableName, playlist.toJson(),
        where: "id = ?", whereArgs: [playlist.id]);
  }

  clearPlaylists(String categoryId) async {
    await database.delete(Playlist.tableName,
        where: "categoryId = ?", whereArgs: [categoryId]);
  }

  deletePlaylist(String playlistId) {
    database
        .delete(Playlist.tableName, where: "id = ?", whereArgs: [playlistId]);
  }

  Future<List<Playlist>> getPlaylists(String categoryId) async {
    return (await database.query(Playlist.tableName,
            where: "categoryId=?", whereArgs: [categoryId]))
        .map<Playlist>((e) => Playlist.fromJson(e))
        .toList();
  }
}
