class CartProductData {

  String _product_name = "";
  String _variant_id = "";
  String _product_id = "";
  String _weight = "";
  String _mrp_price = "";
  String _price = "";
  String _discount = "";
  String _quantity = "";
  String _isTaxEnable = "";
  String _isunit_type = "";

  String get isunit_type => _isunit_type;

  set isunit_type(String value) {
    _isunit_type = value;
  }

  String get product_name => _product_name;

  set product_name(String value) {
    _product_name = value;
  }

  String get variant_id => _variant_id;

  set variant_id(String value) {
    _variant_id = value;
  }

  String get product_id => _product_id;

  set product_id(String value) {
    _product_id = value;
  }

  String get weight => _weight;

  set weight(String value) {
    _weight = value;
  }

  String get mrp_price => _mrp_price;

  set mrp_price(String value) {
    _mrp_price = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get discount => _discount;

  set discount(String value) {
    _discount = value;
  }

  String get quantity => _quantity;

  set quantity(String value) {
    _quantity = value;
  }

  String get isTaxEnable => _isTaxEnable;

  set isTaxEnable(String value) {
    _isTaxEnable = value;
  }

  Map<String,dynamic> toJson(){
    return {
      "isTaxEnable": this.isTaxEnable,
      "price": this.price,
      "product_id": this.product_id,
      "quantity": this.quantity,
      "variant_id": this.variant_id,
      "product_name": this.product_name,
      "weight": this._weight,
      "mrp_price":this._mrp_price,
      "unit_type":this._isunit_type,
    };
  }

  static List encondeToJson(List<CartProductData>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toJson())
    ).toList();
    return jsonList;
  }

}