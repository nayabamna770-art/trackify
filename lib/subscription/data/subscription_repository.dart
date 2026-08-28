import 'package:hive/hive.dart';
import 'package:trackify/core/database/boxes.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';

class SubscriptionRepository {
  Box get _box => Boxes.subscriptionsBox;

  List<SubscriptionModel> fetchInitialSubscriptions() {
    return getSubscriptions();
  }

  List<SubscriptionModel> getSubscriptions() {
    final List<SubscriptionModel> subscriptions = [];
    for (final dynamic raw in _box.values) {
      if (raw is Map) {
        try {
          final map = Map<String, dynamic>.from(raw);
          subscriptions.add(SubscriptionModel.fromJson(map));
        } catch (_) {}
      } else if (raw is SubscriptionModel) {
        subscriptions.add(raw);
      }
    }
    return subscriptions;
  }

  Future<void> saveSubscription(SubscriptionModel subscription) async {
    await _box.put(subscription.id, subscription.toJson());
  }

  Future<void> saveAllSubscriptions(List<SubscriptionModel> subscriptions) async {
    final map = {for (var sub in subscriptions) sub.id: sub.toJson()};
    await _box.putAll(map);
  }

  Future<void> deleteSubscription(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAllSubscriptions() async {
    await _box.clear();
  }
}