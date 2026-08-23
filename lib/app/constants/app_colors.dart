import 'package:flutter/material.dart';

/// Pre-configured theme color palettes (Tokyo Night, Dracula, Catppuccin)
class AppColors {
  // --- Tokyo Night Palette ---
  static const Color tokyoBackground = Color(0xFF1A1B26);
  static const Color tokyoCard = Color(0xFF24283B);
  static const Color tokyoAccent = Color(0xFF7AA2F7);
  static const Color tokyoSecondary = Color(0xFFBB9AF7);

  // --- Dracula Palette ---
  static const Color draculaBackground = Color(0xFF282A36);
  static const Color draculaCard = Color(0xFF44475A);
  static const Color draculaAccent = Color(0xFFFF79C6);
  static const Color draculaSecondary = Color(0xFF8BE9FD);

  // --- Catppuccin Palette ---
  static const Color catppuccinBackground = Color(0xFF1E1E2E);
  static const Color catppuccinCard = Color(0xFF313244);
  static const Color catppuccinAccent = Color(0xFFF5E0DC);
  static const Color catppuccinSecondary = Color(0xFFCBA6F7);

  // --- Neon Status Badges ---
  static const Color statusSuccess = Color(0xFF00E676);
  static const Color statusWarning = Color(0xFFFFB300);
  static const Color statusAlert = Color(0xFFFF1744);

  // --- Glass Gradient Border Overlay ---
  static const LinearGradient glassBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x66FFFFFF), // 40% White Opacity
      Color(0x0DFFFFFF), // 5% White Opacity
    ],
  );
}