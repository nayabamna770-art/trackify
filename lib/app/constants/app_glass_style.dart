import 'package:flutter/material.dart';

class AppGlassStyle {
  AppGlassStyle._();

  // Glass blur intensity
  static const double blurX = 16.0;
  static const double blurY = 16.0;

  // Border spec
  static const double borderWidth = 1.5;
  static const double defaultRadius = 20.0;

  // Dynamic glass opacity constraints (5% to 40%)
  static const double minOpacity = 0.05;
  static const double maxOpacity = 0.40;
  static const double defaultOpacity = 0.15;

  // Refractive border gradient (Top-Left to Bottom-Right white opacity fade)
  static LinearGradient glassBorderGradient({double opacityFactor = 1.0}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: 0.35 * opacityFactor),
        Colors.white.withValues(alpha: 0.05 * opacityFactor),
      ],
    );
  }

  // Soft glass drop shadow
  static List<BoxShadow> glassShadow({required Color accentColor}) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.25),
        blurRadius: 24,
        spreadRadius: -4,
        offset: const Offset(0, 12),
      ),
      BoxShadow(
        color: accentColor.withValues(alpha: 0.08),
        blurRadius: 16,
        spreadRadius: 0,
        offset: const Offset(0, 0),
      ),
    ];
  }
}