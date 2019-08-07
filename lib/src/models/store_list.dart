class StoreListModel{

  String id;
  String store_name;
  String location;
  String city;
  String state;
  String country;
  String store_logo;

  StoreListModel({this.id,this.store_name, this.location,this.city,
    this.state,this.country,this.store_logo,
  });



  factory StoreListModel.fromJson(Map<String, dynamic> json) {
    return StoreListModel(
      id: json['id'],
      store_name: json['store_name'],
      location: json['location'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      store_logo: json['store_logo'],
      //store_logo: json['store_logo'] ?? Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
    );
  }

}