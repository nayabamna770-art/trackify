import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/services/home_widget_service.dart';
import 'package:trackify/habit/data/habit_repository.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';

/// ============================================================================
/// HABIT STATE
/// ============================================================================
/// Immutable state container holding the list of user habits.
/// Utilizes Equatable to prevent redundant UI rebuilds on identical state emissions.
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

/// ============================================================================
/// HABIT CUBIT (BUSINESS LOGIC LAYER)
/// ============================================================================
/// Manages reactive habit state, streak compounding logic, daily check-ins,
/// and bidirectional synchronization with Android Home Screen Widgets.
class HabitCubit extends Cubit<HabitState> {
  final HabitRepository repository;

  HabitCubit({required this.repository})
      : super(HabitState(habits: repository.getHabits())) {
    // Initial broadcast to sync home screen widgets on app startup
    HomeWidgetService.updateHabitWidget(state.habits);
  }

  /// Reloads habits directly from local Hive storage and updates widgets.
  void loadHabits() {
    final habits = repository.getHabits();
    emit(state.copyWith(habits: habits));
    HomeWidgetService.updateHabitWidget(habits);
  }

  /// Toggles today's completion status for a habit, updates streak counter,
  /// flips weekly progress matrix, saves to Hive, and refreshes the home widget.
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
    HomeWidgetService.updateHabitWidget(updatedHabits);
  }

  /// Convenience alias for toggleHabitCompletion.
  void toggleHabit(String id) => toggleHabitCompletion(id);

  /// Registers a new habit in Hive local storage, emits new state, and updates widgets.
  void addHabit(HabitModel newHabit) {
    repository.saveHabit(newHabit);
    final updatedHabits = [...state.habits, newHabit];
    emit(state.copyWith(habits: updatedHabits));
    HomeWidgetService.updateHabitWidget(updatedHabits);
  }
}