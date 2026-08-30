import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackify/app/constants/app_colors.dart';
import 'package:trackify/core/database/boxes.dart';
import 'package:trackify/core/theme/data/theme_repository.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/data/habit_repository.dart';
import 'package:trackify/subscription/data/subscription_repository.dart';
import 'package:trackify/subscription/logic/subscription_cubit.dart';

/// ============================================================================
/// APPLICATION ENTRY POINT
/// ============================================================================
/// Initializes Flutter bindings, starts the local-first Hive storage engine,
/// pre-opens all required database boxes, and mounts the root widget.
void main() async {
  // Ensure Flutter engine bindings are initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive for Flutter local storage
  await Hive.initFlutter();

  // 2. Open all storage boxes (habits, subscriptions, theme) before UI mounts
  await Boxes.openBoxes();

  // 3. Launch the root application widget
  runApp(const TrackifyApp());
}

/// ============================================================================
/// ROOT APPLICATION WIDGET
/// ============================================================================
/// Provides global state management (Blocs/Cubits) across the entire widget
/// hierarchy and dynamically reacts to theme palette changes.
class TrackifyApp extends StatelessWidget {
  const TrackifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject global Cubits to all child screens
    return MultiBlocProvider(
      providers: [
        // --- Global Theme Management ---
        BlocProvider(
          create: (context) => ThemeCubit(
            repository: ThemeRepository(),
            availablePalettes: AppColors.appThemeGroups
                .expand((group) => group.palettes)
                .toList(),
          ),
        ),
        // --- Habits Management (Local Hive JSON Persistence) ---
        BlocProvider(
          create: (context) => HabitCubit(
            repository: HabitRepository(),
          )..loadHabits(),
        ),
        // --- Subscriptions Management (Local Hive JSON Persistence) ---
        BlocProvider(
          create: (context) => SubscriptionCubit(
            repository: SubscriptionRepository(),
          )..loadSubscriptions(),
        ),
      ],
      // Rebuild the MaterialApp whenever the user switches theme palettes
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final palette = themeState.currentPalette;

          return MaterialApp(
            title: 'Trackify',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: palette.background,
            ),
            // Start at the animated splash screen for onboarding & profile check
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
