import 'dart:convert';

class DeviceInfo {
   final Map<String,dynamic> deviceInfo;

  DeviceInfo({
    this.deviceInfo,
  });

  static DeviceInfo _instance;

  static DeviceInfo getInstance({deviceInfo}) {
    if (_instance == null) {
      _instance = DeviceInfo(deviceInfo: deviceInfo);
      return _instance;
    }
    return _instance;
  }
   String getInfo(){
    return jsonEncode(deviceInfo);
  }

}
