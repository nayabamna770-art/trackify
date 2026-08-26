import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/habit_repository.dart';
import '../domains/models/habit_model.dart';

/// Immutable state container for the Habit feature utilizing Equatable
/// to prevent unnecessary UI rebuilds.
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

/// Cubit managing Habit state business rules and coordinating with [HabitRepository].
class HabitCubit extends Cubit<HabitState> {
  final HabitRepository repository;

  HabitCubit({required this.repository})
      : super(HabitState(habits: repository.getHabits()));

  /// Reloads habits directly from local storage sync bounds.
  void loadHabits() {
    final habits = repository.getHabits();
    emit(state.copyWith(habits: habits));
  }

  /// Toggles completion status for today, updates weekly matrix, adjusts streaks, 
  /// and persists changes to the local storage adapter.
  void toggleHabitCompletion(String id) {
    final updatedHabits = state.habits.map((habit) {
      if (habit.id == id) {
        final newStatus = !habit.isCompletedToday;

        // Clone and map weekly progress list update (flips index for current evaluation)
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

        // Commit change asynchronously to local storage
        repository.saveHabit(updatedHabit);

        return updatedHabit;
      }
      return habit;
    }).toList();

    emit(state.copyWith(habits: updatedHabits));
  }

  /// Convenience alias for toggleHabitCompletion.
  void toggleHabit(String id) => toggleHabitCompletion(id);

  /// Registers a new habit entry inside local storage and publishes the updated list state.
  void addHabit(HabitModel newHabit) {
    repository.saveHabit(newHabit);
    emit(state.copyWith(habits: [...state.habits, newHabit]));
  }
}