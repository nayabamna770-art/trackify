import 'package:hive/hive.dart';
import 'package:trackify/core/database/boxes.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';

class HabitRepository {
  Box get _box => Boxes.habitsBox;

  List<HabitModel> getHabits() {
    if (_box.isEmpty) {
      _seedDefaultHabits();
    }
    final List<HabitModel> habits = [];
    for (var value in _box.values) {
      if (value is Map) {
        habits.add(HabitModel.fromJson(Map<String, dynamic>.from(value)));
      } else if (value is HabitModel) {
        habits.add(value);
      }
    }
    return habits;
  }

  Future<void> saveHabit(HabitModel habit) async {
    await _box.put(habit.id, habit.toJson());
  }

  Future<void> saveAllHabits(List<HabitModel> habits) async {
    final Map<String, dynamic> habitMap = {
      for (var habit in habits) habit.id: habit.toJson()
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
        name: 'Deep Work & Coding',
        category: 'Productivity',
        streak: 18,
        isCompletedToday: true,
        type: 'productivity',
        weeklyProgress: const [true, true, true, true, true, true, true],
      ),
      HabitModel(
        id: '2',
        name: 'Quantum Physics Reading',
        category: 'Education',
        streak: 5,
        isCompletedToday: false,
        type: 'education',
        weeklyProgress: const [true, false, true, true, true, false, false],
      ),
      HabitModel(
        id: '3',
        name: 'Gym & Core Strength',
        category: 'Health',
        streak: 12,
        isCompletedToday: true,
        type: 'health',
        weeklyProgress: const [true, true, false, true, true, true, true],
      ),
    ];

    for (var habit in defaultHabits) {
      _box.put(habit.id, habit.toJson());
    }
  }
}
