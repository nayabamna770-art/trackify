import 'package:equatable/equatable.dart';

/// Core domain entity for daily habit tracking
class HabitModel extends Equatable {
  final String id;
  final String title;
  final String iconName;
  final int targetDurationMinutes;
  final bool isCompletedToday;
  final int currentStreak;
  final List<String> completionDates;
  final String? linkedSubscriptionId;

  const HabitModel({
    required this.id,
    required this.title,
    required this.iconName,
    this.targetDurationMinutes = 30,
    this.isCompletedToday = false,
    this.currentStreak = 0,
    this.completionDates = const [],
    this.linkedSubscriptionId,
  });

  HabitModel copyWith({
    String? id,
    String? title,
    String? iconName,
    int? targetDurationMinutes,
    bool? isCompletedToday,
    int? currentStreak,
    List<String>? completionDates,
    String? linkedSubscriptionId,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      iconName: iconName ?? this.iconName,
      targetDurationMinutes: targetDurationMinutes ?? this.targetDurationMinutes,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      currentStreak: currentStreak ?? this.currentStreak,
      completionDates: completionDates ?? this.completionDates,
      linkedSubscriptionId: linkedSubscriptionId ?? this.linkedSubscriptionId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        iconName,
        targetDurationMinutes,
        isCompletedToday,
        currentStreak,
        completionDates,
        linkedSubscriptionId,
      ];
}