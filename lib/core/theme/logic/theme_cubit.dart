import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/data/theme_repository.dart';
import 'package:trackify/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepository repository;
  final List<ThemePalette> availablePalettes;

  ThemeCubit({
    required this.repository,
    required this.availablePalettes,
    ThemePalette? defaultPalette,
  }) : super(ThemeState(
          currentPalette: defaultPalette ?? availablePalettes.first,
        )) {
    _loadTheme(defaultPalette ?? availablePalettes.first);
  }

  void _loadTheme(ThemePalette defaultPalette) {
    final saved = repository.getSavedTheme();
    if (saved != null) {
      final matchedPalette = availablePalettes.firstWhere(
        (p) => p.id == saved.paletteId,
        orElse: () => defaultPalette,
      );
      emit(state.copyWith(
        currentPalette: matchedPalette,
        glassOpacity: saved.glassOpacity,
      ));
    }
  }

  /// Sets the active palette and persists it locally.
  void setPalette(ThemePalette palette) {
    emit(state.copyWith(currentPalette: palette));
    _persist();
  }

  /// Alias method used by UI selection widgets.
  void selectPalette(ThemePalette palette) {
    setPalette(palette);
  }

  /// Updates glass transparency and persists it locally.
  void setGlassOpacity(double opacity) {
    emit(state.copyWith(glassOpacity: opacity));
    _persist();
  }

  void _persist() {
    repository.saveTheme(
      paletteId: state.currentPalette.id,
      glassOpacity: state.glassOpacity,
    );
  }
}