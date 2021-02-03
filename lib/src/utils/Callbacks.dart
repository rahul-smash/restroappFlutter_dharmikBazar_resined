import 'package:event_bus/event_bus.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';

/// The global [EventBus] object.
EventBus eventBus = EventBus();

typedef CustomCallback = T Function<T extends Object>({T value});

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
class onSubscribeProduct {
  Product product;
  String quanity;
  onSubscribeProduct(this.product,this.quanity);
}

class onPayTMPageFinished {
  String url;
  String orderId;
  String txnId;

  onPayTMPageFinished(this.url, this.orderId, this.txnId);
}
