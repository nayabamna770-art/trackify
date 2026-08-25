import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart'; // Import splash screen
import 'subscription/data/repositories/subscription_repository.dart';
import 'subscription/logic/subscription_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
            home: const SplashScreen(), // Starts at SplashScreen
          );
        },
      ),
    );
  }
}
