import 'package:rxdart/rxdart.dart';

mixin SubscriptionHolder {
  final CompositeSubscription subscriptions = CompositeSubscription();

  void disposeSubscriptions() {
    subscriptions.clear();
  }
}
