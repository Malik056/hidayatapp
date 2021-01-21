import 'package:hidayat/models/bayan.dart';
import 'package:sqflite/sqflite.dart';

class BayanDbHelper {
  final Database database;

  BayanDbHelper(this.database);
  addBayan(Bayan bayan) {
    database.insert(Bayan.tableName, bayan.toJson());
  }

  addBayans(List<Bayan> bayans) {
    bayans.forEach((bayan) {
      addBayan(bayan);
    });
  }

  updateBayan(Bayan bayan) {
    database.update(Bayan.tableName, bayan.toJson(),
        where: "id = ?", whereArgs: [bayan.id]);
  }

  clearBayans(String playlistId) async {
    await database.delete(Bayan.tableName,
        where: "playlistId = ?", whereArgs: [playlistId]);
  }

  deleteBayan(String bayanId) {
    database.delete(Bayan.tableName, where: "id = ?", whereArgs: [bayanId]);
  }

  Future<List<Bayan>> getBayans(String playlistId) async {
    return (await database.query(Bayan.tableName,
            where: "playlistId=?", whereArgs: [playlistId], orderBy: 'name ASC',))
        .map<Bayan>((e) => Bayan.fromJson(e))
        .toList();
  }
}
