import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restroapp/src/models/CartTableData.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  // Database table names
  static final String Categories_Table = "categories";
  static final String Sub_Categories_Table = "sub_categories";
  static final String Products_Table = "products";
  static final String Favorite_Table = "favorite";
  static final String CART_Table = "cart";

//  static final String VARIANT_Table = "Variant";

  // Database Columns
  static final String Favorite = "0";
  static final String ID = "id";
  static final String TITLE = "title";
  static final String VARIENT_ID = "variant_id";
  static final String PRODUCT_ID = "product_id";
  static final String WEIGHT = "weight";
  static final String MRP_PRICE = "mrp_price";
  static final String PRICE = "price";
  static final String DISCOUNT = "discount";
  static final String QUANTITY = "quantity";
  static final String isFavorite = "isfavorite";
  static final String Product_Json = "product_json";
  static final String IS_TAX_ENABLE = "isTaxEnable";
  static final String Product_Name = "product_name";
  static final String UNIT_TYPE = "unit_type";
  static final String nutrient = "nutrient";
  static final String description = "description";
  static final String imageType = "imageType";
  static final String imageUrl = "imageUrl";
  static final String image_100_80 = "image_100_80";
  static final String image_300_200 = "image_300_200";
  static final String ProductOffer = "product_offer";

  Future<Database> get db async {
    if (_db != null) return _db;
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
    var theDb = await openDatabase(path,
        version: 3, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the tables
    await db.execute("CREATE TABLE ${Categories_Table}("
        "id TEXT, "
        "title TEXT, "
        "version TEXT, "
        "deleted TEXT, "
        "show_product_image TEXT, "
        "sort TEXT, "
        "image_100_80 TEXT, "
        "image_300_200 TEXT, "
        "sub_category TEXT, "
        "image TEXT"
        ")");
    await db.execute("CREATE TABLE ${Sub_Categories_Table}("
        "id TEXT, "
        "parent_id TEXT, "
        "title TEXT, "
        "version TEXT, "
        "status TEXT, "
        "deleted TEXT, "
        "sort TEXT"
        ")");
    await db.execute("CREATE TABLE ${Products_Table}("
        "id TEXT, "
        "store_id TEXT, "
        "category_ids TEXT, "
        "title TEXT, "
        "brand TEXT, "
        "nutrient TEXT, "
        "description TEXT, "
        "tags TEXT, "
        "isfavorite TEXT, "
        "image TEXT, "
        "image_url TEXT, "
        "status TEXT, "
        "image_type TEXT, "
        "show_price TEXT, "
        "isTaxEnable TEXT, "
        "image_100_80 TEXT, "
        "image_300_200 TEXT, "
        "gst_tax_rate TEXT, "
        "gst_tax_type TEXT, "
        "deleted TEXT, "
        "sort TEXT, "
        "selectedVariant TEXT, "
        "variantId TEXT, "
        "weight TEXT, "
        "mrpPrice TEXT, "
        "price TEXT, "
        "discount TEXT, "
        "isUnitType TEXT, "
        "product_offer TEXT, "
        "variants TEXT"
        ")");
    /* await db.execute("CREATE TABLE ${Products_Table}("
        "id INTEGER PRIMARY KEY, "
        "store_id TEXT, "
        "category_ids TEXT, "
        "title TEXT, "
        "brand TEXT, "
        "nutrient TEXT, "
        "description TEXT, "
        "tags TEXT, "
        "isfavorite TEXT, "
        "image TEXT, "
        "show_price TEXT, "
        "isTaxEnable TEXT, "
        "image_100_80 TEXT, "
        "image_300_200 TEXT, "
        "variants TEXT"
        ")");*/

    await db.execute("CREATE TABLE ${CART_Table}("
        //"id INTEGER PRIMARY KEY, "
        "id INTEGER, "
        "product_name TEXT, "
        "isfavorite TEXT, "
        "nutrient TEXT, "
        "description TEXT, "
        "imageType TEXT, "
        "imageUrl TEXT, "
        "variant_id TEXT, "
        "product_id TEXT, "
        "weight TEXT, "
        "mrp_price TEXT, "
        "price TEXT, "
        "discount TEXT, "
        "quantity TEXT, "
        "isTaxEnable TEXT, "
        "image_100_80 TEXT, "
        "image_300_200 TEXT, "
        "unit_type TEXT"
        ")");

    await db.execute("CREATE TABLE ${Favorite_Table}("
        "id INTEGER, "
        "product_json TEXT, "
        "product_name TEXT, "
        "isfavorite TEXT, "
        "nutrient TEXT, "
        "description TEXT, "
        "imageType TEXT, "
        "imageUrl TEXT, "
        "variant_id TEXT, "
        "product_id TEXT, "
        "weight TEXT, "
        "mrp_price TEXT, "
        "price TEXT, "
        "discount TEXT, "
        "quantity TEXT, "
        "isTaxEnable TEXT, "
        "image_100_80 TEXT, "
        "image_300_200 TEXT, "
        "unit_type TEXT"
        ")");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
//    db.execute("ALTER TABLE ${Products_Table} ADD COLUMN newCol TEXT;");
    if (oldVersion < newVersion) {
      // you can execute drop table and create table
      db.execute(
          "ALTER TABLE ${Products_Table} ADD COLUMN product_offer TEXT;");
    }
  }

  Future<int> saveCategories(CategoryModel categoryModel) async {
    var dbClient = await db;
    int res = await dbClient.insert(Categories_Table, categoryModel.toMap());
    return res;
  }

  Future<int> saveSubCategories(
      SubCategory subCategories, String cat_id) async {
    var dbClient = await db;
    int res = await dbClient.insert(
        Sub_Categories_Table, subCategories.toMap(cat_id));
    return res;
  }

  Future<void> batchInsertCategorys(
      List<CategoryModel> categoryModelList) async {
    //print("-----------batchInsertCategorys---------------");
    Database db = await _instance.db;
    db.transaction((txn) async {
      Batch batch = txn.batch();
      for (CategoryModel category in categoryModelList) {
        batch.insert(Categories_Table, category.toMap());

        if (category.subCategory != null) {
          for (int j = 0; j < category.subCategory.length; j++) {
            batch.insert(Sub_Categories_Table,
                category.subCategory[j].toMap(category.id));
          }
//          batch.commit();
        }
      }
      batch.commit();
    });
    //print("------------batchInsertCategorys----batch.commit();-----------");
  }

  Future<void> batchInsertProducts(
      List<SubCategoryModel> subCategoriesList) async {
    //print("-----------batchInsertCategorys---------------");
    Database db = await _instance.db;
    db.transaction((txn) async {
      Batch batch = txn.batch();
      for (SubCategoryModel category in subCategoriesList) {
        if (category.products != null) {
          for (int j = 0; j < category.products.length; j++) {
            batch.insert(
                Products_Table, category.products[j].toMap(category.id));
          }
//          batch.commit();
        }
      }
      batch.commit();
    });
    //print("------------batchInsertCategorys----batch.commit();-----------");
  }

  Future<int> saveProducts(Product products, String category_ids) async {
    var dbClient = await db;
    int res =
        await dbClient.insert(Products_Table, products.toMap(category_ids));
    return res;
  }

  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categoryList = new List();
    var dbClient = await db;
    List<String> columnsToSelect = [
      ID,
      TITLE,
      "version",
      "deleted",
      "show_product_image",
      "sort",
      image_100_80,
      image_300_200,
      "sub_category",
      "image"
    ];

    List<Map> resultList =
        await dbClient.query(Categories_Table, columns: columnsToSelect);
    if (resultList != null && resultList.isNotEmpty) {
      resultList.forEach((row) {
        CategoryModel categoryModel = CategoryModel();
        categoryModel.id = row[ID].toString();
        categoryModel.title = row[TITLE];
        categoryModel.version = row["version"];
        categoryModel.image300200 = row[image_300_200];
        categoryList.add(categoryModel);
      });
    } else {
      //print("-empty cart-in db--");
    }
    return categoryList;
  }

  Future<List<SubCategory>> getSubCategories(String parent_id) async {
    List<SubCategory> subCategoryList = new List();
    var dbClient = await db;
    List<String> columnsToSelect = [
      ID,
      "parent_id",
      "title",
      "version",
      "status",
      "deleted",
      "sort"
    ];

    List<Map> resultList = await dbClient.query(Sub_Categories_Table,
        columns: columnsToSelect,
        where: 'parent_id = ?',
        whereArgs: [parent_id]);
    if (resultList != null && resultList.isNotEmpty) {
      resultList.forEach((row) {
        SubCategory subCategory = SubCategory();
        subCategory.id = row[ID].toString();
        subCategory.title = row[TITLE];
        subCategory.version = row["version"];
        subCategoryList.add(subCategory);
      });
    } else {
      //print("-empty cart-in db--");
    }
    return subCategoryList;
  }

  Future<List<SubCategoryModel>> getALLSubCategories() async {
    List<SubCategoryModel> subCategoryList = new List();
    var dbClient = await db;
    List<String> columnsToSelect = [
      "id",
      "parent_id",
      "title",
      "version",
      "status",
      "deleted",
      "sort"
    ];

    List<Map> resultList =
        await dbClient.query(Sub_Categories_Table, columns: columnsToSelect);
    if (resultList != null && resultList.isNotEmpty) {
      resultList.forEach((row) {
        SubCategoryModel subCategory = SubCategoryModel();
        subCategory.id = row[ID].toString();
        subCategory.title = row[TITLE];
        subCategory.parentId = row["parent_id"];
        subCategory.version = row["version"];
        subCategory.status = row["status"];
        subCategory.deleted = row["deleted"];
        subCategory.sort = row["sort"];

        subCategoryList.add(subCategory);
      });
    } else {
      //print("-empty cart-in db--");
    }
    return subCategoryList;
  }

  Future<List<SubCategoryModel>> getSubCategoriesFromID(
      String subCategoriesID) async {
    List<SubCategoryModel> subCategoryList = new List();
    var dbClient = await db;
    List<String> columnsToSelect = [
      "id",
      "parent_id",
      "title",
      "version",
      "status",
      "deleted",
      "sort"
    ];

    List<Map> resultList = await dbClient.query(Sub_Categories_Table,
        columns: columnsToSelect,
        where: 'id = ?',
        whereArgs: [subCategoriesID]);
    if (resultList != null && resultList.isNotEmpty) {
      resultList.forEach((row) {
        SubCategoryModel subCategory = SubCategoryModel();
        subCategory.id = row[ID].toString();
        subCategory.title = row[TITLE];
        subCategory.parentId = row["parent_id"];
        subCategory.version = row["version"];
        subCategory.status = row["status"];
        subCategory.deleted = row["deleted"];
        subCategory.sort = row["sort"];

        subCategoryList.add(subCategory);
      });
    } else {
      //print("-empty cart-in db--");
    }
    return subCategoryList;
  }

  /*Future<int> saveProductsVariant(Variant variant) async {
    var dbClient = await db;
    int res = await dbClient.insert(VARIANT_Table, variant.toMap());
    return res;
  }*/

  Future<List<Product>> getProducts(String category_ids) async {
    List<Product> productList = new List();
    var dbClient = await db;
    List<String> columnsToSelect = [
      "id",
      "store_id",
      "category_ids",
      "title",
      "brand",
      "nutrient",
      "description",
      "tags",
      "isfavorite",
      "image",
      "image_url",
      "status",
      "image_type",
      "show_price",
      "isTaxEnable",
      "image_100_80",
      "image_300_200",
      "gst_tax_rate",
      "gst_tax_type",
      "status",
      "deleted",
      "sort",
      "selectedVariant",
      "variantId",
      "weight",
      "mrpPrice",
      "price",
      "discount",
      "isUnitType",
      "product_offer",
      "variants"
    ];

    List<Map> resultList = await dbClient.query(Products_Table,
        columns: columnsToSelect,
        where: 'category_ids = ?',
        whereArgs: [category_ids]);

    if (resultList != null && resultList.isNotEmpty) {
      resultList.forEach((row) {
        Map productMap = Map<String, String>();
        Product product = Product();
        product.id = row["id"].toString();
        product.isFav = row["isfavorite"];
        product.storeId = row["store_id"];
        product.categoryIds = row["category_ids"];
        product.title = row["title"];
        product.brand = row["brand"];
        product.nutrient = row["nutrient"];
        product.description = row["description"];
        product.image = row["image"];
        product.imageType = row["image_type"];
        product.imageUrl = row["image_url"] ?? "";
        product.showPrice = row["show_price"];
        product.isTaxEnable = row["isTaxEnable"];
        product.gstTaxType = row["gst_tax_type"];
        product.gstTaxRate = row["gst_tax_rate"];
        product.status = row["status"];
        product.sort = row["sort"];
        Map<String, dynamic> map = jsonDecode(row["selectedVariant"]);
        product.selectedVariant = SelectedVariant.fromJson(map);
        product.deleted = row["deleted"] == 'true';
        product.image10080 = row["image_100_80"] ?? "";
        product.image300200 = row["image_300_200"] ?? "";
        var parsedListJson = jsonDecode(row["variants"]);
        List<Variant> variantsList =
            List<Variant>.from(parsedListJson.map((i) => Variant.fromJson(i)));
        product.variants = variantsList;
        product.variantId = row["variantId"].toString();
        product.weight = row["weight"];
        product.mrpPrice = row["mrpPrice"];
        product.price = row["price"];
        product.isSubscriptionOn = row["is_subscription_on"];
        product.discount = row["discount"];
        product.isUnitType = row["isUnitType"];
        product.product_offer = int.parse(row["product_offer"]);

        for (var i = 0; i < variantsList.length; i++) {
          productMap[variantsList[i].id] = variantsList[i].isSubscriptionOn;
          //print("==${variantsList[i].id}=isSubscriptionOn===${variantsList[i].isSubscriptionOn}");
        }
        product.variantMap = productMap;

        productList.add(product);
      });
    }
    return productList;
  }

  /*Future<List<Variant>> getProductsVariants(String productID) async {
    List<Variant> variantList = new List();
    var dbClient = await db;
    List<String> columnsToSelect = [
      "id",
      "store_id",
      "product_id",
      "sku",
      "weight",
      "mrp_price",
      "price",
      "discount",
      "unit_type",
      "custom_field1",
      "custom_field2",
      "custom_field3",
      "custom_field4",
      "order_by",
      "sort",
      "is_export_from_file"
    ];

    List<Map> resultList = await dbClient.query(VARIANT_Table,
        columns: columnsToSelect,
        where: 'product_id = ?',
        whereArgs: [productID]);
    if (resultList != null && resultList.isNotEmpty) {
      resultList.forEach((row) {
        Variant variant = Variant();
        variant.id = row["id"].toString();
        variant.storeId = row["store_id"];
        variant.productId = row["product_id"];
        variant.sku = row["sku"];
        variant.weight = row["weight"];
        variant.mrpPrice = row["mrp_price"];
        variant.price = row["price"];
        variant.discount = row["discount"];
        variant.unitType = row["unit_type"];
        variant.customField1 = row["custom_field1"];
        variant.customField2 = row["custom_field2"];
        variant.customField3 = row["custom_field3"];
        variant.customField4 = row["custom_field4"];
        variant.orderBy = row["order_by"];
        variant.sort = row["sort"];
        variant.isExportFromFile = row["is_export_from_file"];
        variantList.add(variant);
      });
    }
    return variantList;
  }*/

  Future<int> addProductToCart(Map<String, dynamic> row) async {
    var dbClient = await db;
    int res = 0;
    res = await dbClient.insert(CART_Table, row);
    print("-insert Products-- ${res}");
    return res;
  }

  Future<int> addProductToFavTable(Map<String, dynamic> row) async {
    var dbClient = await db;
    int res = await dbClient.insert(Favorite_Table, row);
    return res;
  }

  Future<int> updateProductInCart(
      Map<String, dynamic> row, String variantId) async {
    var dbClient = await db;
    return dbClient.update(CART_Table, row,
        where: "${VARIENT_ID} = ?", whereArgs: [variantId]);
  }

  Future<CartData> getProductQuantitiy(String variantId) async {
    CartData cartData;
    String count = "0";
    //database connection
    var dbClient = await db;
    // get single row
    List<String> columnsToSelect = [
      QUANTITY,
      VARIENT_ID,
      WEIGHT,
      MRP_PRICE,
      PRICE,
      DISCOUNT
    ];

    String whereClause = '${DatabaseHelper.VARIENT_ID} = ?';

    List<dynamic> whereArguments = [variantId];
    List<Map> result;
    result = await dbClient.query(CART_Table,
        columns: columnsToSelect,
        where: whereClause,
        whereArgs: whereArguments);
    // print the results
    if (result != null && result.isNotEmpty) {
      //print("---result.length--- ${result.length}");
      result.forEach((row) {
        //print("-1-quantity--- ${row['quantity']}");
        cartData = new CartData();
        count = row[QUANTITY];
        cartData.QUANTITY = count;
        //return count;
      });
    } else {
      //print("-X-quantity--- return 0");
      //return count;
      cartData = new CartData();
      count = "0";
      cartData.QUANTITY = count;
    }
    return cartData;
  }

  /*
    this method will get all the data from cart table and it will calculate the cart total price
    for the item added in the cart by the user
  * */
  Future<double> getTotalPrice({
    bool isOrderVariations = false,
    List<OrderDetail> responseOrderDetail,
  }) async {
    double totalPrice = 0.00;
    //database connection
    var dbClient = await db;
    List<String> columnsToSelect = [
      MRP_PRICE,
      PRICE,
      DISCOUNT,
      QUANTITY,
      'id',
      VARIENT_ID
    ];
    List<Map> resultList;
    resultList = await dbClient.query(CART_Table, columns: columnsToSelect);
    // print the results
    if (resultList != null && resultList.isNotEmpty) {
      //print("--TotalPrice-result.length--- ${resultList.length}");
//      resultList.forEach((row) {
//        //print(row);
//      });
      String price = "0";
      String quantity = "0";
      int id = 0;
      String varientID = '0';
      resultList.forEach((row) {
        price = row[PRICE];
        quantity = row[QUANTITY];
        id = row['id'];
        varientID = row[VARIENT_ID];
        try {
          double total = int.parse(quantity) * double.parse(price);
          //print("-------total------${roundOffPrice(total,2)}");
          //print("-price ${price}---");
          OrderDetail detail;
          bool isProductOutOfStock = false;
          if (isOrderVariations) {
            InnerFor:
            for (int i = 0; i < responseOrderDetail.length; i++) {
              if (responseOrderDetail[i]
                      .productStatus
                      .contains('out_of_stock') &&
                  int.parse(responseOrderDetail[i].productId) == id &&
                  responseOrderDetail[i].variantId.compareTo(varientID) == 0) {
                isProductOutOfStock = true;
                break InnerFor;
              }
              if (responseOrderDetail[i]
                          .productStatus
                          .compareTo('price_changed') ==
                      0 &&
                  int.parse(responseOrderDetail[i].productId) == id &&
                  responseOrderDetail[i].variantId.compareTo(varientID) == 0) {
                detail = responseOrderDetail[i];
                break InnerFor;
              }
            }
          }
          if (!isProductOutOfStock) {
            double price =
                detail != null && detail.productStatus.contains('price_changed')
                    ? double.parse(detail.newPrice)
                    : total;
            totalPrice = totalPrice + roundOffPrice(price, 2);
          }
        } catch (e) {
          print(e);
        }
      });
      //print("-DB totalPrice is ${totalPrice}--");
      return totalPrice;
    } else {
      //print("-empty cart---");
    }
    return totalPrice;
  }

  /*
    this method will get all the data from cart table
  * */
  Future<List<Product>> getCartItemList() async {
    List<Product> cartList = new List();
    var dbClient = await db;
    List<String> columnsToSelect = [
      MRP_PRICE,
      PRICE,
      DISCOUNT,
      isFavorite,
      QUANTITY,
      Product_Name,
      VARIENT_ID,
      WEIGHT,
      PRODUCT_ID,
      UNIT_TYPE,
      IS_TAX_ENABLE,
      nutrient,
      description,
      imageType,
      imageUrl,
      image_100_80,
      image_300_200
    ];

    List<Map> resultList;
    resultList = await dbClient.query(CART_Table, columns: columnsToSelect);
    if (resultList != null && resultList.isNotEmpty) {
      await Future.forEach(resultList, (row) async {
        Product product = new Product();
        product.mrpPrice = row[MRP_PRICE];
        product.price = row[PRICE];
        product.isFav = row[isFavorite];
        product.discount = row[DISCOUNT];
        product.quantity = row[QUANTITY];
        product.title = row[Product_Name];
        product.variantId = row[VARIENT_ID];
        product.weight = row[WEIGHT];
        product.id = row[PRODUCT_ID];
        product.isUnitType = row[UNIT_TYPE] ?? '';
        product.isTaxEnable = row[IS_TAX_ENABLE] ?? '0';
        product.nutrient = row[nutrient];
        product.description = row[description];
        product.imageType = row[imageType];
        product.imageUrl = row[imageUrl];
        product.image10080 = row[image_100_80];
        product.image300200 = row[image_300_200];
        try {
          int productOffer = await getProductOfferInProductTable(product.id);
          product.product_offer = productOffer;
        } catch (e) {
          print(e);
        }
        cartList.add(product);
      });
    } else {
      //print("-empty cart-in db--");
    }
    return cartList;
  }

  Future<int> getProductOfferInProductTable(String id) async {
    int productOffer = 0;
    var dbClient = await db;
    List<String> columnsToSelect = [
      "id",
      "product_offer",
    ];
    List<Map> resultList = await dbClient.query(Products_Table,
        columns: columnsToSelect, where: '$ID = ?', whereArgs: [id]);

    if (resultList != null && resultList.isNotEmpty) {
      resultList.forEach((row) {
        productOffer = int.parse(row["product_offer"]);
        //print("-product.product_offer--=${productOffer}");
      });
    }
    return productOffer;
  }

  Future<int> updateProductOfferValueInProductsTable(
      Map<String, dynamic> row, String productId) async {
    var dbClient = await db;
    return dbClient.update(Products_Table, row,
        where: "${ID} = ?", whereArgs: [productId]);
  }

  Future<List<Product>> getFavouritesList() async {
    //print("------------getFavouritesList--------------");
    List<Product> cartList = new List();
    var dbClient = await db;
    List<String> columnsToSelect = [
      MRP_PRICE,
      PRICE,
      DISCOUNT,
      isFavorite,
      QUANTITY,
      Product_Name,
      Product_Json,
      VARIENT_ID,
      WEIGHT,
      PRODUCT_ID,
      UNIT_TYPE,
      IS_TAX_ENABLE,
      nutrient,
      description,
      imageType,
      imageUrl,
      image_100_80,
      image_300_200
    ];

    //String whereClause = '${DatabaseHelper.isFavorite} = 1';

    List<Map> resultList =
        await dbClient.query(Favorite_Table, columns: columnsToSelect);

    if (resultList != null && resultList.isNotEmpty) {
      resultList.forEach((row) {
        Product product = new Product();
        product.mrpPrice = row[MRP_PRICE];
        product.price = row[PRICE];
        product.isFav = row[isFavorite];
        product.discount = row[DISCOUNT];
        product.quantity = row[QUANTITY];
        product.productJson = row[Product_Json];
        product.title = row[Product_Name];
        product.variantId = row[VARIENT_ID];
        product.weight = row[WEIGHT];
        product.id = row[PRODUCT_ID];
        product.isUnitType = row[UNIT_TYPE] ?? '';
        product.isTaxEnable = row[IS_TAX_ENABLE] ?? '0';
        product.nutrient = row[nutrient];
        product.description = row[description];
        product.imageType = row[imageType];
        product.imageUrl = row[imageUrl];
        product.image10080 = row[image_100_80];
        product.image300200 = row[image_300_200];

        cartList.add(product);
      });
    } else {
      //print("-empty cart-in db--");
    }
    //print("-Fav--List.length===>${cartList.length}--");
    return cartList;
  }

  Future<String> getCartItemsListToJson(
      {bool isOrderVariations = false,
      List<OrderDetail> responseOrderDetail}) async {
    List<Product> productCartList = await getCartItemList();
    if (isOrderVariations) {
      for (int i = 0; i < responseOrderDetail.length; i++) {
        if (responseOrderDetail[i].productStatus.contains('out_of_stock')) {
          Product toBeRemovedProduct;
          innerFor:
          for (int j = 0; j < productCartList.length; j++) {
            if (productCartList[j]
                        .id
                        .compareTo(responseOrderDetail[i].productId) ==
                    0 &&
                productCartList[j]
                        .variantId
                        .compareTo(responseOrderDetail[i].variantId) ==
                    0) {
              toBeRemovedProduct = productCartList[j];
              break innerFor;
            }
          }
          if (toBeRemovedProduct != null) {
            productCartList.remove(toBeRemovedProduct);
          }
        }

        if (responseOrderDetail[i].productStatus.compareTo('price_changed') ==
            0) {
          for (int j = 0; j < productCartList.length; j++) {
            if (productCartList[j]
                        .id
                        .compareTo(responseOrderDetail[i].productId) ==
                    0 &&
                productCartList[j]
                        .variantId
                        .compareTo(responseOrderDetail[i].variantId) ==
                    0) {
              productCartList[j].mrpPrice = responseOrderDetail[i].newMrpPrice;
              productCartList[j].price = responseOrderDetail[i].newPrice;
            }
          }
        }
      }
    }
    List jsonList = Product.encodeToJson(productCartList);
    String encodedDoughnut = jsonEncode(jsonList);
    return encodedDoughnut;
  }

  double roundOffPrice(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  Future<int> checkProductsExistInFavTable(
      String table, String product_id) async {
    //database connection
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * from $table where ${ID} = $product_id');
    int count = list.length;
    //print("-checkProductsExistInFavTable-- ${count}");
    return count;
  }

  Future<int> checkIfProductsExistInDb(String table, String variant_id) async {
    //database connection
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * from $table where ${VARIENT_ID} = $variant_id');
    int count = list.length;
    //print("-checkIfProductsExist-- ${count}");
    return count;
  }

  Future<int> getCount(String table,
      [String condition, String conditionValue]) async {
    //database connection
    var dbClient = await db;
    var x;
//    if (condition!=null) {
//      x = await dbClient.rawQuery('SELECT COUNT (*) from $table where ${condition} = $conditionValue');
//    } else {
    x = await dbClient.rawQuery('SELECT COUNT (*) from $table');
//    }
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<int> getCountWithCondition(
      String table, String condition, String conditionValue) async {
    //database connection
    var dbClient = await db;
    var x;
    if (condition != null) {
      x = await dbClient.rawQuery(
          'SELECT COUNT (*) from $table where ${condition} = $conditionValue');
    } else {
      x = await dbClient.rawQuery('SELECT COUNT (*) from $table');
    }
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<int> deleteFav(String table, String product_Id) async {
    var dbClient = await db;
    return await dbClient
        .delete(table, where: '$ID = ?', whereArgs: [product_Id]);
  }

  Future<int> delete(String table, String variant_Id) async {
    var dbClient = await db;
    return await dbClient
        .delete(table, where: '$VARIENT_ID = ?', whereArgs: [variant_Id]);
  }

  Future<int> deleteTable(String table) async {
    var dbClient = await db;
    return await dbClient.delete(table);
  }

  void clearDataBase({bool isRemoveAll = true}) async {
    var dbClient = await db;
    dbClient.delete(Categories_Table);
    dbClient.delete(Sub_Categories_Table);
    dbClient.delete(Products_Table);
    if(isRemoveAll)
    dbClient.delete(Favorite_Table);
//    dbClient.delete(CART_Table);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  void updateProductDetails(Product first) {}

  Future<List<Product>> getProductsByIDs(List<Product> cartList) async {
    List<Product> productList = new List();
    if (cartList.isEmpty) {
      return productList;
    }
    List<String> ids = List();
    String id = '';
    for (int i = 0; i < cartList.length; i++) {
      ids.add(cartList[i].id);
      if (i != cartList.length - 1)
        id = id + cartList[i].id + ', ';
      else
        id = id + cartList[i].id;
    }

    var dbClient = await db;

//    List<Map> resultList = await dbClient.query(Products_Table,
//        columns: columnsToSelect, where: 'id = ?', whereArgs: ids);

    List<Map> resultList = await dbClient
        .rawQuery('SELECT * from ${Products_Table} where ${ID} in (${id})');
    if (resultList != null && resultList.isNotEmpty) {
      resultList.forEach((row) {
        Product product = Product();
        product.id = row["id"].toString();
        product.isFav = row["isfavorite"];
        product.storeId = row["store_id"];
        product.categoryIds = row["category_ids"];
        product.title = row["title"];
        product.brand = row["brand"];
        product.nutrient = row["nutrient"];
        product.description = row["description"];
        product.image = row["image"];
        product.imageType = row["image_type"];
        product.imageUrl = row["image_url"] ?? "";
        product.showPrice = row["show_price"];
        product.isTaxEnable = row["isTaxEnable"];
        product.gstTaxType = row["gst_tax_type"];
        product.gstTaxRate = row["gst_tax_rate"];
        product.status = row["status"];
        product.sort = row["sort"];
        Map<String, dynamic> map = jsonDecode(row["selectedVariant"]);
        product.selectedVariant = SelectedVariant.fromJson(map);
        product.deleted = row["deleted"] == 'true';
        product.image10080 = row["image_100_80"] ?? "";
        product.image300200 = row["image_300_200"] ?? "";
        var parsedListJson = jsonDecode(row["variants"]);
        List<Variant> variantsList =
            List<Variant>.from(parsedListJson.map((i) => Variant.fromJson(i)));
        product.variants = variantsList;
        product.variantId = row["variantId"].toString();
        product.weight = row["weight"];
        product.mrpPrice = row["mrpPrice"];
        product.price = row["price"];
        product.discount = row["discount"];
        product.isUnitType = row["isUnitType"];

        productList.add(product);
      });

      for (int i = 0; i < cartList.length; i++) {
        for (int j = 0; j < productList.length; j++) {
          if (cartList[i].id.compareTo(productList[j].id) == 0) {
            cartList[i].id = productList[j].id;
            cartList[i].storeId = productList[j].storeId;
            cartList[i].categoryIds = productList[j].categoryIds;
            cartList[i].title = productList[j].title;
            cartList[i].brand = productList[j].brand;
            cartList[i].nutrient = productList[j].nutrient;
            cartList[i].description = productList[j].description;
            cartList[i].image = productList[j].image;
            cartList[i].imageType = productList[j].imageType;
            cartList[i].imageUrl = productList[j].imageUrl;
            cartList[i].showPrice = productList[j].showPrice;
            cartList[i].isTaxEnable = productList[j].isTaxEnable;
            cartList[i].gstTaxType = productList[j].gstTaxType;
            cartList[i].gstTaxRate = productList[j].gstTaxRate;
            cartList[i].status = productList[j].status;
            cartList[i].sort = productList[j].sort;
            cartList[i].selectedVariant = productList[j].selectedVariant;
            cartList[i].deleted = productList[j].deleted;
            cartList[i].image10080 = productList[j].image10080;
            cartList[i].image300200 = productList[j].image300200;
            cartList[i].variants = productList[j].variants;
//            cartList[i].mrpPrice = productList[j].mrpPrice;
//            cartList[i].price = productList[j].price;
//            cartList[i].discount = productList[j].discount;
            break;
          }
        }
      }
      return cartList;
    } else {
      return cartList;
    }
  }
}
