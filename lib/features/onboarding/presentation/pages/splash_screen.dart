import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/theme_cubit.dart';
import 'package:trackify/features/onboarding/presentation/pages/main_screen_shell.dart'; // Update path as needed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Simulate initialization delay (e.g., fetching initial local storage/auth)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Smooth transition into MainScreenShell
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreenShell(),
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