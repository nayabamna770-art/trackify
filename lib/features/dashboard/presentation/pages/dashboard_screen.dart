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
                  child: _HoverPopCard(
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
                ),
                const SizedBox(width: 14),
                // Fiery Streak Badge
                _HoverPopCard(
                  child: GlassContainer(
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
                                color:
                                    Colors.orangeAccent.withValues(alpha: 0.4),
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
            _HoverPopCard(
              child: _buildHabitHeatmapGrid(
                themeState: themeState,
                accentColor: palette.accentPrimary,
                textColor: palette.textPrimary,
              ),
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
  }

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

  Widget _buildHabitHeatmapGrid({
    required ThemeState themeState,
    required Color accentColor,
    required Color textColor,
  }) {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final mockActivity = [
      [3, 4, 2, 4, 1],
      [2, 3, 4, 1, 4],
      [4, 4, 3, 2, 3],
      [1, 2, 4, 4, 2],
      [4, 3, 1, 3, 4],
      [0, 1, 2, 1, 2],
      [2, 2, 3, 4, 3],
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

  Widget _buildSubscriptionHeatmapGrid({
    required ThemeState themeState,
    required Color accentColor,
    required Color textColor,
  }) {
    final activeRenewalDays = {
      5: '\$14',
      14: '\$9.99',
      21: '\$12',
      28: '\$4.99'
    };

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

// --- HOVER WRAPPER FOR MAIN CARDS ---
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

// --- HOVER HEATMAP CELL ---
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
        scale: _isHovered ? 1.4 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: !isFilled
                ? widget.textColor.withValues(alpha: 0.08)
                : widget.accentColor.withValues(alpha: 0.2 * widget.intensity),
            border: Border.all(
              color: isFilled || _isHovered
                  ? widget.accentColor.withValues(alpha: _isHovered ? 1.0 : 0.4)
                  : Colors.transparent,
              width: AppGlassStyle.borderWidth,
            ),
            boxShadow: _isHovered && isFilled
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
        ),
      ),
    );
  }
}

// --- HOVER SUBSCRIPTION CELL ---
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
        scale: _isHovered ? 1.25 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isRenewal
                ? widget.accentColor.withValues(alpha: 0.25)
                : widget.textColor.withValues(alpha: 0.05),
            border: Border.all(
              color: widget.isRenewal || _isHovered
                  ? widget.accentColor.withValues(alpha: _isHovered ? 1.0 : 0.6)
                  : Colors.transparent,
              width: AppGlassStyle.borderWidth,
            ),
            boxShadow: _isHovered && widget.isRenewal
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.7),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.day}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: widget.isRenewal || _isHovered
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: widget.isRenewal || _isHovered
                      ? widget.accentColor
                      : widget.textColor.withValues(alpha: 0.5),
                ),
              ),
              if (widget.isRenewal) ...[
                const SizedBox(height: 1),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.accentColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
