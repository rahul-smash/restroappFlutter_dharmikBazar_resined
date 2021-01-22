import 'package:event_bus/event_bus.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';

/// The global [EventBus] object.
EventBus eventBus = EventBus();

class updateCartCount {
  updateCartCount();
}

class refreshOrderHistory {
  refreshOrderHistory();
}

class onPageFinished {
  String url;

  onPageFinished(this.url);
}


class onAddressSelected {
  DeliveryAddressData addressData;
  onAddressSelected(this.addressData);
}

class onPayTMPageFinished {
  String url;
  String orderId;
  String txnId;

  onPayTMPageFinished(this.url, this.orderId, this.txnId);
}
