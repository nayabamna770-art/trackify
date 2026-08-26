import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/database/boxes.dart';
import '../domains/models/habit_model.dart';

class HabitRepository {
  Box get _box => Boxes.habitsBox;

  List<HabitModel> getHabits() {
    if (_box.isEmpty) {
      _seedDefaultHabits();
    }
    return _box.values.cast<HabitModel>().toList();
  }

  Future<void> saveHabit(HabitModel habit) async {
    await _box.put(habit.id, habit);
  }

  Future<void> saveAllHabits(List<HabitModel> habits) async {
    final Map<String, HabitModel> habitMap = {
      for (var habit in habits) habit.id: habit
    };
    await _box.putAll(habitMap);
  }

  Future<void> deleteHabit(String id) async {
    await _box.delete(id);
  }

  void _seedDefaultHabits() {
    final defaultHabits = [
      HabitModel(
        id: '1',
        title: 'Deep Work & Coding',
        category: 'Productivity',
        icon: Icons.code,
        streakCount: 18,
        isCompletedToday: true,
        weeklyProgress: const [true, true, true, true, true, true, true],
      ),
      HabitModel(
        id: '2',
        title: 'Quantum Physics Reading',
        category: 'Education',
        icon: Icons.menu_book,
        streakCount: 5,
        isCompletedToday: false,
        weeklyProgress: const [true, false, true, true, true, false, false],
      ),
      HabitModel(
        id: '3',
        title: 'Gym & Core Strength',
        category: 'Health',
        icon: Icons.fitness_center,
        streakCount: 12,
        isCompletedToday: true,
        weeklyProgress: const [true, true, false, true, true, true, true],
      ),
    ];

    for (var habit in defaultHabits) {
      _box.put(habit.id, habit);
    }
  }
}