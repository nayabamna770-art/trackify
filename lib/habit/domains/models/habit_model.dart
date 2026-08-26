import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final int iconCodePoint;

  @HiveField(4)
  final String? iconFontFamily;

  @HiveField(5)
  final String iconName;

  @HiveField(6)
  final int streakCount;

  @HiveField(7)
  final bool isCompletedToday;

  @HiveField(8)
  final List<bool> weeklyProgress;

  @HiveField(9)
  final List<String> completionDates;

  @HiveField(10)
  final int defaultTimerMinutes;

  @HiveField(11)
  final String? linkedSubscriptionId;

  @HiveField(12)
  final String? linkedSubscriptionName;

  HabitModel({
    required this.id,
    required this.title,
    required this.category,
    IconData? icon,
    int? iconCodePoint,
    this.iconFontFamily,
    this.iconName = 'check',
    this.streakCount = 0,
    this.isCompletedToday = false,
    List<bool>? weeklyProgress,
    List<String>? completionDates,
    this.defaultTimerMinutes = 25,
    this.linkedSubscriptionId,
    this.linkedSubscriptionName,
  })  : iconCodePoint =
            iconCodePoint ?? (icon?.codePoint ?? Icons.check.codePoint),
        weeklyProgress = weeklyProgress ??
            const [false, false, false, false, false, false, false],
        completionDates = completionDates ?? const [];

  IconData get icon {
    final int code = iconCodePoint;
    final String family = iconFontFamily ?? 'MaterialIcons';
    return IconData(code, fontFamily: family);
  }

  int get targetDurationMinutes => defaultTimerMinutes;

  HabitModel copyWith({
    String? id,
    String? title,
    String? category,
    IconData? icon,
    int? iconCodePoint,
    String? iconFontFamily,
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
      iconCodePoint:
          iconCodePoint ?? (icon != null ? icon.codePoint : this.iconCodePoint),
      iconFontFamily: iconFontFamily ??
          (icon != null ? icon.fontFamily : this.iconFontFamily),
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
        iconCodePoint,
        iconFontFamily,
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
