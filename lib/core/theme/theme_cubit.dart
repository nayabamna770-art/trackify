import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/theme_state.dart';

const List<ThemeGroup> appThemeGroups = [
  ThemeGroup(
    groupName: 'Cyber & Dark',
    palettes: [
      ThemePalette(
        id: 'cyber_neon',
        name: 'Cyber Neon',
        background: Color(0xFF0D0F18),
        surfaceGlass: Color(0xFF161928),
        accentPrimary: Color(0xFF00E5FF),
        accentSecondary: Color(0xFFFF007F),
        textPrimary: Color(0xFFD0D7F0),
        textHeading: Color(0xFFFFFFFF),
      ),
      ThemePalette(
        id: 'midnight_oled',
        name: 'Midnight OLED',
        background: Color(0xFF000000),
        surfaceGlass: Color(0xFF121212),
        accentPrimary: Color(0xFF7C4DFF),
        accentSecondary: Color(0xFF00E676),
        textPrimary: Color(0xFFB0BEC5),
        textHeading: Color(0xFFFFFFFF),
      ),
      ThemePalette(
        id: 'dracula_abyss',
        name: 'Dracula Abyss',
        background: Color(0xFF1E1E2E),
        surfaceGlass: Color(0xFF282A36),
        accentPrimary: Color(0xFFFF79C6),
        accentSecondary: Color(0xFFBD93F9),
        textPrimary: Color(0xFFF8F8F2),
        textHeading: Color(0xFFFFFFFF),
      ),
      ThemePalette(
        id: 'tokyo_night',
        name: 'Tokyo Night',
        background: Color(0xFF1A1B26),
        surfaceGlass: Color(0xFF24283B),
        accentPrimary: Color(0xFF7AA2F7),
        accentSecondary: Color(0xFFBB9AF7),
        textPrimary: Color(0xFFA9B1D6),
        textHeading: Color(0xFFC0CAF5),
      ),
    ],
  ),
  ThemeGroup(
    groupName: 'Vibrant & Warm',
    palettes: [
      ThemePalette(
        id: 'sunset_glow',
        name: 'Sunset Glow',
        background: Color(0xFF1A0F1A),
        surfaceGlass: Color(0xFF2A1B2E),
        accentPrimary: Color(0xFFFF6B6B),
        accentSecondary: Color(0xFFFFB86C),
        textPrimary: Color(0xFFE2C4D6),
        textHeading: Color(0xFFFFFFFF),
      ),
      ThemePalette(
        id: 'emerald_matrix',
        name: 'Emerald Forest',
        background: Color(0xFF0A1F1C),
        surfaceGlass: Color(0xFF13332E),
        accentPrimary: Color(0xFF00E676),
        accentSecondary: Color(0xFF69F0AE),
        textPrimary: Color(0xFFB2DFDB),
        textHeading: Color(0xFFE0F2F1),
      ),
      ThemePalette(
        id: 'solarized_amber',
        name: 'Solar Amber',
        background: Color(0xFF181510),
        surfaceGlass: Color(0xFF262017),
        accentPrimary: Color(0xFFFFAB00),
        accentSecondary: Color(0xFFFF6D00),
        textPrimary: Color(0xFFD7CCC8),
        textHeading: Color(0xFFFFF8E1),
      ),
      ThemePalette(
        id: 'synthwave_80s',
        name: 'Synthwave 84',
        background: Color(0xFF241B2F),
        surfaceGlass: Color(0xFF262335),
        accentPrimary: Color(0xFFFE4450),
        accentSecondary: Color(0xFFFF7ED6),
        textPrimary: Color(0xFF72F1B8),
        textHeading: Color(0xFFFFFFFF),
      ),
    ],
  ),
  ThemeGroup(
    groupName: 'Minimal & Soft',
    palettes: [
      ThemePalette(
        id: 'nord_frost',
        name: 'Nord Frost',
        background: Color(0xFF2E3440),
        surfaceGlass: Color(0xFF3B4252),
        accentPrimary: Color(0xFF88C0D0),
        accentSecondary: Color(0xFF81A1C1),
        textPrimary: Color(0xFFE5E9F0),
        textHeading: Color(0xFFECEFF4),
      ),
      ThemePalette(
        id: 'monokai_pro',
        name: 'Monokai Pro',
        background: Color(0xFF2D2A2E),
        surfaceGlass: Color(0xFF403C40),
        accentPrimary: Color(0xFFFFD866),
        accentSecondary: Color(0xFFA9DC76),
        textPrimary: Color(0xFFC1C0C2),
        textHeading: Color(0xFFFCFCFA),
      ),
      ThemePalette(
        id: 'pastel_dream',
        name: 'Pastel Dream',
        background: Color(0xFF1B1B22),
        surfaceGlass: Color(0xFF262633),
        accentPrimary: Color(0xFFB39DDB),
        accentSecondary: Color(0xFF80CBC4),
        textPrimary: Color(0xFFD1C4E9),
        textHeading: Color(0xFFEDE7F6),
      ),
      ThemePalette(
        id: 'deep_ocean',
        name: 'Deep Ocean',
        background: Color(0xFF0F172A),
        surfaceGlass: Color(0xFF1E293B),
        accentPrimary: Color(0xFF38BDF8),
        accentSecondary: Color(0xFF818CF8),
        textPrimary: Color(0xFF94A3B8),
        textHeading: Color(0xFFF8FAFC),
      ),
    ],
  ),
];

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState(currentPalette: appThemeGroups[0].palettes[0]));

  void selectPalette(ThemePalette palette) {
    emit(state.copyWith(currentPalette: palette));
  }

  void setGlassOpacity(double opacity) {
    emit(state.copyWith(glassOpacity: opacity));
  }
}
