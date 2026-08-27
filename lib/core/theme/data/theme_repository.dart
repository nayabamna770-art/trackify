import 'package:hive/hive.dart';
import 'package:trackify/core/database/boxes.dart';
import 'package:trackify/core/theme/data/theme_adapter.g.dart';

class ThemeRepository {
  Box<ThemeStateDto> get _box => Boxes.themeBox;
  static const String _key = 'current_theme';

  Future<void> saveTheme({
    required String paletteId,
    required double glassOpacity,
  }) async {
    final dto = ThemeStateDto(
      paletteId: paletteId,
      glassOpacity: glassOpacity,
    );
    await _box.put(_key, dto);
  }

  ThemeStateDto? getSavedTheme() {
    return _box.get(_key);
  }
}
