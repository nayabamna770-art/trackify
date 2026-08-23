import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HabitModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final IconData icon;
  final int streakCount;
  final bool isCompletedToday;
  final List<bool> weeklyProgress; // 7 days status

  const HabitModel({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.streakCount,
    required this.isCompletedToday,
    required this.weeklyProgress,
  });

  HabitModel copyWith({
    String? id,
    String? title,
    String? category,
    IconData? icon,
    int? streakCount,
    bool? isCompletedToday,
    List<bool>? weeklyProgress,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      streakCount: streakCount ?? this.streakCount,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
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
      ];
}