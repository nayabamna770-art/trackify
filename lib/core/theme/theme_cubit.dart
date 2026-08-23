import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/constants/app_colors.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void changePalette(AppPalette palette) {
    emit(state.copyWith(palette: palette));
  }

  void updateGlassOpacity(double opacity) {
    emit(state.copyWith(glassOpacity: opacity));
  }
}