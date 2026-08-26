// Import core Flutter material packages
import 'package:flutter/material.dart';
// Import flutter_bloc for state management providers and builders
import 'package:flutter_bloc/flutter_bloc.dart';
// Import theme management cubit and states
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
// Import custom reusable UI components for glassmorphism and navigation
import 'package:trackify/core/widgets/floating_frosted_navbar.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/glow_orb.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/core/widgets/theme_selection_bottom_sheet.dart';
// Import feature screens linked via the bottom shell navigation
import 'package:trackify/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/data/habit_repository.dart';
import 'package:trackify/habit/presentation/pages/habit_screen.dart';
import 'package:trackify/settings/presentation/pages/setting_screen.dart';
import 'package:trackify/subscription/presentation/pages/subscription_screen.dart';

/// MainScreenShell acts as the wrapper widget that injects global blocs (like HabitCubit)
/// and provides the persistent bottom navigation shell structure for core app screens.
class MainScreenShell extends StatelessWidget {
  const MainScreenShell({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide HabitCubit globally across the sub-screens wrapped inside this shell
    return BlocProvider(
      create: (context) => HabitCubit(repository: HabitRepository())..loadHabits(),
      child: const _MainScreenShellView(),
    );
  }
}

class _MainScreenShellView extends StatefulWidget {
  const _MainScreenShellView();

  @override
  State<_MainScreenShellView> createState() => _MainScreenShellViewState();
}

class _MainScreenShellViewState extends State<_MainScreenShellView> {
  // Tracks the currently selected index for bottom navigation tab switching
  int _currentIndex = 0;

  // List of root screens accessible via the frosted navigation bar
  final List<Widget> _pages = const [
    DashboardScreen(),
    HabitsScreen(),
    SubscriptionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Fetch device media query details to calculate safe padding offsets
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomInset = mediaQuery.padding.bottom + 90;

    // Listen to theme state changes to dynamically adapt glassmorphism and colors
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return Scaffold(
          body: Stack(
            children: [
              // Decorative background glowing orb positioned at the top right
              Positioned(
                top: -60,
                right: -40,
                child: GlowOrb(
                  size: 300,
                  color: palette.accentPrimary,
                  opacity: 0.35,
                ),
              ),
              // Decorative background glowing orb positioned at the bottom left
              Positioned(
                bottom: 80,
                left: -50,
                child: GlowOrb(
                  size: 280,
                  color: palette.accentSecondary,
                  opacity: 0.30,
                ),
              ),
              // Main layout padding containing the top bar header and IndexedStack body
              Padding(
                padding: EdgeInsets.only(top: topPadding, bottom: bottomInset),
                child: Column(
                  children: [
                    // Top App Bar Header Row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Greeting text column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back 👋',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: palette.textPrimary
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Trackify',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: palette.textHeading,
                                ),
                              ),
                            ],
                          ),
                          // Action buttons row (Theme Switcher and Settings shortcut)
                          Row(
                            children: [
                              // Palette theme selector button with spring scaling animation
                              SpringScaleButton(
                                onTap: () {
                                  final themeCubit = context.read<ThemeCubit>();
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (sheetContext) {
                                      return BlocProvider.value(
                                        value: themeCubit,
                                        child:
                                            const ThemeSelectionBottomSheet(),
                                      );
                                    },
                                  );
                                },
                                child: GlassContainer(
                                  padding: const EdgeInsets.all(10),
                                  borderRadius: 14,
                                  opacity: themeState.glassOpacity,
                                  child: Icon(
                                    Icons.palette_outlined,
                                    color: palette.accentPrimary,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Settings screen navigation button
                              SpringScaleButton(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SettingsScreen(),
                                    ),
                                  );
                                },
                                child: GlassContainer(
                                  padding: const EdgeInsets.all(10),
                                  borderRadius: 14,
                                  opacity: themeState.glassOpacity,
                                  child: Icon(
                                    Icons.settings_outlined,
                                    color: palette.textHeading,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Body content area preserving widget state across tabs using IndexedStack
                    Expanded(
                      child: IndexedStack(
                        index: _currentIndex,
                        children: _pages,
                      ),
                    ),
                  ],
                ),
              ),
              // Floating frosted navigation bar pinned at the bottom center
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingFrostedNavbar(
                  currentIndex: _currentIndex,
                  glassOpacity: themeState.glassOpacity,
                  activeColor: palette.accentPrimary,
                  inactiveColor: palette.textPrimary.withValues(alpha: 0.6),
                  items: const [
                    {'icon': Icons.grid_view_rounded, 'label': 'Dashboard'},
                    {'icon': Icons.repeat_rounded, 'label': 'Habits'},
                    {'icon': Icons.card_membership_rounded, 'label': 'Subscriptions'},
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}