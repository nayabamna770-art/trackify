import 'package:flutter/material.dart';

enum AppPalette {
  tokyoNight,
  dracula,
  catppuccin,
  synthwave,
}

class AppColors {
  AppColors._();

  // Active palette configuration based on enum
  static AppPaletteData getPalette(AppPalette palette) {
    switch (palette) {
      case AppPalette.tokyoNight:
        return const AppPaletteData(
          name: 'Tokyo Night',
          background: Color(0xFF1A1B26),
          surface: Color(0xFF24283B),
          accentPrimary: Color(0xFF7AA2F7), // Neon Cyan-Blue
          accentSecondary: Color(0xFFBB9AF7), // Violet
          accentGlow: Color(0xFF7DCFFF),
          textPrimary: Color(0xFFA9B1D6),
          textHeading: Color(0xFFC0CAF5),
          success: Color(0xFF9ECE6A),
          warning: Color(0xFFE0AF68),
          danger: Color(0xFFF7768E),
        );
      case AppPalette.dracula:
        return const AppPaletteData(
          name: 'Dracula',
          background: Color(0xFF282A36),
          surface: Color(0xFF44475A),
          accentPrimary: Color(0xFFBD93F9), // Neon Purple
          accentSecondary: Color(0xFFFF79C6), // Pink
          accentGlow: Color(0xFF8BE9FD),
          textPrimary: Color(0xFFF8F8F2),
          textHeading: Color(0xFFFFFFFF),
          success: Color(0xFF50FA7B),
          warning: Color(0xFFFFB86C),
          danger: Color(0xFFFF5555),
        );
      case AppPalette.catppuccin:
        return const AppPaletteData(
          name: 'Catppuccin Mocha',
          background: Color(0xFF1E1E2E),
          surface: Color(0xFF313244),
          accentPrimary: Color(0xFFF5E0DC), // Soft Rosewater
          accentSecondary: Color(0xFFCBA6F7), // Mauve
          accentGlow: Color(0xFF89B4FA),
          textPrimary: Color(0xFFCDD6F4),
          textHeading: Color(0xFFFFFFFF),
          success: Color(0xFFA6E3A1),
          warning: Color(0xFFF9E2AF),
          danger: Color(0xFFF38BA8),
        );
      case AppPalette.synthwave:
        return const AppPaletteData(
          name: 'Synthwave',
          background: Color(0xFF130E26),
          surface: Color(0xFF231B42),
          accentPrimary: Color(0xFFFEE801), // Electric Yellow
          accentSecondary: Color(0xFFFF007F), // Neon Pink
          accentGlow: Color(0xFF00F0FF),
          textPrimary: Color(0xFFE2D9F3),
          textHeading: Color(0xFFFFFFFF),
          success: Color(0xFF00FF66),
          warning: Color(0xFFFF9900),
          danger: Color(0xFFFF0055),
        );
    }
  }
}

class AppPaletteData {
  final String name;
  final Color background;
  final Color surface;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentGlow;
  final Color textPrimary;
  final Color textHeading;
  final Color success;
  final Color warning;
  final Color danger;

  const AppPaletteData({
    required this.name,
    required this.background,
    required this.surface,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentGlow,
    required this.textPrimary,
    required this.textHeading,
    required this.success,
    required this.warning,
    required this.danger,
  });
}