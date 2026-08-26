import 'package:flutter_bloc/flutter_bloc.dart';
import '../../habit/domains/models/habit_model.dart';
import '../data/models/subscription_model.dart';
import '../data/subscription_repository.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionCubit({required this.repository})
      : super(const SubscriptionState()) {
    loadSubscriptions();
  }

  void loadSubscriptions() {
    final data = repository.fetchInitialSubscriptions();
    emit(state.copyWith(
      subscriptions: data,
      status: SubscriptionStatus.loaded,
    ));
  }

  void setFilter(SubscriptionFilter filter) {
    emit(state.copyWith(currentFilter: filter));
  }

  void syncWithHabits(List<HabitModel> habits) {
    final currentSubscriptions = repository.fetchInitialSubscriptions();
    final updatedSubscriptions = currentSubscriptions.map((sub) {
      if (!sub.hasLinkedHabit) return sub;

      HabitModel? matchingHabit;
      for (final h in habits) {
        if (h.id == sub.linkedHabitId) {
          matchingHabit = h;
          break;
        }
      }

      if (matchingHabit == null) return sub;

      final isLowUsage =
          matchingHabit.streakCount == 0 && !matchingHabit.isCompletedToday;

      return sub.copyWith(
        linkedHabitName: matchingHabit.title,
        isUnderutilized: isLowUsage,
      );
    }).toList();

    repository.saveAllSubscriptions(updatedSubscriptions);
    emit(state.copyWith(
      subscriptions: updatedSubscriptions,
      status: SubscriptionStatus.loaded,
    ));
  }

  void addSubscription(SubscriptionModel newSub) async {
    // 1. Persist the new subscription using your repository save method
    await repository.saveSubscription(newSub);

    // 2. Fetch fresh list from repository to stay consistent with delete/renew logic
    final freshData = repository.fetchInitialSubscriptions();

    // 3. Emit updated state with fresh data
    emit(state.copyWith(
      subscriptions: freshData,
      status: SubscriptionStatus.loaded,
    ));
  }

  void deleteSubscription(String id) async {
    await repository.deleteSubscription(id);
    final freshData = repository.fetchInitialSubscriptions();
    emit(state.copyWith(
      subscriptions: freshData,
      status: SubscriptionStatus.loaded,
    ));
  }

  void renewSubscription(SubscriptionModel sub) async {
    final updatedDate = sub.nextBillingDate.add(
      sub.billingCycle == BillingCycle.monthly
          ? const Duration(days: 30)
          : const Duration(days: 365),
    );
    final updated = sub.copyWith(nextBillingDate: updatedDate);

    await repository.saveSubscription(updated);
    final freshData = repository.fetchInitialSubscriptions();
    emit(state.copyWith(
      subscriptions: freshData,
      status: SubscriptionStatus.loaded,
    ));
  }
}
