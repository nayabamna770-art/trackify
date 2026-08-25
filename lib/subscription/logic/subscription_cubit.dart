import 'package:flutter_bloc/flutter_bloc.dart';

///ort '../../habit/domains/models/habit_model.dart';
import '../data/models/subscription_model.dart';
import '../data/repositories/subscription_repository.dart';
import 'subscription_state.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository? repository;

  SubscriptionCubit({this.repository}) : super(const SubscriptionState());

  void loadSubscriptions() {
    if (repository != null) {
      final initialData = repository!.fetchInitialSubscriptions();
      emit(state.copyWith(
        subscriptions: initialData,
        status: SubscriptionStatus.loaded,
      ));
    }
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

    emit(state.copyWith(subscriptions: updatedSubscriptions));
  }

  void addSubscription(SubscriptionModel sub) {
    final updated = List<SubscriptionModel>.from(state.subscriptions)..add(sub);
    emit(state.copyWith(subscriptions: updated));
  }

  void deleteSubscription(String id) {
    final updated = state.subscriptions.where((s) => s.id != id).toList();
    emit(state.copyWith(subscriptions: updated));
  }

  void renewSubscription(SubscriptionModel sub) {
    final updatedDate = sub.nextBillingDate.add(
      sub.billingCycle == BillingCycle.monthly
          ? const Duration(days: 30)
          : const Duration(days: 365),
    );
    final updated = sub.copyWith(nextBillingDate: updatedDate);

    final list =
        state.subscriptions.map((s) => s.id == sub.id ? updated : s).toList();
    emit(state.copyWith(subscriptions: list));
  }
}
