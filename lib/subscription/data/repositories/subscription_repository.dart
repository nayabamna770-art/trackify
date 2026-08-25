import '../models/currency_type.dart';
import '../models/subscription_model.dart';

class SubscriptionRepository {
  List<SubscriptionModel> fetchInitialSubscriptions() {
    return [
      SubscriptionModel(
        id: '1',
        name: 'GitHub Copilot',
        cost: 10.0,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.now().add(const Duration(days: 12)),
        currency: CurrencyType.usd,
        isFreeTrial: false,
        linkedHabitId: '1',
        linkedHabitName: 'Deep Work & Coding',
      ),
      SubscriptionModel(
        id: '2',
        name: 'Coursera Plus',
        cost: 59.0,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.now().add(const Duration(days: 3)),
        currency: CurrencyType.usd,
        isFreeTrial: false,
        linkedHabitId: '2',
        linkedHabitName: 'Quantum Physics Reading',
      ),
      SubscriptionModel(
        id: '3',
        name: 'Fitness App',
        cost: 14.99,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.now().add(const Duration(days: 25)),
        currency: CurrencyType.usd,
        isFreeTrial: true,
        linkedHabitId: '3',
        linkedHabitName: 'Gym & Core Strength',
      ),
    ];
  }
}