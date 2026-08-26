import 'package:flutter_bloc/flutter_bloc.dart';
import '../../habit/domains/models/habit_model.dart';
import '../data/models/subscription_model.dart';
import '../data/subscription_repository.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionCubit({required this.repository}) : super(const SubscriptionState()) {
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
    final updatedSubscriptions = state.subscriptions.map((sub) {
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
    emit(state.copyWith(subscriptions: updatedSubscriptions));
  }

  void addSubscription(SubscriptionModel sub) async {
    await repository.saveSubscription(sub);
    final updated = List<SubscriptionModel>.from(state.subscriptions)..add(sub);
    emit(state.copyWith(subscriptions: updated));
  }

  void deleteSubscription(String id) async {
    await repository.deleteSubscription(id);
    final updated = state.subscriptions.where((s) => s.id != id).toList();
    emit(state.copyWith(subscriptions: updated));
  }

  void renewSubscription(SubscriptionModel sub) async {
    final updatedDate = sub.nextBillingDate.add(
      sub.billingCycle == BillingCycle.monthly
          ? const Duration(days: 30)
          : const Duration(days: 365),
    );
    final updated = sub.copyWith(nextBillingDate: updatedDate);

    await repository.saveSubscription(updated);
    final list =
        state.subscriptions.map((s) => s.id == sub.id ? updated : s).toList();
    emit(state.copyWith(subscriptions: list));
  }
}