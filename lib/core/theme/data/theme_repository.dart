import 'package:hive_flutter/hive_flutter.dart';
import '../../database/boxes.dart';
import 'theme_adapter.g.dart';

class ThemeRepository {
  Box get _box => Hive.box(HiveBoxes.theme);

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
    return _box.get(_key) as ThemeStateDto?;
  }
}
