import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  void _showAddHabitBottomSheet(
      BuildContext context, dynamic palette, double opacity) {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          child: GlassContainer(
            borderRadius: 24,
            opacity: opacity,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Habit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: palette.textHeading,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  style: TextStyle(color: palette.textHeading),
                  decoration: InputDecoration(
                    labelText: 'Habit Title',
                    labelStyle: TextStyle(color: palette.textPrimary),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: palette.textPrimary.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: palette.accentPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  style: TextStyle(color: palette.textHeading),
                  decoration: InputDecoration(
                    labelText: 'Category (e.g., Productivity, Health)',
                    labelStyle: TextStyle(color: palette.textPrimary),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: palette.textPrimary.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: palette.accentPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.accentPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty) {
                        final newHabit = HabitModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text.trim(),
                          category: categoryController.text.trim().isEmpty
                              ? 'General'
                              : categoryController.text.trim(),
                          icon: Icons.check_circle_outline,
                          streakCount: 0,
                          isCompletedToday: false,
                          weeklyProgress: const [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ],
                        );
                        context.read<HabitCubit>().addHabit(newHabit);
                        Navigator.pop(bottomSheetContext);
                      }
                    },
                    child: const Text(
                      'Save Habit',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                  bottom: 120, // Avoid overlapping with bottom navbar
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
                            onTap: () => _showAddHabitBottomSheet(
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
                          const SizedBox(width: 8),
                          GlassContainer(
                            borderRadius: 14,
                            opacity: themeState.glassOpacity,
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.local_fire_department,
                              color: palette.accentSecondary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...habitState.habits.map((habit) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _HabitCardWidget(
                          habit: habit,
                          palette: palette,
                          opacity: themeState.glassOpacity,
                        ),
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _HabitCardWidget extends StatefulWidget {
  final HabitModel habit;
  final dynamic palette;
  final double opacity;

  const _HabitCardWidget({
    required this.habit,
    required this.palette,
    required this.opacity,
  });

  @override
  State<_HabitCardWidget> createState() => _HabitCardWidgetState();
}

class _HabitCardWidgetState extends State<_HabitCardWidget> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.97);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final palette = widget.palette;

    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: GlassContainer(
          borderRadius: 20,
          opacity: widget.opacity,
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
                          Text(
                            habit.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              color: palette.accentPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context
                          .read<HabitCubit>()
                          .toggleHabitCompletion(habit.id);
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
                          ? const Icon(Icons.check,
                              size: 18, color: Colors.black)
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
      ),
    );
  }
}