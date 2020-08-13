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
  String url, _orderId, _txnId;
  onPageFinished(this.url);
  onPayTMPageFinished(this.url, this._orderId, this._txnId);
}
