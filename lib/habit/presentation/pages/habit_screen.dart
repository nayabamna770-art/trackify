import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/constants/app_glass_style.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/habit/presentation/pages/configure_habit_screen.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  // Local state list to hold newly created active habits instantly
  final List<Map<String, dynamic>> _userHabits = [];

  // Directly navigate to ConfigureHabitScreen, bypassing the redundant welcome screen
  Future<void> _navigateToConfigureHabit(BuildContext context) async {
    final newHabitData = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigureHabitScreen(),
      ),
    );

    // If data is returned, update the state so it immediately appears as an active card
    if (newHabitData != null) {
      setState(() {
        _userHabits.add(newHabitData);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully created "${newHabitData['name']}"!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

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
          body: _userHabits.isEmpty
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
                  itemCount: _userHabits.length,
                  itemBuilder: (context, index) {
                    final habit = _userHabits[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141A26),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: palette.accentPrimary.withValues(alpha: 0.4),
                          width: AppGlassStyle.borderWidth,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: palette.accentPrimary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.star_rounded,
                              color: palette.accentPrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  habit['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: palette.textHeading,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  habit['description']?.isNotEmpty == true
                                      ? habit['description']
                                      : 'No description provided',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildBadge(
                                      habit['type'] ?? 'General',
                                      palette.accentPrimary,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildBadge(
                                      habit['goalPeriod'] ?? 'Day-Long',
                                      Colors.blueAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: _userHabits.isNotEmpty
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
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}