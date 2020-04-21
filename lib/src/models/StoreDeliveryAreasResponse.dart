class StoreDeliveryAreasResponse {
  bool success;
  List<StoreArea> areas;
  String message;

  StoreDeliveryAreasResponse({
    this.success,
    this.areas,
    this.message,
  });

  factory StoreDeliveryAreasResponse.fromJson(Map<String, dynamic> json) =>
      StoreDeliveryAreasResponse(
        success: json["success"],
        message: json["message"],
        areas: json["data"] == null? null: List<StoreArea>.from(json["data"].map((x) => StoreArea.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(areas.map((x) => x.toJson())),
      };
}

class StoreArea {
  String id;
  String areaName;

  StoreArea({
    this.id,
    this.areaName,
  });

  factory StoreArea.fromJson(Map<String, dynamic> json) => StoreArea(
        id: json["id"],
        areaName: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "area": areaName,
      };
}
