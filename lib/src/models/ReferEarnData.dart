class ReferEarnData {
  bool isRefererFnEnable;
  ReferEarn referEarn;
  bool status;
  String userReferCode;

  ReferEarnData(
      {this.isRefererFnEnable,
        this.referEarn,
        this.status,
        this.userReferCode});

  ReferEarnData.fromJson(Map<String, dynamic> json) {
    isRefererFnEnable = json['is_referer_fn_enable'];
    referEarn = json['ReferEarn'] != null
        ? new ReferEarn.fromJson(json['ReferEarn'])
        : null;
    status = json['status'];
    userReferCode = json['user_refer_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_referer_fn_enable'] = this.isRefererFnEnable;
    if (this.referEarn != null) {
      data['ReferEarn'] = this.referEarn.toJson();
    }
    data['status'] = this.status;
    data['user_refer_code'] = this.userReferCode;
    return data;
  }
}

class ReferEarn {
  String id;
  String sharedMessage;
  bool blDeviceIdUnique;

  ReferEarn({this.id, this.sharedMessage, this.blDeviceIdUnique});

  ReferEarn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sharedMessage = json['shared_message'];
    blDeviceIdUnique = json['bl_device_id_unique'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shared_message'] = this.sharedMessage;
    data['bl_device_id_unique'] = this.blDeviceIdUnique;
    return data;
  }
}