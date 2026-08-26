import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'currency_type.dart';

part '../subscription_adapter.g.dart';

@HiveType(typeId: 2)
enum BillingCycle {
  @HiveField(0)
  monthly,
  @HiveField(1)
  yearly;

  String get name => toString().split('.').last;
}

@HiveType(typeId: 1)
class SubscriptionModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double cost;

  @HiveField(3)
  final BillingCycle billingCycle;

  @HiveField(4)
  final DateTime nextBillingDate;

  @HiveField(5)
  final CurrencyType currency;

  @HiveField(6)
  final bool isFreeTrial;

  @HiveField(7)
  final String? linkedHabitId;

  @HiveField(8)
  final String? linkedHabitName;

  @HiveField(9)
  final bool isUnderutilized;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.billingCycle,
    required this.nextBillingDate,
    this.currency = CurrencyType.usd,
    this.isFreeTrial = false,
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