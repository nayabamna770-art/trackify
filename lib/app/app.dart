import 'package:flutter/material.dart';
import 'package:trackify/features/onboarding/presentation/pages/splash_screen.dart';

/// Root application widget wrapper
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}