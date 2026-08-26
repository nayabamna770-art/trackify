import 'package:flutter/material.dart';
import 'package:trackify/core/theme/theme_state.dart';

enum AppPalette {
  tokyoNight,
  dracula,
  catppuccin,
  synthwave,
}

class AppColors {
  static const List<ThemeGroup> appThemeGroups = [
    ThemeGroup(
      groupName: 'Vibrant & Modern',
      palettes: [
        ThemePalette(
          id: 'neon_night',
          name: 'Neon Night',
          background: Color(0xFF0F172A),
          surfaceGlass: Color(0xFF1E293B),
          accentPrimary: Color(0xFF38BDF8),
          accentSecondary: Color(0xFF818CF8),
          textPrimary: Color(0xFF94A3B8),
          textHeading: Color(0xFFF8FAFC),
        ),
        ThemePalette(
          id: 'cyber_punk',
          name: 'Cyberpunk',
          background: Color(0xFF120C1F),
          surfaceGlass: Color(0xFF241B38),
          accentPrimary: Color(0xFFF43F5E),
          accentSecondary: Color(0xFF8B5CF6),
          textPrimary: Color(0xFFA1A1AA),
          textHeading: Color(0xFFFAFAFA),
        ),
      ],
    ),
    ThemeGroup(
      groupName: 'Minimal & Clean',
      palettes: [
        ThemePalette(
          id: 'arctic_frost',
          name: 'Arctic Frost',
          background: Color(0xFFF8FAFC),
          surfaceGlass: Color(0xFFE2E8F0),
          accentPrimary: Color(0xFF0EA5E9),
          accentSecondary: Color(0xFF6366F1),
          textPrimary: Color(0xFF64748B),
          textHeading: Color(0xFF0F172A),
        ),
      ],
    ),
  ];
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

class AppThemeGroup {
  final String groupName;
  final List<AppPaletteData> palettes;

  const AppThemeGroup({
    required this.groupName,
    required this.palettes,
  });
}
