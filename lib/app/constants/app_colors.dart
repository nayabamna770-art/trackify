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
      groupName: 'Natural & Earth Harmonies',
      palettes: [
        ThemePalette(
          id: 'emerald_forest',
          name: 'Deep Forest',
          background: Color(0xFF07120C),
          surfaceGlass: Color(0xFF0E2218),
          accentPrimary: Color(0xFF10B981),
          accentSecondary: Color(0xFF34D399),
          textPrimary: Color(0xFF86A397),
          textHeading: Color(0xFFECFDF5),
        ),
        ThemePalette(
          id: 'oceanic_teal',
          name: 'Oceanic Teal',
          background: Color(0xFF06141D),
          surfaceGlass: Color(0xFF0C2434),
          accentPrimary: Color(0xFF06B6D4),
          accentSecondary: Color(0xFF14B8A6),
          textPrimary: Color(0xFF94A3B8),
          textHeading: Color(0xFFF0FDFA),
        ),
        ThemePalette(
          id: 'nord_arctic',
          name: 'Nord Arctic',
          background: Color(0xFF0D131A),
          surfaceGlass: Color(0xFF1A232E),
          accentPrimary: Color(0xFF88C0D0),
          accentSecondary: Color(0xFF81A1C1),
          textPrimary: Color(0xFFD8DEE9),
          textHeading: Color(0xFFECEFF4),
        ),
        ThemePalette(
          id: 'terracotta_sunset',
          name: 'Terracotta Dune',
          background: Color(0xFF140D0A),
          surfaceGlass: Color(0xFF261813),
          accentPrimary: Color(0xFFE07A5F),
          accentSecondary: Color(0xFFF2CC8F),
          textPrimary: Color(0xFFBCAAA4),
          textHeading: Color(0xFFFFF3E0),
        ),
      ],
    ),
    ThemeGroup(
      groupName: 'Official & Cyber Neon',
      palettes: [
        ThemePalette(
          id: 'cyber_obsidian',
          name: 'Obsidian Emerald',
          background: Color(0xFF080C14),
          surfaceGlass: Color(0xFF101926),
          accentPrimary: Color(0xFF00FF9D),
          accentSecondary: Color(0xFF00E5FF),
          textPrimary: Color(0xFF94A3B8),
          textHeading: Color(0xFFF8FAFC),
        ),
        ThemePalette(
          id: 'royal_slate',
          name: 'Royal Slate',
          background: Color(0xFF0B0F19),
          surfaceGlass: Color(0xFF161E30),
          accentPrimary: Color(0xFF6366F1),
          accentSecondary: Color(0xFF8B5CF6),
          textPrimary: Color(0xFF94A3B8),
          textHeading: Color(0xFFF8FAFC),
        ),
        ThemePalette(
          id: 'neon_amethyst',
          name: 'Electric Violet',
          background: Color(0xFF0D0A1A),
          surfaceGlass: Color(0xFF1B1433),
          accentPrimary: Color(0xFFA855F7),
          accentSecondary: Color(0xFFEC4899),
          textPrimary: Color(0xFFA1A1AA),
          textHeading: Color(0xFFFAFAFA),
        ),
        ThemePalette(
          id: 'solar_amber',
          name: 'Solar Flare',
          background: Color(0xFF0F0B08),
          surfaceGlass: Color(0xFF221710),
          accentPrimary: Color(0xFFFF7A00),
          accentSecondary: Color(0xFFFFB800),
          textPrimary: Color(0xFFA8A29E),
          textHeading: Color(0xFFFFFBEB),
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
