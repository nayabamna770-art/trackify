import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemePalette extends Equatable {
  final String id;
  final String name;
  final Color background;
  final Color surfaceGlass;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color textPrimary;
  final Color textHeading;

  const ThemePalette({
    required this.id,
    required this.name,
    required this.background,
    required this.surfaceGlass,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.textPrimary,
    required this.textHeading,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        background,
        surfaceGlass,
        accentPrimary,
        accentSecondary,
        textPrimary,
        textHeading,
      ];
}

class ThemeGroup {
  final String groupName;
  final List<ThemePalette> palettes;

  const ThemeGroup({
    required this.groupName,
    required this.palettes,
  });
}

class ThemeState extends Equatable {
  final ThemePalette currentPalette;
  final double glassOpacity;

  const ThemeState({
    required this.currentPalette,
    this.glassOpacity = 0.18,
  });

  ThemeState copyWith({
    ThemePalette? currentPalette,
    double? glassOpacity,
  }) {
    return ThemeState(
      currentPalette: currentPalette ?? this.currentPalette,
      glassOpacity: glassOpacity ?? this.glassOpacity,
    );
  }

  @override
  List<Object?> get props => [currentPalette, glassOpacity];
}