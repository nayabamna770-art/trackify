// Import standard Flutter material design package for layout and widget creation
import 'package:flutter/material.dart';
// Import Flutter BLoC package to listen to application state changes reactively
import 'package:flutter_bloc/flutter_bloc.dart';
// Import global glass design styling constants (such as border widths)
import 'package:trackify/app/constants/app_glass_style.dart';
// Import ThemeCubit to manage dynamic theme switching and color palette properties
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
// Import reusable glassmorphism container wrapper for cards and widgets
import 'package:trackify/core/widgets/glass_container.dart';
// Import the settings screen destination for top utility navigation
import 'package:trackify/settings/presentation/pages/setting_screen.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';
import 'package:trackify/habit/presentation/pages/configure_habit_screen.dart';

/// DashboardScreen is the primary landing screen displaying the user's daily overview,
/// common habits, solid activity heatmaps, and subscription renewal matrix.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to ThemeCubit to rebuild the dashboard when the active theme palette updates
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        // Extract the active theme's custom color palette
        final palette = themeState.currentPalette;

        return BlocBuilder<HabitCubit, HabitState>(
          builder: (context, habitState) {
            final habits = habitState.habits;

            // Common habit items for universal student/professional utility
            final List<Map<String, String>> commonHabits = [
              {'name': 'Walk / Exercise', 'quote': 'Stay active, stay sharp'},
              {'name': 'Coding / Focus Work', 'quote': 'Build consistency'},
              {'name': 'Documentation / Reading', 'quote': 'Knowledge compounds'},
            ];

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              children: [
            // --- TOP UTILITY ROW: SETTINGS ACTION BUTTON ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _HoverPopCard(
                  child: GlassContainer(
                    padding: const EdgeInsets.all(4),
                    borderRadius: 16,
                    opacity: themeState.glassOpacity,
                    accentGlowColor: palette.accentPrimary,
                    child: IconButton(
                      icon: Icon(Icons.settings, color: palette.textHeading),
                      tooltip: 'Open Settings',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // --- TOP ROW: WELCOME CARD WITH NAME & SMILE EMOJI ---
            _HoverPopCard(
              child: GlassContainer(
                padding: const EdgeInsets.all(20),
                borderRadius: 24,
                opacity: themeState.glassOpacity,
                accentGlowColor: palette.accentPrimary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAILY OVERVIEW',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: palette.accentPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Welcome Back, Nayab! 😊',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: palette.textHeading,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Let us build great momentum today.',
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.textPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- SECTION: COMMON HABITS ---
            _buildSectionHeader(
              title: 'Common Habits',
              subtitle: 'Tap (+) to customize and activate your habits',
              icon: Icons.track_changes_rounded,
              accentColor: palette.accentPrimary,
              headingColor: palette.textHeading,
            ),
            const SizedBox(height: 12),

            // Compact habit cards mapped dynamically with '+' navigation to SettingHabitScreen
            ...commonHabits.map((habit) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _HoverPopCard(
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      borderRadius: 16,
                      opacity: themeState.glassOpacity,
                      accentGlowColor: palette.accentPrimary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit['name']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: palette.textHeading,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                habit['quote']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: palette.textPrimary
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.add_circle_outline_rounded,
                                color: palette.accentPrimary,
                                size: 26,
                              ),
                              tooltip: 'Configure Habit',
                              onPressed: () async {
                                final newHabit = await Navigator.push<HabitModel>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConfigureHabitScreen(
                                      initialHabitName: habit['name']!,
                                    ),
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
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),

              const SizedBox(height: 18),

              // --- SECTION 1: HABIT CONSISTENCY HEATMAP (SOLID DARK CONTAINER) ---
              _buildSectionHeader(
                title: 'Habit Consistency Heatmap',
                subtitle: 'Track your daily completion progress',
                icon: Icons.grid_on_rounded,
                accentColor: palette.accentPrimary,
                headingColor: palette.textHeading,
              ),
              const SizedBox(height: 12),
              _HoverPopCard(
                child: _buildHabitHeatmapGrid(
                  themeState: themeState,
                  accentColor: palette.accentPrimary,
                  textColor: palette.textPrimary,
                  habits: habits,
                ),
              ),

              const SizedBox(height: 28),

              // --- SECTION 2: SUBSCRIPTION & BILLING CYCLE MATRIX (SOLID DARK CONTAINER) ---
              _buildSectionHeader(
                title: 'Subscription Renewals',
                subtitle: 'Active monthly billing schedule',
                icon: Icons.calendar_view_month_rounded,
                accentColor: palette.accentSecondary,
                headingColor: palette.textHeading,
              ),
              const SizedBox(height: 12),
              _HoverPopCard(
                child: _buildSubscriptionHeatmapGrid(
                  themeState: themeState,
                  accentColor: palette.accentSecondary,
                  textColor: palette.textPrimary,
                ),
              ),

              const SizedBox(height: 100),
            ],
          );
        },
      );
    },
  );
}

  /// Helper method to construct unified section headers
  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required Color headingColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: accentColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: headingColor,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: headingColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the habit consistency heatmap grid on a solid dark background for new users
  Widget _buildHabitHeatmapGrid({
    required ThemeState themeState,
    required Color accentColor,
    required Color textColor,
    required List<HabitModel> habits,
  }) {
    const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Colors.black.withValues(alpha: 0.45), // Solid dark base container
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
          width: AppGlassStyle.borderWidth,
        ),
      ),
      child: Column(
        children: List.generate(daysOfWeek.length, (rowIndex) {
          // Calculate intensity from active habits
          int completedHabitsForDay = 0;
          for (var habit in habits) {
            if (rowIndex < habit.weeklyProgress.length && habit.weeklyProgress[rowIndex]) {
              completedHabitsForDay++;
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    daysOfWeek[rowIndex],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (colIndex) {
                      // Column 4 is the current week's active day calculation
                      final intensity = colIndex == 4 ? completedHabitsForDay : (completedHabitsForDay > 0 && colIndex % 2 == 0 ? 1 : 0);
                      return _HoverHeatmapCell(
                        intensity: intensity,
                        accentColor: accentColor,
                        textColor: textColor,
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Builds the monthly subscription calendar grid on a solid dark background
  Widget _buildSubscriptionHeatmapGrid({
    required ThemeState themeState,
    required Color accentColor,
    required Color textColor,
  }) {
    // Empty map initially for a new user setting up subscriptions
    const Map<int, String> activeRenewalDays = {};

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Colors.black.withValues(alpha: 0.45), // Solid dark base container
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
          width: AppGlassStyle.borderWidth,
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 28,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isRenewal = activeRenewalDays.containsKey(day);

          return _HoverSubscriptionCell(
            day: day,
            isRenewal: isRenewal,
            accentColor: accentColor,
            textColor: textColor,
          );
        },
      ),
    );
  }
}

/// Reusable interactive wrapper card that applies smooth scale pop effect on hover
class _HoverPopCard extends StatefulWidget {
  final Widget child;
  const _HoverPopCard({required this.child});

  @override
  State<_HoverPopCard> createState() => _HoverPopCardState();
}

class _HoverPopCardState extends State<_HoverPopCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// Individual heatmap cell inside the habit consistency grid (empty boxes for new user)
class _HoverHeatmapCell extends StatefulWidget {
  final int intensity;
  final Color accentColor;
  final Color textColor;

  const _HoverHeatmapCell({
    required this.intensity,
    required this.accentColor,
    required this.textColor,
  });

  @override
  State<_HoverHeatmapCell> createState() => _HoverHeatmapCellState();
}

class _HoverHeatmapCellState extends State<_HoverHeatmapCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.intensity > 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: !isFilled
                ? Colors.white
                    .withValues(alpha: 0.04) // Clear, dark empty box appearance
                : widget.accentColor.withValues(alpha: 0.2 * widget.intensity),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor
                  : Colors.white.withValues(alpha: 0.1),
              width: AppGlassStyle.borderWidth,
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual calendar grid cell representing a day for a new user
class _HoverSubscriptionCell extends StatefulWidget {
  final int day;
  final bool isRenewal;
  final Color accentColor;
  final Color textColor;

  const _HoverSubscriptionCell({
    required this.day,
    required this.isRenewal,
    required this.accentColor,
    required this.textColor,
  });

  @override
  State<_HoverSubscriptionCell> createState() => _HoverSubscriptionCellState();
}

class _HoverSubscriptionCellState extends State<_HoverSubscriptionCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isRenewal
                ? widget.accentColor.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.03), // Clear, dark empty box
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor
                  : Colors.white.withValues(alpha: 0.08),
              width: AppGlassStyle.borderWidth,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.day}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal,
                  color: _isHovered
                      ? widget.accentColor
                      : widget.textColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
