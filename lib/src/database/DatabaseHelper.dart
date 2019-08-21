import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/models/SubCategories.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  static final String Categories_Table = "categories";
  static final String Sub_Categories_Table = "sub_categories";
  static final String Products_Table = "products";
  static final String Favorite = "0";

  Future<Database> get db async {
    if (_db != null)
      return _db;
    // if _database is null we instantiate it
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    // Get the directory path for both Android and iOS to store database.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "RestroApp.db");
    // Open/create the database at a given path
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the tables
    await db.execute(
        "CREATE TABLE ${Categories_Table}("
            "id INTEGER PRIMARY KEY, "
            "title TEXT, "
            "version TEXT, "
            "deleted TEXT, "
            "show_product_image TEXT, "
            "sort TEXT, "
            "image_100_80 TEXT, "
            "image_300_200 TEXT, "
            "sub_category TEXT, "
            "image TEXT"
            ")"
    );
    await db.execute(
        "CREATE TABLE ${Sub_Categories_Table}("
            "id INTEGER PRIMARY KEY, "
            "parent_id TEXT, "
            "title TEXT, "
            "version TEXT, "
            "status TEXT, "
            "deleted TEXT, "
            "sort TEXT"
            ")"
    );
    await db.execute(
        "CREATE TABLE ${Products_Table}("
            "id INTEGER PRIMARY KEY, "
            "store_id TEXT, "
            "category_ids TEXT, "
            "title TEXT, "
            "brand TEXT, "
            "nutrient TEXT, "
            "description TEXT, "
            "image TEXT, "
            "imageUrl TEXT, "
            "showPrice TEXT, "
            "isTaxEnable TEXT, "
            "gstTaxType TEXT, "
            "gstTaxRate TEXT, "
            "status TEXT, "
            "sort TEXT, "
            "favorite TEXT, "
            "image_100_80 TEXT, "
            "image_300_200 TEXT, "
            "variants_mrp_price TEXT, "
            "variants_price TEXT, "
            "variants_discount TEXT "
            ")"
    );


  }

  Future<int> saveCategories(CategoriesData categories) async {
    var dbClient = await db;
    int res = await dbClient.insert(Categories_Table, categories.toMap());
    return res;
  }

  Future<int> saveSubCategories(SubCategory subCategories,String cat_id) async {
    var dbClient = await db;
    int res = await dbClient.insert(Sub_Categories_Table, subCategories.toMap(cat_id));
    return res;
  }

  Future<int> saveProducts(Product products,String favorite,String mrp_price, String price, String discount) async {
    var dbClient = await db;
    int res = await dbClient.insert(Products_Table, products.toMap(favorite,mrp_price,price,discount));
    return res;
  }

  Future<int> checkProductsExist(String table,String category_id) async {
    //database connection
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * from $table where category_ids = $category_id');
    int count = list.length;
    return count;
  }

  Future<int> getCount(String table) async {
    //database connection
    var dbClient = await db;
    var x = await dbClient.rawQuery('SELECT COUNT (*) from $table');
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  /*Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }*/

  /*
  Future<List<UserModel>> getUserModelData() async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM user";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<UserModel> list = result.map((item) {
      return UserModel.fromMap(item);
    }).toList();

    print(result);
    return list;
  }*/

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}