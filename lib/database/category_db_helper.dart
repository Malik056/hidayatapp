import 'package:hidayat/models/category.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDbHelper {
  final Database database;

  CategoryDbHelper(this.database);
  addCategory(Category category) {
    database.insert(Category.tableName, category.toJson());
  }

  addCategories(List<Category> categories) {
    categories.forEach((category) {
      addCategory(category);
    });
  }

  updateCategory(Category category) {
    database.update(Category.tableName, category.toJson(),
        where: "id = ?", whereArgs: [category.id]);
  }

  clearCategories() async {
    await database.delete(Category.tableName);
  }

  deleteCategory(String categoryId) {
    database
        .delete(Category.tableName, where: "id = ?", whereArgs: [categoryId]);
  }

  Future<List<Category>> getCategories() async {
    return (await database.query(Category.tableName))
        .map<Category>((e) => Category.fromJson(e))
        .toList();
  }
}
