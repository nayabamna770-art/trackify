import 'package:hive/hive.dart';
import 'package:trackify/core/database/boxes.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';

/// ============================================================================
/// HABIT REPOSITORY (DATA LAYER)
/// ============================================================================
/// Manages CRUD operations for Habit entities in Hive using pure JSON Map
/// serialization. This decouples models from rigid binary adapters.
class HabitRepository {
  /// Reference to the underlying generic Hive box
  Box get _box => Boxes.habitsBox;

  /// Fetches all stored habits from Hive, parsing raw Map entries via fromJson.
  /// Returns an empty list for new users — no seeding — so the dashboard
  /// correctly shows the new-user Common Habits suggestion screen.
  List<HabitModel> getHabits() {
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

  /// Persists or updates a single Habit entity as a JSON map.
  Future<void> saveHabit(HabitModel habit) async {
    await _box.put(habit.id, habit.toJson());
  }

  /// Bulk saves a list of Habit entities.
  Future<void> saveAllHabits(List<HabitModel> habits) async {
    final Map<String, dynamic> habitMap = {
      for (var habit in habits) habit.id: habit.toJson()
    };
    await _box.putAll(habitMap);
  }

  /// Deletes a habit by its unique ID.
  Future<void> deleteHabit(String id) async {
    await _box.delete(id);
  }
}
