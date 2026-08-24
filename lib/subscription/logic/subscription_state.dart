import 'package:equatable/equatable.dart';
import '../data/models/subscription_model.dart';

/// Available UI filters for the Subscription screen list.
enum SubscriptionFilter { all, active, needsAttention, habitLinked }

enum SubscriptionStatus { initial, loading, loaded, error }

/// State class representing the UI state of the Subscription screen.
///
/// CONCEPT: Sealed state fields allow us to derive sub-metrics (like monthly spend,
/// active warnings, and habit linkage count) on the fly without redundant state triggers.
class SubscriptionState extends Equatable {
  final SubscriptionStatus status;
  final List<SubscriptionModel> subscriptions;
  final SubscriptionFilter currentFilter;
  final String? errorMessage;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.subscriptions = const [],
    this.currentFilter = SubscriptionFilter.all,
    this.errorMessage,
  });

  /// Filters subscriptions based on the currently selected filter pill.
  List<SubscriptionModel> get filteredSubscriptions {
    switch (currentFilter) {
      case SubscriptionFilter.all:
        return subscriptions;
      case SubscriptionFilter.active:
        return subscriptions.where((s) => s.isActive).toList();
      case SubscriptionFilter.needsAttention:
        return subscriptions.where((s) => s.needsAttention).toList();
      case SubscriptionFilter.habitLinked:
        return subscriptions.where((s) => s.hasLinkedHabit).toList();
    }
  }

  /// Calculates total monthly expenditure normalized across billing cycles.
  double get totalMonthlyExpense {
    return subscriptions.where((s) => s.isActive).fold(0.0, (total, sub) {
      if (sub.billingCycle == BillingCycle.yearly) {
        return total + (sub.cost / 12);
      }
      return total + sub.cost;
    });
  }

  /// Count of subscriptions that need immediate attention or renewal.
  int get attentionCount {
    return subscriptions.where((s) => s.needsAttention).length;
  }

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    List<SubscriptionModel>? subscriptions,
    SubscriptionFilter? currentFilter,
    String? errorMessage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      currentFilter: currentFilter ?? this.currentFilter,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, subscriptions, currentFilter, errorMessage];
}