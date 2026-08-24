import '../models/subscription_model.dart';

/// Abstract contract defining local persistence operations for Subscriptions.
///
/// CONCEPT: Repository pattern decouples business logic (Cubit) from data sources
/// (Hive/Sqflite/Mock Service). Makes unit testing seamless via mocking.
abstract class SubscriptionRepository {
  /// Fetches all stored user subscriptions.
  Future<List<SubscriptionModel>> getSubscriptions();

  /// Adds a new subscription record locally.
  Future<void> addSubscription(SubscriptionModel subscription);

  /// Updates existing subscription details (e.g., renewal date rollover).
  Future<void> updateSubscription(SubscriptionModel subscription);

  /// Removes a subscription record locally.
  Future<void> deleteSubscription(String id);
}

/// In-memory/mock implementation for rapid UI development and testing.
class LocalSubscriptionRepository implements SubscriptionRepository {
  final List<SubscriptionModel> _storage = [
    SubscriptionModel(
      id: 'sub_1',
      name: 'Spotify Premium',
      cost: 9.99,
      nextBillingDate: DateTime.now().add(const Duration(days: 1)),
      reminderDaysBefore: 2,
      linkedHabitId: 'habit_music',
    ),
    SubscriptionModel(
      id: 'sub_2',
      name: 'ChatGPT Plus',
      cost: 20.00,
      nextBillingDate: DateTime.now().add(const Duration(days: 14)),
      isFreeTrial: false,
    ),
    SubscriptionModel(
      id: 'sub_3',
      name: 'Figma Pro (Trial)',
      cost: 15.00,
      nextBillingDate: DateTime.now().add(const Duration(hours: 12)),
      isFreeTrial: true,
      reminderDaysBefore: 1,
    ),
  ];

  @override
  Future<List<SubscriptionModel>> getSubscriptions() async {
    // Simulate slight local disk I/O delay
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_storage);
  }

  @override
  Future<void> addSubscription(SubscriptionModel subscription) async {
    _storage.add(subscription);
  }

  @override
  Future<void> updateSubscription(SubscriptionModel subscription) async {
    final index = _storage.indexWhere((s) => s.id == subscription.id);
    if (index != -1) {
      _storage[index] = subscription;
    }
  }

  @override
  Future<void> deleteSubscription(String id) async {
    _storage.removeWhere((s) => s.id == id);
  }
}
