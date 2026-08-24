import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';
import 'package:trackify/habit/presentation/widgets/add_habit_bottom_sheet.dart';
import 'package:trackify/habit/presentation/widgets/appreciation_card_dialog.dart';
import 'package:trackify/habit/presentation/widgets/current_task_timer_bottom_sheet.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

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
        ));
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
                      Column(
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
                            style: TextStyle(
                              fontSize: 13,
                              color: palette.textPrimary,
                            ),
                          ),
                        ],
                      ),
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
                      child: _HabitCardWidget(
                        habit: habit,
                        palette: palette,
                        opacity: themeState.glassOpacity,
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

class _HabitCardWidget extends StatelessWidget {
  final HabitModel habit;
  final dynamic palette;
  final double opacity;

  const _HabitCardWidget({
    required this.habit,
    required this.palette,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return SpringScaleButton(
      onTap: () {},
      child: GlassContainer(
        borderRadius: 20,
        opacity: opacity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: palette.accentPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        habit.icon,
                        color: palette.accentPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: palette.textHeading,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              habit.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                                color: palette.accentPrimary,
                              ),
                            ),
                            if (habit.linkedSubscriptionName != null) ...[
                              Text(
                                ' • ${habit.linkedSubscriptionName}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: palette.textPrimary
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.read<HabitCubit>().toggleHabitCompletion(habit.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: habit.isCompletedToday
                          ? palette.accentPrimary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: habit.isCompletedToday
                            ? palette.accentPrimary
                            : palette.textPrimary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: habit.isCompletedToday
                        ? const Icon(Icons.check, size: 18, color: Colors.black)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.whatshot,
                        size: 16, color: palette.accentSecondary),
                    const SizedBox(width: 6),
                    Text(
                      '${habit.streakCount} Day Streak',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: habit.weeklyProgress.map((done) {
                    return Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done
                            ? palette.accentPrimary
                            : palette.textPrimary.withValues(alpha: 0.2),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
