import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/habit_repository.dart';
import '../domains/models/habit_model.dart';

/// Immutable state for Habit feature using Equatable for optimized re-renders
class HabitState extends Equatable {
  final List<HabitModel> habits;

  const HabitState({required this.habits});

  HabitState copyWith({List<HabitModel>? habits}) {
    return HabitState(
      habits: habits ?? this.habits,
    );
  }

  @override
  List<Object?> get props => [habits];
}

/// Cubit managing Habit state and delegating persistence to [HabitRepository]
class HabitCubit extends Cubit<HabitState> {
  final HabitRepository repository;

  HabitCubit({required this.repository})
      : super(HabitState(habits: repository.getHabits()));

  /// Reloads habits directly from local storage
  void loadHabits() {
    final habits = repository.getHabits();
    emit(state.copyWith(habits: habits));
  }

  /// Toggles completion for today, updates streaks, and saves to Hive asynchronously
  void toggleHabitCompletion(String id) {
    final updatedHabits = state.habits.map((habit) {
      if (habit.id == id) {
        final newStatus = !habit.isCompletedToday;

        // Update 7-day progress list (flips today's status)
        List<bool> updatedProgress = List<bool>.from(habit.weeklyProgress);
        if (updatedProgress.isNotEmpty) {
          updatedProgress[updatedProgress.length - 1] = newStatus;
        }

        final updatedHabit = habit.copyWith(
          isCompletedToday: newStatus,
          streakCount: newStatus
              ? habit.streakCount + 1
              : (habit.streakCount > 0 ? habit.streakCount - 1 : 0),
          weeklyProgress: updatedProgress,
        );

        // Async write to local Hive database
        repository.saveHabit(updatedHabit);

        return updatedHabit;
      }
      return habit;
    }).toList();

    emit(state.copyWith(habits: updatedHabits));
  }

  /// Alias for toggleHabitCompletion
  void toggleHabit(String id) => toggleHabitCompletion(id);

  /// Adds a new habit to local storage and updates UI state
  void addHabit(HabitModel newHabit) {
    repository.saveHabit(newHabit);
    emit(state.copyWith(habits: [...state.habits, newHabit]));
  }
}