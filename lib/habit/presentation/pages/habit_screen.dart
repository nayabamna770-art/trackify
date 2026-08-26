import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/presentation/widgets/add_habit_bottom_sheet.dart';
import 'package:trackify/habit/presentation/widgets/appreciation_card_dialog.dart';
import 'package:trackify/habit/presentation/widgets/current_task_timer_bottom_sheet.dart';
import 'package:trackify/habit/presentation/widgets/habit_card.dart';

/// Screen displaying active routines, daily task timers, and habit metrics.
class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  /// Displays the modal sheet for adding a new routine/habit.
  void _showAddHabitModal(
      BuildContext context, dynamic palette, double opacity) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Habit',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: AddHabitBottomSheet(
              palette: palette,
              opacity: opacity,
              onSave: (newHabit) {
                context.read<HabitCubit>().addHabit(newHabit);
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// Displays the task countdown timer modal.
  void _showCurrentTaskTimerModal(
      BuildContext context, dynamic palette, double opacity) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Current Task Timer',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: CurrentTaskTimerBottomSheet(
              palette: palette,
              opacity: opacity,
              onTimerComplete: (taskTitle, durationMinutes) {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AppreciationCardDialog(
                    taskTitle: taskTitle,
                    minutes: durationMinutes,
                    palette: palette,
                    opacity: opacity,
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return BlocBuilder<HabitCubit, HabitState>(
          builder: (context, habitState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: ListView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 120,
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Routines',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: palette.textHeading,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Consistency is your compounding edge',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: palette.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          SpringScaleButton(
                            onTap: () => _showCurrentTaskTimerModal(
                                context, palette, themeState.glassOpacity),
                            child: GlassContainer(
                              borderRadius: 14,
                              opacity: themeState.glassOpacity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    color: palette.accentPrimary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Task',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: palette.accentPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SpringScaleButton(
                            onTap: () => _showAddHabitModal(
                                context, palette, themeState.glassOpacity),
                            child: GlassContainer(
                              borderRadius: 14,
                              opacity: themeState.glassOpacity,
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.add,
                                color: palette.accentPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...habitState.habits.map(
                    (habit) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: HabitCard(
                        title: habit.title,
                        category: habit.category,
                        icon: habit.icon,
                        streak: '${habit.streakCount} Day Streak',
                        isCompleted: habit.isCompletedToday,
                        progress: habit.weeklyProgress,
                        onToggleComplete: () {
                          context
                              .read<HabitCubit>()
                              .toggleHabitCompletion(habit.id);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}