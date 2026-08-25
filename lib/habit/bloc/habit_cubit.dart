import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domains/models/habit_model.dart';
import '../../subscription/logic/subscription_cubit.dart';

class HabitState extends Equatable {
  final List<HabitModel> habits;

  const HabitState({required this.habits});

  @override
  List<Object?> get props => [habits];
}

class HabitCubit extends Cubit<HabitState> {
  final SubscriptionCubit? subscriptionCubit;

  HabitCubit({this.subscriptionCubit})
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
        return habit.copyWith(
          isCompletedToday: newStatus,
          streakCount: newStatus
              ? habit.streakCount + 1
              : (habit.streakCount > 0 ? habit.streakCount - 1 : 0),
        );
      }
      return habit;
    }).toList();

    emit(HabitState(habits: updatedHabits));
    _syncSubscriptions(updatedHabits);
  }

  void addHabit(HabitModel newHabit) {
    final updatedHabits = [...state.habits, newHabit];
    emit(HabitState(habits: updatedHabits));
    _syncSubscriptions(updatedHabits);
  }

  void _syncSubscriptions(List<HabitModel> habits) {
    subscriptionCubit?.syncWithHabits(habits);
  }
}