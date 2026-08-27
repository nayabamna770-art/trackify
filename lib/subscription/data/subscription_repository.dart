import 'package:hive/hive.dart';
import 'package:trackify/core/database/boxes.dart';
import 'package:trackify/subscription/data/models/currency_type.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';

class SubscriptionRepository {
  Box<SubscriptionModel> get _box => Boxes.subscriptionsBox;

  List<SubscriptionModel> fetchInitialSubscriptions() {
    if (_box.isEmpty) {
      _seedDefaultSubscriptions();
    }
    return _box.values.toList();
  }

  Future<void> saveSubscription(SubscriptionModel subscription) async {
    await _box.put(subscription.id, subscription);
  }

  Future<void> saveAllSubscriptions(List<SubscriptionModel> subscriptions) async {
    final map = {for (var sub in subscriptions) sub.id: sub};
    await _box.putAll(map);
  }

  Future<void> deleteSubscription(String id) async {
    await _box.delete(id);
  }

  void _seedDefaultSubscriptions() {
    final now = DateTime.now();
    final defaultSubs = [
      SubscriptionModel(
        id: '1',
        name: 'Spotify Premium',
        cost: 9.99,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: now.add(const Duration(days: 5)),
        currency: CurrencyType.usd,
      ),
      SubscriptionModel(
        id: '2',
        name: 'Netflix',
        cost: 15.49,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: now.add(const Duration(days: 14)),
        currency: CurrencyType.usd,
      ),
    ];

    for (var sub in defaultSubs) {
      _box.put(sub.id, sub);
    }
  }
}