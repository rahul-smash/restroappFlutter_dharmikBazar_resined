class StoreDeliveryAreasResponse {
  bool success;
  List<StoreArea> areas;

  StoreDeliveryAreasResponse({
    this.success,
    this.areas,
  });

  factory StoreDeliveryAreasResponse.fromJson(Map<String, dynamic> json) =>
      StoreDeliveryAreasResponse(
        success: json["success"],
        areas: json["data"] == null
            ? null
            : List<StoreArea>.from(
                json["data"].map((x) => StoreArea.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
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
