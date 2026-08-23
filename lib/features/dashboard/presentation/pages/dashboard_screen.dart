import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/constants/app_glass_style.dart';
import 'package:trackify/core/theme/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          children: [
            // --- TOP ROW: WELCOME & FIERY STREAK BADGE ---
            Row(
              children: [
                Expanded(
                  child: GlassContainer(
                    padding: const EdgeInsets.all(18),
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
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: palette.textHeading,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You are on a roll this week.',
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textPrimary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Fiery Streak Badge
                GlassContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  borderRadius: 24,
                  opacity: themeState.glassOpacity + 0.05,
                  accentGlowColor: Colors.orangeAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orangeAccent.withValues(alpha: 0.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orangeAccent.withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.orangeAccent,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '18',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: palette.textHeading,
                        ),
                      ),
                      Text(
                        'Days Streak',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- SECTION 1: HABIT COMMITMENT HEATMAP ---
            _buildSectionHeader(
              title: 'Habit Consistency Heatmap',
              subtitle: 'Daily completion activity by weekday',
              icon: Icons.grid_on_rounded,
              accentColor: palette.accentPrimary,
              headingColor: palette.textHeading,
            ),
            const SizedBox(height: 12),
            _buildHabitHeatmapGrid(
              themeState: themeState,
              accentColor: palette.accentPrimary,
              textColor: palette.textPrimary,
            ),

            const SizedBox(height: 28),

            // --- SECTION 2: SUBSCRIPTION & BILLING CYCLE MATRIX ---
            _buildSectionHeader(
              title: 'Subscription Renewals',
              subtitle: 'Monthly billing timeline overview',
              icon: Icons.calendar_view_month_rounded,
              accentColor: palette.accentSecondary,
              headingColor: palette.textHeading,
            ),
            const SizedBox(height: 12),
            _buildSubscriptionHeatmapGrid(
              themeState: themeState,
              accentColor: palette.accentSecondary,
              textColor: palette.textPrimary,
            ),

            const SizedBox(height: 100), // Space for floating bottom navbar
          ],
        );
      },
    );
  }

  // Section Title Widget
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
                color: headingColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- HABIT HEATMAP (Weekdays Mon - Sun) ---
  Widget _buildHabitHeatmapGrid({
    required ThemeState themeState,
    required Color accentColor,
    required Color textColor,
  }) {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Mock completion density (0 to 4 intensity)
    final mockActivity = [
      [3, 4, 2, 4, 1], // Mon
      [2, 3, 4, 1, 4], // Tue
      [4, 4, 3, 2, 3], // Wed
      [1, 2, 4, 4, 2], // Thu
      [4, 3, 1, 3, 4], // Fri
      [0, 1, 2, 1, 2], // Sat
      [2, 2, 3, 4, 3], // Sun
    ];

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      opacity: themeState.glassOpacity,
      child: Column(
        children: List.generate(daysOfWeek.length, (rowIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    daysOfWeek[rowIndex],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (colIndex) {
                      final intensity = mockActivity[rowIndex][colIndex];
                      return Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: intensity == 0
                              ? textColor.withValues(alpha: 0.08)
                              : accentColor.withValues(alpha: 0.2 * intensity),
                          border: Border.all(
                            color: intensity > 0
                                ? accentColor.withValues(alpha: 0.4)
                                : Colors.transparent,
                            width: AppGlassStyle.borderWidth,
                          ),
                        ),
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

  // --- SUBSCRIPTION HEATMAP (Monthly Day Matrix) ---
  Widget _buildSubscriptionHeatmapGrid({
    required ThemeState themeState,
    required Color accentColor,
    required Color textColor,
  }) {
    // Mock days with upcoming renewals (e.g. Day 5, Day 14, Day 21, Day 28)
    final activeRenewalDays = {5: '\$14', 14: '\$9.99', 21: '\$12', 28: '\$4.99'};

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      opacity: themeState.glassOpacity,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 28, // 4 weeks representation
        itemBuilder: (context, index) {
          final day = index + 1;
          final isRenewal = activeRenewalDays.containsKey(day);

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isRenewal
                  ? accentColor.withValues(alpha: 0.25)
                  : textColor.withValues(alpha: 0.05),
              border: Border.all(
                color: isRenewal
                    ? accentColor.withValues(alpha: 0.6)
                    : Colors.transparent,
                width: AppGlassStyle.borderWidth,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isRenewal ? FontWeight.bold : FontWeight.normal,
                    color: isRenewal ? accentColor : textColor.withValues(alpha: 0.5),
                  ),
                ),
                if (isRenewal) ...[
                  const SizedBox(height: 1),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}