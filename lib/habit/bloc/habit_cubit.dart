import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';

class HabitState {
  final List<HabitModel> habits;

  const HabitState({required this.habits});

  HabitState copyWith({List<HabitModel>? habits}) {
    return HabitState(
      habits: habits ?? this.habits,
    );
  }
}

class HabitCubit extends Cubit<HabitState> {
  HabitCubit()
      : super(const HabitState(
          habits: [
            HabitModel(
              id: '1',
              title: 'Deep Work & Coding',
              category: 'Productivity',
              icon: Icons.code,
              streakCount: 18,
              isCompletedToday: true,
              weeklyProgress: [true, true, true, true, true, true, true],
            ),
            HabitModel(
              id: '2',
              title: 'Quantum Physics Reading',
              category: 'Education',
              icon: Icons.menu_book,
              streakCount: 5,
              isCompletedToday: false,
              weeklyProgress: [true, false, true, true, true, false, false],
            ),
            HabitModel(
              id: '3',
              title: 'Gym & Core Strength',
              category: 'Health',
              icon: Icons.fitness_center,
              streakCount: 12,
              isCompletedToday: true,
              weeklyProgress: [true, true, false, true, true, true, true],
            ),
          ],
        ));

  void toggleHabitCompletion(String id) {
    final updatedHabits = state.habits.map((habit) {
      if (habit.id == id) {
        final newStatus = !habit.isCompletedToday;

        // Update 7-day progress list (flips the current day's status)
        List<bool> updatedProgress = List<bool>.from(habit.weeklyProgress);
        if (updatedProgress.isNotEmpty) {
          updatedProgress[updatedProgress.length - 1] = newStatus;
        }

        return habit.copyWith(
          isCompletedToday: newStatus,
          streakCount: newStatus
              ? habit.streakCount + 1
              : (habit.streakCount > 0 ? habit.streakCount - 1 : 0),
          weeklyProgress: updatedProgress,
        );
      }
      return habit;
    }).toList();

    emit(state.copyWith(habits: updatedHabits));
  }

  // Alias for compatibility if called elsewhere as toggleHabit
  void toggleHabit(String id) => toggleHabitCompletion(id);

  void addHabit(HabitModel newHabit) {
    emit(state.copyWith(habits: [...state.habits, newHabit]));
  }
}
