import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/database/boxes.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';
import 'habit/bloc/habit_cubit.dart';
import 'habit/data/habit_repository.dart';
import 'habit/domains/models/habit_model.dart';
import 'subscription/data/models/subscription_model.dart';
import 'subscription/data/subscription_repository.dart';
import 'subscription/logic/subscription_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter storage
  await Hive.initFlutter();

  // Register generated Hive adapters
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(SubscriptionModelAdapter());
  Hive.registerAdapter(BillingCycleAdapter());

  // Open the required storage boxes
  await Hive.openBox<HabitModel>(Boxes.habitsBoxName);
  await Hive.openBox<SubscriptionModel>(Boxes.subscriptionsBoxName);

  runApp(const TrackifyApp());
}

class TrackifyApp extends StatelessWidget {
  const TrackifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<HabitCubit>(
          create: (context) => HabitCubit(
            repository: HabitRepository(),
          )..loadHabits(),
        ),
        BlocProvider<SubscriptionCubit>(
          create: (context) => SubscriptionCubit(
            repository: SubscriptionRepository(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final palette = themeState.currentPalette;

          return MaterialApp(
            title: 'Trackify',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: palette.background,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
