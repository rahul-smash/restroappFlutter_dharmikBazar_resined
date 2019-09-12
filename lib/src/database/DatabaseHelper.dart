import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restroapp/src/models/CartData.dart';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/models/SubCategories.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  // Database table names
  static final String Categories_Table = "categories";
  static final String Sub_Categories_Table = "sub_categories";
  static final String Products_Table = "products";
  static final String CART_Table = "cart";

  // Database Columns
  static final String Favorite = "0";
  static final String ID = "id";
  static final String VARIENT_ID = "variant_id";
  static final String PRODUCT_ID = "product_id";
  static final String WEIGHT = "weight";
  static final String MRP_PRICE = "mrp_price";
  static final String PRICE = "price";
  static final String DISCOUNT = "discount";
  static final String QUANTITY = "quantity";
  static final String IS_TAX_ENABLE = "isTaxEnable";
  static final String Product_Name = "product_name";

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
            "variants_discount TEXT, "
            "variants_id TEXT "
            ")"
    );
    await db.execute(
        "CREATE TABLE ${CART_Table}("
            "id INTEGER PRIMARY KEY, "
            "product_name TEXT, "
            "variant_id TEXT, "
            "product_id TEXT, "
            "weight TEXT, "
            "mrp_price TEXT, "
            "price TEXT, "
            "discount TEXT, "
            "quantity TEXT, "
            "isTaxEnable TEXT"
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

  Future<int> saveProducts(Product products,String favorite,String mrp_price, String price, String discount, String var_id) async {
    var dbClient = await db;
    int res = await dbClient.insert(Products_Table, products.toMap(favorite,mrp_price,price,discount,var_id));
    return res;
  }

  Future<int> addProductToCart(Map<String, dynamic> row) async {
    var dbClient = await db;
    int res = await dbClient.insert(CART_Table,row);
    return res;
  }

  Future<int> updateProductInCart(Map<String, dynamic> row, int product_id) async {
    var dbClient = await db;

    return dbClient.update(CART_Table, row, where: "${ID} = ?", whereArgs: [product_id]);

  }

  Future<int> checkProductsExist(String table,String category_id) async {
    //database connection
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * from $table where category_ids = $category_id');
    int count = list.length;
    return count;
  }

  Future<String> getProductQuantitiy(int product_id) async {
    String count = "0";
    //database connection
    var dbClient = await db;
    // get single row
    List<String> columnsToSelect = [QUANTITY];
    String whereClause = '${DatabaseHelper.ID} = ?';
    List<dynamic> whereArguments = [product_id];
    List<Map> result = await dbClient.query(CART_Table, columns: columnsToSelect,where: whereClause, whereArgs: whereArguments);
    // print the results
    if(result != null && result.isNotEmpty){
      print("---result.length--- ${result.length}");
      result.forEach((row){
        print("-1-quantity--- ${row['quantity']}");
        count = row[QUANTITY];
        //return count;
      });
    }else{
      print("-X-quantity--- return 0");
      //return count;
      count = "0";
    }
    return count;
  }


  /*
    this method will get all the data from cart table and it will calculate the cart total price
    for the item added in the cart by the user
  * */
  Future<double> getTotalPrice() async {
    double totalPrice = 0.00;
    //database connection
    var dbClient = await db;
    List<String> columnsToSelect = [MRP_PRICE,PRICE,DISCOUNT,QUANTITY];
    List<Map> resultList = await dbClient.query(CART_Table, columns: columnsToSelect);
    // print the results
    if(resultList != null && resultList.isNotEmpty){
      print("---result.length--- ${resultList.length}");
      resultList.forEach((row) => print(row));
      String price = "0";
      String quantity = "0";
      resultList.forEach((row){
        price = row[PRICE];
        quantity = row[QUANTITY];
        try {
          double total = int.parse(quantity) * double.parse(price);
          //print("-------total------${roundOffPrice(total,2)}");
          totalPrice = totalPrice + roundOffPrice(total,2);
        } catch (e) {
          print(e);
        }
      });
      return totalPrice;
      //print("-totalPrice is ${totalPrice}--");
    }else{
      print("-empty cart---");
    }
    return totalPrice;
  }

  /*
    this method will get all the data from cart table
  * */
  Future<List<CartProductData>> getCartItemList() async {
    List<CartProductData> cartList = new List();
    //database connection
    var dbClient = await db;
    List<String> columnsToSelect = [MRP_PRICE,PRICE,DISCOUNT,QUANTITY,
      Product_Name,VARIENT_ID,WEIGHT,PRODUCT_ID];
    List<Map> resultList = await dbClient.query(CART_Table, columns: columnsToSelect);
    // print the results
    if(resultList != null && resultList.isNotEmpty){
      print("---result.length--- ${resultList.length}");
      resultList.forEach((row){
        CartProductData cartProductData = new CartProductData();
        cartProductData.mrp_price = row[MRP_PRICE];
        cartProductData.price = row[PRICE];
        cartProductData.discount = row[DISCOUNT];
        cartProductData.quantity = row[QUANTITY];
        cartProductData.product_name = row[Product_Name];
        cartProductData.variant_id = row[VARIENT_ID];
        cartProductData.weight = row[WEIGHT];
        cartProductData.product_id = row[PRODUCT_ID];
        cartList.add(cartProductData);

      });
    }else{
      print("-empty cart-in db--");
    }
    return cartList;
  }

  double roundOffPrice(double val, int places){
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  Future<int> checkIfProductsExistInCart(String table, int product_id) async {
    //database connection
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * from $table where ${ID} = $product_id');
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

  Future<int> delete(String table,int id) async {
    var dbClient = await db;
    return await dbClient.delete(table, where: '$ID = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}