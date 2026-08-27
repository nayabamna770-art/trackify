// Import necessary Flutter material design library for UI components
import 'package:flutter/material.dart';
// Import Flutter BLoC package for state management observation
import 'package:flutter_bloc/flutter_bloc.dart';
// Import Hive package for checking local storage profile flag
import 'package:hive/hive.dart';
// Import ThemeCubit to access the application's current color palettes and styling rules
import 'package:trackify/core/theme/logic/theme_cubit.dart';
// Import MainScreenShell for returning users
import 'package:trackify/features/onboarding/presentation/pages/main_shell_screen.dart';
// Import ProfileSetupScreen for first-time users
import 'package:trackify/features/onboarding/presentation/pages/profile_setup_screen.dart';

/// SplashScreen serves as the initial entry point view when the application launches.
/// It displays branding and verifies local user storage to handle routing.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  /// Asynchronous method to check Hive profile existence and route accordingly
  Future<void> _checkUserAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Open user profile box to check onboarding status
    final profileBox = await Hive.openBox('user_profile_box');
    final bool hasCompletedOnboarding =
        profileBox.get('has_completed_onboarding', defaultValue: false);

    // Conditional routing based on whether user is new or returning
    Widget targetScreen = hasCompletedOnboarding
        ? const MainScreenShell()
        : const ProfileSetupScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final palette = themeState.currentPalette;

    return Scaffold(
      backgroundColor: palette.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.track_changes,
              size: 72,
              color: palette.accentPrimary,
            ),
            const SizedBox(height: 16),
            Text(
              'Trackify',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: palette.textHeading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
