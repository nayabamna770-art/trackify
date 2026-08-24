import 'package:equatable/equatable.dart';
import 'currency_type.dart';

/// Billing frequency options for tracked subscriptions.
enum BillingCycle { monthly, yearly }

/// Model representing a single user-managed subscription.
///
/// CONCEPT: Extends [Equatable] to allow deep equality comparisons in BLoC/Cubit,
/// preventing unnecessary UI rebuilds when state emission occurs.
class SubscriptionModel extends Equatable {
  final String id;
  final String name;
  final double cost;
  final CurrencyType currency;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final bool isFreeTrial;
  final int reminderDaysBefore;
  final String? linkedHabitId;
  final bool isActive;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.cost,
    this.currency = CurrencyType.usd,
    this.billingCycle = BillingCycle.monthly,
    required this.nextBillingDate,
    this.isFreeTrial = false,
    this.reminderDaysBefore = 1,
    this.linkedHabitId,
    this.isActive = true,
  });

  /// Calculates exact whole days remaining until renewal/trial expiration.
  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
      nextBillingDate.year,
      nextBillingDate.month,
      nextBillingDate.day,
    );
    return target.difference(today).inDays;
  }

  /// Flags subscriptions requiring urgent attention (e.g. within reminder window).
  bool get needsAttention {
    return isActive && daysRemaining <= reminderDaysBefore;
  }

  /// Determines if a subscription is currently linked to an active Habit streak.
  bool get hasLinkedHabit => linkedHabitId != null && linkedHabitId!.isNotEmpty;

  /// Utility to copy and modify instances immutably.
  SubscriptionModel copyWith({
    String? id,
    String? name,
    double? cost,
    CurrencyType? currency,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    bool? isFreeTrial,
    int? reminderDaysBefore,
    String? linkedHabitId,
    bool? isActive,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      isFreeTrial: isFreeTrial ?? this.isFreeTrial,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
      linkedHabitId: linkedHabitId ?? this.linkedHabitId,
      isActive: isActive ?? this.isActive,
    );
  }

  /// JSON Deserialization for local storage (e.g., Hive / SharedPreferences / Sqflite).
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      cost: (json['cost'] as num).toDouble(),
      currency: CurrencyType.values.firstWhere(
        (e) => e.name == json['currency'],
        orElse: () => CurrencyType.usd,
      ),
      billingCycle: BillingCycle.values.firstWhere(
        (e) => e.name == json['billingCycle'],
        orElse: () => BillingCycle.monthly,
      ),
      nextBillingDate: DateTime.parse(json['nextBillingDate'] as String),
      isFreeTrial: json['isFreeTrial'] as bool? ?? false,
      reminderDaysBefore: json['reminderDaysBefore'] as int? ?? 1,
      linkedHabitId: json['linkedHabitId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// JSON Serialization for local storage persistence.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'currency': currency.name,
      'billingCycle': billingCycle.name,
      'nextBillingDate': nextBillingDate.toIso8601String(),
      'isFreeTrial': isFreeTrial,
      'reminderDaysBefore': reminderDaysBefore,
      'linkedHabitId': linkedHabitId,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        cost,
        currency,
        billingCycle,
        nextBillingDate,
        isFreeTrial,
        reminderDaysBefore,
        linkedHabitId,
        isActive,
      ];
}
