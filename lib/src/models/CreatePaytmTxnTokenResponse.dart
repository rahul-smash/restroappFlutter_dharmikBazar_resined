class CreatePaytmTxnTokenResponse {
  bool success;
  String message;
  String url;

  CreatePaytmTxnTokenResponse({this.success, this.message, this.url});

  CreatePaytmTxnTokenResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['url'] = this.url;
    return data;
  }
}