import 'package:flutter/material.dart';
import 'package:trackify/app/constants/app_colors.dart';
import 'package:trackify/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:trackify/features/onboarding/presentation/pages/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TrackifyApp());
}

class TrackifyApp extends StatefulWidget {
  const TrackifyApp({super.key});

  @override
  State<TrackifyApp> createState() => _TrackifyAppState();
}

class _TrackifyAppState extends State<TrackifyApp> {
  bool _isSplashDone = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackify',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.tokyoBackground,
        useMaterial3: true,
      ),
      home: _isSplashDone
          ? OnboardingPage(onOnboardingComplete: () {})
          : SplashScreen(
              onSplashComplete: () {
                setState(() {
                  _isSplashDone = true;
                });
              },
            ),
    );
  }
}