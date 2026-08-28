import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/services/home_widget_service.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:trackify/habit/presentation/pages/habit_screen.dart';
import 'package:trackify/subscription/presentation/pages/subscription_screen.dart';

class MainScreenShell extends StatefulWidget {
  const MainScreenShell({super.key});

  @override
  State<MainScreenShell> createState() => _MainScreenShellState();
}

class _MainScreenShellState extends State<MainScreenShell> {
  int _currentIndex = 0;
  StreamSubscription<Uri?>? _widgetClickSubscription;

  // Persistent shell screens
  final List<Widget> _screens = [
    const DashboardScreen(),
    const HabitScreen(),
    const SubscriptionScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _handleWidgetLaunch();
  }

  Future<void> _handleWidgetLaunch() async {
    // 1. Initial launch from home widget
    final initialUri = await HomeWidgetService.getInitiallyLaunchedUri();
    if (initialUri != null && mounted) {
      setState(() => _currentIndex = 1); // Open Habits
    }

    // 2. Runtime clicks from background/foreground
    _widgetClickSubscription =
        HomeWidgetService.widgetClickedStream.listen((uri) {
      if (uri != null && mounted) {
        setState(() => _currentIndex = 1); // Open Habits
      }
    });
  }

  @override
  void dispose() {
    _widgetClickSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return Scaffold(
          extendBody: true,
          backgroundColor: palette.background,
          body: Stack(
            children: [
              // 1. Persistent Tab Screen Views
              IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),

              // 2. Floating Glass Capsule Navigation Bar
              Positioned(
                left: 20,
                right: 20,
                bottom: 24,
                child: _buildFloatingGlassNavBar(palette, themeState.glassOpacity),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingGlassNavBar(ThemePalette palette, double glassOpacity) {
    final navItems = [
      {'icon': Icons.grid_view_rounded, 'label': 'Dashboard'},
      {'icon': Icons.swap_horiz_rounded, 'label': 'Habits'},
      {'icon': Icons.bookmark_outline_rounded, 'label': 'Subscriptions'},
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: palette.accentPrimary.withValues(alpha: 0.08),
                blurRadius: 16,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = _currentIndex == index;
              final iconData = item['icon'] as IconData;
              final label = item['label'] as String;

              return SpringScaleButton(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _currentIndex = index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 18 : 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? palette.accentPrimary.withValues(alpha: 0.18)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    border: isSelected
                        ? Border.all(
                            color: palette.accentPrimary.withValues(alpha: 0.5),
                            width: 1.2,
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconData,
                        color: isSelected
                            ? palette.accentPrimary
                            : Colors.white.withValues(alpha: 0.5),
                        size: 22,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: TextStyle(
                            color: palette.accentPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// A dedicated overview tab for habits that allows users to view active habits
/// and launch the [HabitScreen] configuration form via a Floating Action Button.
class HabitOverviewTab extends StatelessWidget {
  const HabitOverviewTab({super.key});

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
              'Your Habits',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: palette.textHeading,
              ),
            ),
          ),
          body: const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'No habits configured yet.\nTap "+" below to create one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: palette.accentPrimary,
            foregroundColor: Colors.black,
            onPressed: () {
              // Launch the configuration screen modally
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HabitScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'New Habit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}