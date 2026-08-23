import 'package:flutter/material.dart';
import 'package:trackify/app/constants/app_colors.dart';
import 'package:trackify/core/widgets/glass_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TrackifyApp());
}

class TrackifyApp extends StatelessWidget {
  const TrackifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackify',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.tokyoBackground,
        useMaterial3: true,
      ),
      home: const Scaffold(
        backgroundColor: AppColors.tokyoBackground,
        body: Center(
          child: GlassContainer(
            child: Text(
              'Trackify Glass Engine Active',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}