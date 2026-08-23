import 'package:equatable/equatable.dart';

/// Core domain entity for recurring subscription tracking
class SubscriptionModel extends Equatable {
  final String id;
  final String name;
  final double cost;
  final String currency;
  final String billingCycle;
  final String? linkedHabitId;
  final bool isUnusedFlagged;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.cost,
    this.currency = '\$',
    this.billingCycle = 'Monthly',
    this.linkedHabitId,
    this.isUnusedFlagged = false,
  });

  SubscriptionModel copyWith({
    String? id,
    String? name,
    double? cost,
    String? currency,
    String? billingCycle,
    String? linkedHabitId,
    bool? isUnusedFlagged,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      linkedHabitId: linkedHabitId ?? this.linkedHabitId,
      isUnusedFlagged: isUnusedFlagged ?? this.isUnusedFlagged,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        cost,
        currency,
        billingCycle,
        linkedHabitId,
        isUnusedFlagged,
      ];
}