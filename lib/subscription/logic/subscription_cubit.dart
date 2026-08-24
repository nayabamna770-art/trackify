import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/subscription_model.dart';
import '../data/repositories/subscription_repository.dart';
import 'subscription_state.dart';

/// Cubit managing subscription actions: loading, creating, renewing, deleting, and filtering.
///
/// CONCEPT: State operations remain immutable and predictive. State changes propagate
/// automatically to both the Subscription list and Dashboard indicators.
class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionCubit({required this.repository}) : super(const SubscriptionState());

  /// Loads stored subscriptions from the local repository.
  Future<void> loadSubscriptions() async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    try {
      final data = await repository.getSubscriptions();
      emit(state.copyWith(
        status: SubscriptionStatus.loaded,
        subscriptions: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SubscriptionStatus.error,
        errorMessage: 'Failed to load subscriptions: ${e.toString()}',
      ));
    }
  }

  /// Sets the active UI category filter pill.
  void setFilter(SubscriptionFilter filter) {
    emit(state.copyWith(currentFilter: filter));
  }

  /// Adds a new subscription to the system.
  Future<void> addSubscription(SubscriptionModel sub) async {
    try {
      await repository.addSubscription(sub);
      final updatedList = List<SubscriptionModel>.from(state.subscriptions)..add(sub);
      emit(state.copyWith(subscriptions: updatedList));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add subscription.'));
    }
  }

  /// One-Tap Quick Renew: Rollovers next billing date by 1 cycle (Month or Year).
  Future<void> renewSubscription(SubscriptionModel sub) async {
    final DateTime currentBilling = sub.nextBillingDate;
    final DateTime nextDate = sub.billingCycle == BillingCycle.monthly
        ? DateTime(currentBilling.year, currentBilling.month + 1, currentBilling.day)
        : DateTime(currentBilling.year + 1, currentBilling.month, currentBilling.day);

    final updatedSub = sub.copyWith(
      nextBillingDate: nextDate,
      isFreeTrial: false, // Converted to paid active status on manual renewal
    );

    try {
      await repository.updateSubscription(updatedSub);
      final updatedList = state.subscriptions.map((s) {
        return s.id == sub.id ? updatedSub : s;
      }).toList();
      emit(state.copyWith(subscriptions: updatedList));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to renew subscription.'));
    }
  }

  /// Deletes or cancels a subscription locally.
  Future<void> deleteSubscription(String id) async {
    try {
      await repository.deleteSubscription(id);
      final updatedList = state.subscriptions.where((s) => s.id != id).toList();
      emit(state.copyWith(subscriptions: updatedList));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to delete subscription.'));
    }
  }
}