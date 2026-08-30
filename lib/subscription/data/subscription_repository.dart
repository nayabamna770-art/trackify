import 'package:hive/hive.dart';
import 'package:trackify/core/database/boxes.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';

/// ============================================================================
/// SUBSCRIPTION REPOSITORY (DATA LAYER)
/// ============================================================================
/// Manages persistence and retrieval of user subscriptions via Hive JSON Map
/// serialization. Starts with an empty list for new users with zero pre-seeding.
class SubscriptionRepository {
  /// Reference to generic Hive storage box for subscriptions
  Box get _box => Boxes.subscriptionsBox;

  /// Fetches the initial list of subscriptions on app startup
  List<SubscriptionModel> fetchInitialSubscriptions() {
    return getSubscriptions();
  }

  /// Parses all raw Map objects stored in Hive into strongly-typed SubscriptionModel list
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

  /// Persists a new or updated subscription as a JSON Map
  Future<void> saveSubscription(SubscriptionModel subscription) async {
    await _box.put(subscription.id, subscription.toJson());
  }

  /// Bulk saves multiple subscriptions to Hive
  Future<void> saveAllSubscriptions(List<SubscriptionModel> subscriptions) async {
    final map = {for (var sub in subscriptions) sub.id: sub.toJson()};
    await _box.putAll(map);
  }

  /// Deletes a subscription by unique ID
  Future<void> deleteSubscription(String id) async {
    await _box.delete(id);
  }

  /// Clears all subscriptions from Hive storage (used during Data Reset)
  Future<void> clearAllSubscriptions() async {
    await _box.clear();
  }
}