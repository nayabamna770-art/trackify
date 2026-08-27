import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/constants/app_glass_style.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';
import 'package:trackify/habit/presentation/pages/configure_habit_screen.dart';
import 'package:trackify/habit/presentation/widgets/habit_card.dart';

class HabitScreen extends StatelessWidget {
  const HabitScreen({super.key});

  Future<void> _navigateToConfigureHabit(BuildContext context) async {
    final newHabit = await Navigator.push<HabitModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigureHabitScreen(),
      ),
    );

    if (newHabit != null && context.mounted) {
      context.read<HabitCubit>().addHabit(newHabit);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully created "${newHabit.name}"!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'productivity':
        return Icons.code_rounded;
      case 'education':
        return Icons.menu_book_rounded;
      case 'health':
        return Icons.fitness_center_rounded;
      case 'fitness':
        return Icons.directions_run_rounded;
      case 'mindfulness':
        return Icons.self_improvement_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return BlocBuilder<HabitCubit, HabitState>(
          builder: (context, habitState) {
            final habits = habitState.habits;

            return Scaffold(
              backgroundColor: const Color(0xFF0B0F17),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Habits Dashboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: palette.textHeading,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.add_rounded, color: palette.accentPrimary),
                    onPressed: () => _navigateToConfigureHabit(context),
                    tooltip: 'Add New Habit',
                  ),
                ],
              ),
              body: habits.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: palette.accentPrimary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: palette.accentPrimary.withValues(alpha: 0.3),
                                  width: AppGlassStyle.borderWidth,
                                ),
                              ),
                              child: Icon(
                                Icons.track_changes_rounded,
                                size: 48,
                                color: palette.accentPrimary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No Active Routines',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap the button below to configure and track your first habit instantly.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: palette.accentPrimary,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                              onPressed: () => _navigateToConfigureHabit(context),
                              icon: const Icon(Icons.add_rounded),
                              label: const Text(
                                'Add New Habit',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20.0),
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: HabitCard(
                            title: habit.name,
                            category: habit.category,
                            icon: _getCategoryIcon(habit.category),
                            streak: '${habit.streakCount} Day Streak',
                            isCompleted: habit.isCompletedToday,
                            progress: habit.weeklyProgress,
                            onToggleComplete: () {
                              context.read<HabitCubit>().toggleHabitCompletion(habit.id);
                            },
                          ),
                        );
                      },
                    ),
              floatingActionButton: habits.isNotEmpty
                  ? FloatingActionButton(
                      backgroundColor: palette.accentPrimary,
                      foregroundColor: Colors.black,
                      onPressed: () => _navigateToConfigureHabit(context),
                      child: const Icon(Icons.add_rounded, size: 28),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}