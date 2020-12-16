import 'package:event_bus/event_bus.dart';

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

class onPayTMPageFinished {
  String url;
  String orderId;
  String txnId;

  onPayTMPageFinished(this.url, this.orderId, this.txnId);
}
