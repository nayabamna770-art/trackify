import 'package:hive/hive.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';
import 'package:trackify/core/database/boxes.dart';
class HabitLocalStorage {
  static const String _boxName = 'habits_box';

  static Future<Box> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  static Future<void> saveHabits(List<HabitModel> habits) async {
    final box = await _openBox();
    final jsonList = habits.map((h) => h.toJson()).toList();
    await box.put('user_habits', jsonList);
  }

  static Future<List<HabitModel>> loadHabits() async {
    final box = await _openBox();
    final dynamic rawData = box.get('user_habits');

    if (rawData == null) return [];

    try {
      // Safely cast raw elements to Map<String, dynamic>
      final List<dynamic> list = rawData;
      return list.map((item) {
        final Map<String, dynamic> mapItem =
            Map<String, dynamic>.from(item as Map);
        return HabitModel.fromJson(mapItem);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
