import 'package:equatable/equatable.dart';
import 'currency_type.dart';

enum BillingCycle {
  monthly,
  yearly;

  String get name => toString().split('.').last;
}

class SubscriptionModel extends Equatable {
  final String id;
  final String name;
  final double cost;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final CurrencyType currency;
  final bool isFreeTrial; // Added field
  final String? linkedHabitId;
  final String? linkedHabitName;
  final bool isUnderutilized;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.billingCycle,
    required this.nextBillingDate,
    this.currency = CurrencyType.usd,
    this.isFreeTrial = false, // Added named parameter
    this.linkedHabitId,
    this.linkedHabitName,
    this.isUnderutilized = false,
  });

  int get daysRemaining => nextBillingDate.difference(DateTime.now()).inDays;

  bool get isActive => daysRemaining > 0;

  bool get needsAttention => daysRemaining <= 7;

  bool get hasLinkedHabit => linkedHabitId != null && linkedHabitId!.isNotEmpty;

  SubscriptionModel copyWith({
    String? id,
    String? name,
    double? cost,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    CurrencyType? currency,
    bool? isFreeTrial,
    String? linkedHabitId,
    String? linkedHabitName,
    bool? isUnderutilized,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      currency: currency ?? this.currency,
      isFreeTrial: isFreeTrial ?? this.isFreeTrial,
      linkedHabitId: linkedHabitId ?? this.linkedHabitId,
      linkedHabitName: linkedHabitName ?? this.linkedHabitName,
      isUnderutilized: isUnderutilized ?? this.isUnderutilized,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        cost,
        billingCycle,
        nextBillingDate,
        currency,
        isFreeTrial,
        linkedHabitId,
        linkedHabitName,
        isUnderutilized,
      ];
}