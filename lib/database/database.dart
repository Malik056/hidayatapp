import 'package:hidayat/database/bayan_db_helper.dart';
import 'package:hidayat/database/category_db_helper.dart';
import 'package:hidayat/database/playlist_db_helper.dart';
import 'package:hidayat/models/bayan.dart';
import 'package:hidayat/models/category.dart';
import 'package:hidayat/models/playlist.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MySQLiteDatabase {
  static MySQLiteDatabase _mySQLiteDatabase;
  Database database;
  BayanDbHelper bayanDbHelper;
  CategoryDbHelper categoryDbHelper;
  PlaylistDbHelper playlistDbHelper;

  static MySQLiteDatabase getInstance() {
    if (_mySQLiteDatabase == null) {
      _mySQLiteDatabase = MySQLiteDatabase._();
    }
    return _mySQLiteDatabase;
  }

  MySQLiteDatabase._();

  Future<Database> init() async {
    String path = join(await getDatabasesPath(), "myDb");
    database = await openDatabase(
      path,
      version: 4,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      onDowngrade: onDowngrade,
    );
    bayanDbHelper = BayanDbHelper(database);
    categoryDbHelper = CategoryDbHelper(database);
    playlistDbHelper = PlaylistDbHelper(database);
    return database;
  }

  onCreate(Database db, int version) async {
    await db.execute(Bayan.getSQLString);
    await db.execute(Category.getSQLString);
    await db.execute(Playlist.getSQLString);
  }

  onUpgrade(Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE ${Bayan.tableName}");
    db.execute("DROP TABLE ${Playlist.tableName}");
    db.execute("DROP TABLE ${Category.tableName}");
    onCreate(db, newVersion);
  }

  onDowngrade(Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE ${Bayan.tableName}");
    db.execute("DROP TABLE ${Playlist.tableName}");
    db.execute("DROP TABLE ${Category.tableName}");
    onCreate(db, newVersion);
  }
}
