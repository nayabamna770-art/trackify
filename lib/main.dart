import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackify/app/constants/app_colors.dart';
import 'package:trackify/core/database/boxes.dart'; // <--- Ensure this is imported
import 'package:trackify/core/theme/data/theme_repository.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/habit/data/habit_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  await Hive.initFlutter();

  // 2. Open all boxes BEFORE running the app widget tree
  await Boxes.openBoxes();

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
