import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HabitModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final IconData icon;
  final int streakCount;
  final bool isCompletedToday;
  final List<bool> weeklyProgress;
  final int defaultTimerMinutes;
  final String? linkedSubscriptionId;
  final String? linkedSubscriptionName;

  const HabitModel({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.streakCount,
    required this.isCompletedToday,
    required this.weeklyProgress,
    this.defaultTimerMinutes = 25,
    this.linkedSubscriptionId,
    this.linkedSubscriptionName,
  });

  HabitModel copyWith({
    String? id,
    String? title,
    String? category,
    IconData? icon,
    int? streakCount,
    bool? isCompletedToday,
    List<bool>? weeklyProgress,
    int? defaultTimerMinutes,
    String? linkedSubscriptionId,
    String? linkedSubscriptionName,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      streakCount: streakCount ?? this.streakCount,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      defaultTimerMinutes: defaultTimerMinutes ?? this.defaultTimerMinutes,
      linkedSubscriptionId: linkedSubscriptionId ?? this.linkedSubscriptionId,
      linkedSubscriptionName:
          linkedSubscriptionName ?? this.linkedSubscriptionName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        icon,
        streakCount,
        isCompletedToday,
        weeklyProgress,
        defaultTimerMinutes,
        linkedSubscriptionId,
        linkedSubscriptionName,
      ];
}