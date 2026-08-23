import 'package:equatable/equatable.dart';
import '../../app/constants/app_colors.dart';
import '../../app/constants/app_glass_style.dart';

class ThemeState extends Equatable {
  final AppPalette palette;
  final double glassOpacity;

  const ThemeState({
    this.palette = AppPalette.tokyoNight,
    this.glassOpacity = AppGlassStyle.defaultOpacity,
  });

  AppPaletteData get currentPalette => AppColors.getPalette(palette);

  ThemeState copyWith({
    AppPalette? palette,
    double? glassOpacity,
  }) {
    return ThemeState(
      palette: palette ?? this.palette,
      glassOpacity: glassOpacity ?? this.glassOpacity,
    );
  }

  @override
  List<Object?> get props => [palette, glassOpacity];
}