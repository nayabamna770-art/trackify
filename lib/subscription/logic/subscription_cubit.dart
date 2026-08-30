import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/services/home_widget_service.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';
import 'package:trackify/subscription/data/subscription_repository.dart';
import 'package:trackify/subscription/logic/subscription_state.dart';

/// ============================================================================
/// SUBSCRIPTION CUBIT (BUSINESS LOGIC LAYER)
/// ============================================================================
/// Manages user subscription lifecycle, category filtering (All, Active, Urgent,
/// Habit-linked), underutilization analysis linked with habits, and home widget updates.
class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionCubit({required this.repository})
      : super(const SubscriptionState()) {
    loadSubscriptions();
  }

  /// Loads stored subscriptions from Hive, emits state, and refreshes the home widget
  void loadSubscriptions() {
    final data = repository.fetchInitialSubscriptions();
    emit(state.copyWith(
      subscriptions: data,
      status: SubscriptionStatus.loaded,
    ));
    HomeWidgetService.updateWidgets(subscriptions: data);
  }

  /// Updates active filter category tab (All, Active, Needs Attention, Habit Linked)
  void setFilter(SubscriptionFilter filter) {
    emit(state.copyWith(currentFilter: filter));
  }

  /// Cross-references subscriptions with habit streaks to detect underutilization
  /// (e.g. Gym or LeetCode membership with 0 streak and no check-in today)
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

      // Underutilized if habit has 0 streak and wasn't completed today
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

  /// Saves a new subscription into Hive, reloads fresh state, and updates home widgets
  void addSubscription(SubscriptionModel newSub) async {
    // 1. Persist the new subscription using repository save method
    await repository.saveSubscription(newSub);

    // 2. Fetch fresh list from repository to stay consistent
    final freshData = repository.fetchInitialSubscriptions();

    // 3. Emit updated state with fresh data and sync widget
    emit(state.copyWith(
      subscriptions: freshData,
      status: SubscriptionStatus.loaded,
    ));
    HomeWidgetService.updateWidgets(subscriptions: freshData);
  }

  /// Removes a subscription by ID and refreshes state and home widgets
  void deleteSubscription(String id) async {
    await repository.deleteSubscription(id);
    final freshData = repository.fetchInitialSubscriptions();
    emit(state.copyWith(
      subscriptions: freshData,
      status: SubscriptionStatus.loaded,
    ));
    HomeWidgetService.updateWidgets(subscriptions: freshData);
  }

  /// Advances the next billing date by 1 cycle (30 days for monthly, 365 for yearly)
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
    HomeWidgetService.updateWidgets(subscriptions: freshData);
  }
}
