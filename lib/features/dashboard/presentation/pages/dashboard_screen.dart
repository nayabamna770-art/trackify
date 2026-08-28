import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:trackify/app/constants/app_glass_style.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/core/widgets/theme_selection_bottom_sheet.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';
import 'package:trackify/habit/presentation/pages/configure_habit_screen.dart';
import 'package:trackify/settings/presentation/pages/setting_screen.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';
import 'package:trackify/subscription/data/repositories/subscription_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ConfettiController _confettiController;
  String _userName = 'Explorer';
  List<SubscriptionModel> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final profileBox = await Hive.openBox('user_profile_box');
      final name = profileBox.get('user_name', defaultValue: 'Friend');
      final subs = SubscriptionRepository().fetchInitialSubscriptions();
      if (mounted) {
        setState(() {
          _userName = name;
          _subscriptions = subs;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAllCompletedCelebration(List<HabitModel> habits, String toggledHabitId) {
    // Find what the new state will be after toggle
    final willBeAllCompleted = habits.every((h) {
      if (h.id == toggledHabitId) {
        return !h.isCompletedToday;
      }
      return h.isCompletedToday;
    });

    if (willBeAllCompleted && habits.isNotEmpty) {
      _confettiController.play();
      HapticFeedback.heavyImpact();
      _showMotivationalCelebrationDialog();
    }
  }

  void _showMotivationalCelebrationDialog() {
    final themeState = context.read<ThemeCubit>().state;
    final palette = themeState.currentPalette;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              child: GlassContainer(
                borderRadius: 24,
                opacity: 0.3,
                padding: const EdgeInsets.all(24),
                accentGlowColor: palette.accentPrimary,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: palette.accentPrimary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: palette.accentPrimary,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        size: 44,
                        color: palette.accentPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Flawless Execution! 🔥',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: palette.textHeading,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You conquered 100% of your daily routines today. "Small daily disciplines lead to massive long-term compound success." Keep that streak burning!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: palette.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SpringScaleButton(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: palette.accentPrimary,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: palette.accentPrimary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Keep Crushing It!',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openThemeBottomSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const ThemeSelectionBottomSheet(),
    );
  }

  void _openSettingsScreen(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return BlocBuilder<HabitCubit, HabitState>(
          builder: (context, habitState) {
            final habits = habitState.habits;
            final isExistingUser = habits.isNotEmpty;

            final List<Map<String, String>> commonHabits = [
              {'name': 'Walk / Exercise', 'quote': 'Stay active, stay sharp', 'type': 'Health'},
              {'name': 'Coding / Focus Work', 'quote': 'Build consistency', 'type': 'Productivity'},
              {'name': 'Documentation / Reading', 'quote': 'Knowledge compounds', 'type': 'Education'},
            ];

            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  children: [
                    // --- TOP UTILITY ROW: THEME PALETTE + SETTINGS BUTTONS ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TRACKIFY',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                            color: palette.accentPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            // Theme Palette Button
                            _HoverPopCard(
                              child: GlassContainer(
                                padding: const EdgeInsets.all(4),
                                borderRadius: 14,
                                opacity: themeState.glassOpacity,
                                accentGlowColor: palette.accentPrimary,
                                child: IconButton(
                                  icon: Icon(Icons.palette_rounded, color: palette.accentPrimary, size: 20),
                                  tooltip: 'Change Theme Palette',
                                  onPressed: () => _openThemeBottomSheet(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Settings Button
                            _HoverPopCard(
                              child: GlassContainer(
                                padding: const EdgeInsets.all(4),
                                borderRadius: 14,
                                opacity: themeState.glassOpacity,
                                accentGlowColor: palette.accentPrimary,
                                child: IconButton(
                                  icon: Icon(Icons.settings_rounded, color: palette.textHeading, size: 20),
                                  tooltip: 'Open Settings',
                                  onPressed: () => _openSettingsScreen(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // --- TOP ROW: WELCOME CARD WITH USER NAME ---
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
                              isExistingUser ? 'DAILY MOMENTUM' : 'GETTING STARTED',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: palette.accentPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isExistingUser ? 'Welcome Back, $_userName! 😊' : 'Welcome, $_userName! 👋',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: palette.textHeading,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isExistingUser
                                  ? 'Track your habits below and maintain your consistency streak.'
                                  : 'Start by choosing or creating your initial daily routines below.',
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

                    // ==========================================
                    // DUAL STATE SECTION:
                    // New User -> Common Habits (+)
                    // Existing User -> Mark Progress [✓] / [O]
                    // ==========================================
                    if (!isExistingUser) ...[
                      // --- NEW USER: COMMON HABITS ---
                      _buildSectionHeader(
                        title: 'Common Habits',
                        subtitle: 'Tap (+) to customize and activate your habits',
                        icon: Icons.track_changes_rounded,
                        accentColor: palette.accentPrimary,
                        headingColor: palette.textHeading,
                      ),
                      const SizedBox(height: 12),
                      ...commonHabits.map((habit) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: _HoverPopCard(
                              child: GlassContainer(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                borderRadius: 18,
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
                                            color: palette.textPrimary.withValues(alpha: 0.7),
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
                                        size: 28,
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
                    ] else ...[
                      // --- EXISTING USER: MARK PROGRESS CHECKLIST ---
                      _buildSectionHeader(
                        title: 'Mark Progress',
                        subtitle: 'Quickly check in your active daily routines',
                        icon: Icons.checklist_rounded,
                        accentColor: palette.accentPrimary,
                        headingColor: palette.textHeading,
                      ),
                      const SizedBox(height: 12),
                      ...habits.map((habit) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _HoverPopCard(
                            child: GlassContainer(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              borderRadius: 18,
                              opacity: themeState.glassOpacity,
                              accentGlowColor: habit.isCompletedToday
                                  ? palette.accentPrimary
                                  : Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: palette.accentPrimary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            _getHabitIcon(habit.category),
                                            color: palette.accentPrimary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                habit.name,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  decoration: habit.isCompletedToday
                                                      ? TextDecoration.lineThrough
                                                      : TextDecoration.none,
                                                  decorationColor: palette.accentPrimary,
                                                  color: habit.isCompletedToday
                                                      ? palette.textHeading.withValues(alpha: 0.6)
                                                      : palette.textHeading,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: const Color(0xFFFF2A85),
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${habit.streakCount} day streak',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: palette.textPrimary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _checkAllCompletedCelebration(habits, habit.id);
                                      context.read<HabitCubit>().toggleHabitCompletion(habit.id);
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: habit.isCompletedToday
                                            ? palette.accentPrimary
                                            : Colors.white.withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: habit.isCompletedToday
                                              ? palette.accentPrimary
                                              : Colors.white.withValues(alpha: 0.25),
                                          width: 2.0,
                                        ),
                                      ),
                                      child: habit.isCompletedToday
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 22,
                                              color: Colors.black,
                                            )
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 24),

                    // ==========================================
                    // SECTION: GITHUB CONTRIBUTION GRAPH (HABIT + SUBSCRIPTION)
                    // ==========================================
                    _buildSectionHeader(
                      title: 'GitHub Graph (Habit + Subscription)',
                      subtitle: 'Multi-week completion & renewal activity matrix',
                      icon: Icons.grid_on_rounded,
                      accentColor: palette.accentPrimary,
                      headingColor: palette.textHeading,
                    ),
                    const SizedBox(height: 12),
                    _HoverPopCard(
                      child: _buildGithubContributionMatrix(
                        themeState: themeState,
                        accentColor: palette.accentPrimary,
                        secondaryColor: palette.accentSecondary,
                        textColor: palette.textPrimary,
                        habits: habits,
                        subscriptions: _subscriptions,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==========================================
                    // SECTION: GITHUB PERFORMANCE CHARTS (SHOWING PERFORMANCE)
                    // ==========================================
                    _buildSectionHeader(
                      title: 'Performance & Consistency Charts',
                      subtitle: 'Momentum metrics & routine completion rates',
                      icon: Icons.insights_rounded,
                      accentColor: palette.accentSecondary,
                      headingColor: palette.textHeading,
                    ),
                    const SizedBox(height: 12),
                    _HoverPopCard(
                      child: _buildPerformanceChartCard(
                        themeState: themeState,
                        accentColor: palette.accentPrimary,
                        secondaryColor: palette.accentSecondary,
                        textColor: palette.textPrimary,
                        headingColor: palette.textHeading,
                        habits: habits,
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),

                // Full-Screen Confetti Overlay
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    numberOfParticles: 40,
                    maxBlastForce: 30,
                    minBlastForce: 10,
                    emissionFrequency: 0.05,
                    gravity: 0.15,
                    colors: [
                      palette.accentPrimary,
                      palette.accentSecondary,
                      Colors.amber,
                      Colors.white,
                      const Color(0xFFFF2A85),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  IconData _getHabitIcon(String category) {
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

  /// Builds the GitHub-style contribution matrix showing habits + subscription renewal markers
  Widget _buildGithubContributionMatrix({
    required ThemeState themeState,
    required Color accentColor,
    required Color secondaryColor,
    required Color textColor,
    required List<HabitModel> habits,
    required List<SubscriptionModel> subscriptions,
  }) {
    const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Map subscription renewals to days (1..28)
    final Set<int> renewalDays = subscriptions
        .map((s) => s.nextBillingDate.day)
        .toSet();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
          width: AppGlassStyle.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Matrix',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
              Row(
                children: [
                  _buildLegendIndicator('Habit Complete', accentColor),
                  const SizedBox(width: 10),
                  _buildLegendIndicator('Renewal', secondaryColor),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(daysOfWeek.length, (rowIndex) {
            int completedForDay = 0;
            for (var h in habits) {
              if (rowIndex < h.weeklyProgress.length && h.weeklyProgress[rowIndex]) {
                completedForDay++;
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                      children: List.generate(6, (colIndex) {
                        final isCurrentWeek = colIndex == 5;
                        final intensity = isCurrentWeek
                            ? completedForDay
                            : (completedForDay > 0 && (colIndex + rowIndex) % 2 == 0 ? 1 : 0);

                        final cellDay = (rowIndex * 4 + colIndex + 1);
                        final hasRenewal = renewalDays.contains(cellDay);

                        return _HoverGithubCell(
                          intensity: intensity,
                          hasRenewal: hasRenewal,
                          accentColor: accentColor,
                          secondaryColor: secondaryColor,
                          textColor: textColor,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegendIndicator(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white60),
        ),
      ],
    );
  }

  /// Builds the Performance Analytics & Consistency Score Card
  Widget _buildPerformanceChartCard({
    required ThemeState themeState,
    required Color accentColor,
    required Color secondaryColor,
    required Color textColor,
    required Color headingColor,
    required List<HabitModel> habits,
  }) {
    final totalHabits = habits.length;
    final completedCount = habits.where((h) => h.isCompletedToday).length;
    final completionRate = totalHabits > 0 ? (completedCount / totalHabits) : 0.0;
    final maxStreak = habits.isNotEmpty
        ? habits.map((h) => h.streakCount).reduce((a, b) => a > b ? a : b)
        : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: secondaryColor.withValues(alpha: 0.25),
          width: AppGlassStyle.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAILY COMPLETION RATE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(completionRate * 100).round()}% Completed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: headingColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: secondaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: secondaryColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department_rounded, color: const Color(0xFFFF2A85), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$maxStreak Days Best',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: headingColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Visual Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionRate,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
          const SizedBox(height: 18),

          // Micro performance column indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Total Routines', '$totalHabits', textColor, headingColor),
              Container(width: 1, height: 28, color: Colors.white12),
              _buildStatColumn('Completed Today', '$completedCount', accentColor, headingColor),
              Container(width: 1, height: 28, color: Colors.white12),
              _buildStatColumn('Pending', '${totalHabits - completedCount}', textColor, headingColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor, Color headingColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: headingColor.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

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

class _HoverGithubCell extends StatefulWidget {
  final int intensity;
  final bool hasRenewal;
  final Color accentColor;
  final Color secondaryColor;
  final Color textColor;

  const _HoverGithubCell({
    required this.intensity,
    required this.hasRenewal,
    required this.accentColor,
    required this.secondaryColor,
    required this.textColor,
  });

  @override
  State<_HoverGithubCell> createState() => _HoverGithubCellState();
}

class _HoverGithubCellState extends State<_HoverGithubCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.intensity > 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.35 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isFilled
                ? widget.accentColor.withValues(alpha: 0.25 * widget.intensity.clamp(1, 4))
                : (widget.hasRenewal
                    ? widget.secondaryColor.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.04)),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor
                  : (widget.hasRenewal
                      ? widget.secondaryColor.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.1)),
              width: widget.hasRenewal ? 1.5 : AppGlassStyle.borderWidth,
            ),
          ),
          child: widget.hasRenewal
              ? Center(
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: widget.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

