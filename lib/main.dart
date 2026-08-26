// Import core Flutter material packages
import 'package:flutter/material.dart';
// Import flutter_bloc for state management providers
import 'package:flutter_bloc/flutter_bloc.dart';
// Import hive_flutter for local storage initialization
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';
// Import theme management cubit, states, and app color groupings
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/app/constants/app_colors.dart';
import 'package:trackify/core/theme/data/theme_repository.dart';

// Import feature blocs and repositories
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/data/habit_repository.dart';

// Import your box helper file to access the exact box names cleanly
import 'package:trackify/core/database/boxes.dart'; // Adjust path if needed

// Import entry point screen
import 'package:trackify/features/onboarding/presentation/pages/splash_screen.dart';

void main() async {
  // 1. Ensure Flutter binding initialization before running async setup
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Hive local database for Flutter
  await Hive.initFlutter();

  // 3. Open ALL required Hive boxes using constants from your box definitions
  await Hive.openBox<HabitModel>(Boxes.habitsBoxName);
  await Hive.openBox<SubscriptionModel>(Boxes.subscriptionsBoxName);
  await Hive.openBox(HiveBoxes.theme); // Opens 'theme_box'

  runApp(const TrackifyApp());
}

class TrackifyApp extends StatelessWidget {
  const TrackifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(
            repository: ThemeRepository(),
            availablePalettes: AppColors.appThemeGroups
                .expand((group) => group.palettes)
                .toList(),
          ),
        ),
        BlocProvider(
          create: (context) => HabitCubit(
            repository: HabitRepository(),
          )..loadHabits(),
        ),
      ],
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
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}