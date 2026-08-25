import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Unified Habit entity supporting UI rendering, timer, streaks, 
/// and subscription ROI linking.
class HabitModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final IconData icon;
  final String iconName;
  final int streakCount;
  final bool isCompletedToday;
  final List<bool> weeklyProgress;
  final List<String> completionDates;
  final int defaultTimerMinutes;
  final String? linkedSubscriptionId;
  final String? linkedSubscriptionName;

  const HabitModel({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    this.iconName = 'check',
    this.streakCount = 0,
    this.isCompletedToday = false,
    this.weeklyProgress = const [false, false, false, false, false, false, false],
    this.completionDates = const [],
    this.defaultTimerMinutes = 25,
    this.linkedSubscriptionId,
    this.linkedSubscriptionName,
  });

  /// Convenient getter for backward compatibility with target duration references
  int get targetDurationMinutes => defaultTimerMinutes;

  HabitModel copyWith({
    String? id,
    String? title,
    String? category,
    IconData? icon,
    String? iconName,
    int? streakCount,
    bool? isCompletedToday,
    List<bool>? weeklyProgress,
    List<String>? completionDates,
    int? defaultTimerMinutes,
    String? linkedSubscriptionId,
    String? linkedSubscriptionName,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      iconName: iconName ?? this.iconName,
      streakCount: streakCount ?? this.streakCount,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      completionDates: completionDates ?? this.completionDates,
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
        iconName,
        streakCount,
        isCompletedToday,
        weeklyProgress,
        completionDates,
        defaultTimerMinutes,
        linkedSubscriptionId,
        linkedSubscriptionName,
      ];
}