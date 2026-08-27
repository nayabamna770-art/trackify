import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
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

  // Persistent shell screens
  final List<Widget> _screens = [
    const DashboardScreen(),
    const HabitOverviewTab(),
    const SubscriptionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF0B0F17),
            selectedItemColor: palette.accentPrimary,
            unselectedItemColor: Colors.white54,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_rounded),
                label: 'Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions_rounded),
                label: 'Subscriptions',
              ),
            ],
          ),
        );
      },
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